package Apache::Chameleon::Document;

use strict;
use warnings;

use Apache::Chameleon::Database::Document;

use base qw(Apache::Chameleon::Base);

our $VERSION       = '0.01';
our $DefaultIndex  = 'index.html';
our $DefaultTitle  = 'Untitled Document';
our $ErrorNotFound = '/errors/404.html';
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

sub new {
    my $class = shift;
    my $self  = bless {}, $class;
    my $doc   = shift;
    $self->_document($doc);
    return $self;
}

sub _document {
    my $self = shift;
    my $document = shift;
    return $self->{_document} if $self->{_document};
    my ($d, $e) = $self->get($document);
    return if $e;
    $self->{_document} = $d;
    return $self->{_document};
#    return $d;
}

sub get {
    my $self = shift;
    my $document = shift;

    # Check the parameters
    return (undef, $Errors{no_param}) unless $document;

    # If they've asked for a directory, give them the default index for it
    $document =~ s((.*)/$)($1/$DefaultIndex);

    # Retrieve
    my @documents = Apache::Chameleon::Database::Document->search(
                        path => $document);

    my $doc = $documents[0] if $documents[0];
    #return (undef, $Errors{not_found}) unless $doc;
    unless ($doc) {
	unless ($document eq $ErrorNotFound) {
            return $self->get($ErrorNotFound);
        }
    }

    # Set a default title if needed
    $doc->{title} = $DefaultTitle if ($doc->{title} eq '');

    # Return it
    return $doc;
}

sub exists {
    return 1 if $_[0]->_document;
    return undef;
}

sub title {
    $_[0]->_document->{title} ne '' ? return $_[0]->_document->title:
                  return $DefaultTitle;
}

sub contents {
    return $_[0]->_document->contents;
}    

sub get_escaped {
    my $self = shift;

    $_[0]->_document->{contents} = 
        $_[0]->_escape_tags($_[0]->_document->contents)
        unless($_[0]->_document->type eq 'parsed');
    return ($_[0]->_document, undef);
}

sub _get_all {
    my @docs = Apache::Chameleon::Database::Document->retrieve_all;
    return \@docs;
}

sub list {
    return $_[0]->_get_all;
}

sub _escape_tags {
   $_ = shift;

   s/\[%/&#91;&#37;/g; # open TT tag
   s/%\]/&#37;&#93;/g; # close TT tag
   s/\$/&#36;/g;       # interpolated variable
   return $_;
}

1;

__END__
=head1 NAME

Apache::Chameleon::Document

=head1 ABSTRACT

Document manipulation class

=head2 new

Simple constructor

=head2 get

Gets a document object from the database.

=head2 exists

Tests for the existance of a document.

=head2 title

Gets a document's title

=head2 contents

Get the contents of a specified document

=head2 get_escaped

Gets a document object from the database and escapes tags where needed.

=head2 _get_all

Retrieves all documents.

=head2 list

Retrieves paths of all documents.
(TBC. Currently returns all documents.)

=head2 _document

Get/set document.

=head2 _escape_tags

Escapes TT tags.

=head1 SEE ALSO

F<Apache::Chameleon>

=cut
