package Apache::Chameleon::Template::Plugin::Document;

use strict;
use warnings;

use base qw( Apache::Chameleon::Template::Plugin::Base );
use Apache::Chameleon::Document;

our $VERSION       = '0.01';
our %Errors        = (
        exists        => 'Document already exists',
        bad_path      => 'Invalid path',
        create_dir    => 'Cannot create a directory',
        not_found     => 'Document does not exist',
        locked        => 'Document is locked',
        not_locker    => 'You have not locked this document',
        not_locked    => 'Document is not locked',
        no_permission => 'You do not own this document',
        no_param      => 'Parameter not supplied',
);

sub create {
    my $self = shift;

    # Get parameters
    my $p = $self->req_parameters;
    my ($d, $e) = $p->get('createdoc');
    return if $e;
    my @params = qw(path title version type worldread worldwrite contents);
    my $document = {};
    my $error = '';

    # Check parameters
    foreach (@params) {
        ($document->{$_}, $error) = $p->get($_);
        my $not_error = 1 if $_ =~ /^version$|^world/;
        $document->{$_} ||= 0 if $_ =~ /^version$/;
        $document->{$_} ||= 1 if $_ =~ /^worldread$/;
        $document->{$_} ||= 0 if $_ =~ /^worldwrite$/;
        $self->error("$_ not ok") if $error and not $not_error;
        return unless defined $document->{$_};
        $self->info("$_ ok");
    }
    $error = undef; 

    # Check for parameter errors
    return (undef, $Errors{create_dir}) if $document->{path} =~ m#/$#;
    return (undef, $Errors{bad_path}) if $document->{path} =~ m#^!/#;

    # Check that the document does not exist
    my ($exists, $error2) = $self->_get($document->{path});
    return (undef, $Errors{exists}) if $exists;

    my $user = $self->stash->get('user');
    $document->{author_id} = $user->user_id;
    $document->{created}   = $self->_sql_date;

    # Ensure they have permission to create it
    return (undef, $Errors{no_permission}) 
         unless $user->permissions->create_document($document);

    $self->info("got here");

    # Create it
    my $newdoc = Apache::Chameleon::Database::Document->create($document);
    $newdoc->commit;

    $self->success("Document created");
    $self->log("document " . $document->{path} . " created")
        if $document;
    return;
}

sub update {
    my $self = shift;
    my $p = $self->req_parameters;
    my ($d, $e) = $p->get('getupdatedoc');
    my ($dd, $ee) = $p->get('updatedoc');

    if ($d) {
        my ($ddd, $err) = $p->get('getpath');
        my ($doc, $er2) = $self->_get($ddd);
        $self->error("Error: ".$er2) if $er2;
        $self->stash->set(['update' => 0, 'path' => 0], $doc->{path});
        $self->stash->set(['update' => 0, 'title' => 0], $doc->{title});
        $self->stash->set(['update' => 0, 'contents' => 0], $doc->{contents});

        return 'update';
    } elsif ($dd) {

        my @params = qw(path title version type worldread worldwrite contents);
        my $document = {};
        my $error = '';

        foreach (@params) {
            ($document->{$_}, $error) = $p->get($_);
            my $not_error = 1 if $_ =~ /^version$|^world/;
            $document->{$_} ||= 0 if $_ =~ /^version$/;
            $document->{$_} ||= 1 if $_ =~ /^worldread$/;
            $document->{$_} ||= 0 if $_ =~ /^worldwrite$/;
            $self->error("$_ not ok") if $error and not $not_error;
            return unless defined $document->{$_};
            $self->info("$_ ok");
        }
	$error = undef;
        $document->{created} = $self->_sql_date;
        my $user = $self->stash->get('user');

        # Check for parameter errors
        return (undef, $Errors{no_param})   unless ($document && $user);
        return (undef, $Errors{create_dir}) if $document->{path} =~ m#/$#;
        return (undef, $Errors{bad_path})   if $document->{path} =~ m#^!/#;

        # Get the document
        (my $exists, $error) = $self->_get($document->{path});
        # Ensure it exists
        return (undef, $Errors{not_found}) unless $exists;
    
        # Ensure they have permission to update it
        return (undef, $Errors{no_permission}) 
            unless $user->permissions->update_document($document);

        # Lock the document
        my ($ok, $err) = 
            $self->_lock($document->{path}, $user);
        return (undef, $err) if $err;

        # Update it
        foreach (keys %$document) {
            $exists->$_($document->{$_});
        }

        # Commit changes and unlock again
        $exists->commit;
        ($ok, $err) = $self->_unlock($document->{path}, $user);
        $self->error("Error updating document ($err)") if $err;
        return (undef, $err) if $err;
        $self->success("Document updated");
        $self->log("document " . $document->{path} . " updated")
            if $document;
        return 'success';
    } else {
        return 'get';
    }
}

sub delete {
    my $self = shift;
    my $p = $self->req_parameters;
    my ($d, $e) = $p->get('deletedoc');
    return if $e;
    my @params = qw(path repeatpath version);
    my $document = {};
    my $error = '';

    foreach (@params) {
        ($document->{$_}, $error) = $p->get($_);
        my $not_error = 1 if $_ =~ /^version$/;
        $document->{$_} ||= 0 if $_ =~ /^version$/;
        $self->error("$_ not ok") if $error and not $not_error;
        return unless defined $document->{$_};
        $self->info("$_ ok");
    }
    my $eq = ($document->{path} eq $document->{repeatpath});
    $self->error("Paths do not match") unless $eq;
    return unless $eq;
    $self->info("Parameters OK");
    $error = undef;

    my $user = $self->stash->get('user');

    # Get the document
    (my $doc, $error) = $self->_get($document->{path});
    $self->error("Error deleting document ($error)") if $error;
    return if $error;

    # Ensure it exists
    $error = $Errors{not_found} unless $doc;
    $self->error("Error deleting document ($error)") if $error;
    return if $error;

    # Ensure they have permission to delete it
    $error =  $Errors{no_permission}
         unless $user->permissions->delete_document($doc);
    $self->error("Error deleting document ($error)") if $error;
    return if $error;

    # Log this
    $self->log("Deleting " . $document->{path});

    # Delete it
    $doc->delete;

    $self->success("Document deleted");
    $self->log("document " . $document->{path} . " deleted");
    return;
}

sub list {
    my $aod = Apache::Chameleon::Document->new('/index.html');
    return $aod->list;
}

sub _get {
    my $self     = shift;
    my $document = shift;
    return (undef, "no parameter") unless $document;

    # Get the document
    my @docs = Apache::Chameleon::Database::Document->search(path => $document);
    my $doc  = $docs[0] if $docs[0];
    return (undef, $Errors{not_found}) unless $doc;
    return ($doc, undef);
}

sub _lock {
    my $self     = shift;
    my $document = shift;
    my $user     = shift;

    # Check for parameter errors
    return (undef, $Errors{no_param}) unless ($document && $user);

    # Get the document
    my ($doc, $error) = $self->_get($document);

    # Test and test and set
    
    # Check they have permission to lock it
    return (undef, $Errors{no_permission}) 
         unless $user->permissions->lock_document($doc);

    select(undef, undef, undef, 0.5); #sleep 1/2 second
    ($doc, $error) = $self->_get($document);

    # Check they have permission again
    return (undef, $Errors{no_permission}) 
         unless $user->permissions->lock_document($doc);

    # Lock the document
    $doc->locker_id($user->user_id);
    $doc->commit;

    # Return success
    return 1;
}

sub _unlock {
    my $self     = shift;
    my $document = shift;
    my $user     = shift;

    # Check for parameter errors
    return (undef, $Errors{no_param})   unless ($document && $user);

    # Get the document
    my ($doc, $error) = $self->_get($document);

    # Check they have permission to unlock it
    return (undef, $Errors{no_permission}) 
         unless $user->permissions->unlock_document($doc);

    # Unlock it
    $doc->locker_id(0);
    $doc->commit;

    # Return success
    return 1;
}

1;

=head2 create

Creates a document.

=head2 update

Updates a document.

=head2 delete

Deletes a document.

=head2 list

Lists all documents.

=head1 SEE ALSO

L<Apache::Chameleon>

L<Template>

L<Template::Plugin>
