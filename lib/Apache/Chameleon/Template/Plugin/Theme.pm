package Apache::Chameleon::Template::Plugin::Theme;

use strict;
use warnings;

use base qw( Apache::Chameleon::Template::Plugin::Base );
use Apache::Chameleon::Theme;

sub create {
    my $self = shift;

    #Get parameters
    my $p = $self->req_parameters;
    my ($t, $e) = $p->get('createtheme');
    return if $e;

    # Check parameters
    my @params = qw(name header config footer description);
    my %theme = ();
    my $error = '';
    foreach (@params) {
        ($theme{$_}, $error) = $p->get($_);
        return unless defined $theme{$_};
        $self->info("$_ ok");
    }

    # Create theme
    my $aot = Apache::Chameleon::Theme->new;
    my ($the, $ee) = $aot->create(\%theme, $self->stash->get('user'));
    $self->error("Error creating theme ($ee)") if $ee;
    return if $ee;

    # Return success
    $self->success("Theme created");
    return;
}

sub update {
    my $self = shift;

    # Get parameters
    my $p = $self->req_parameters;
    my ($t, $e) = $p->get('getupdatetheme');
    my ($tt, $ee) = $p->get('updatetheme');

    # Get theme
    my $aot = Apache::Chameleon::Theme->new;

    # Get theme details
    if ($t) {
        my ($ttt, $err) = $p->get('getname');
	$self->error("Error: ".$err) if $err;
        my ($the, $er2) = $aot->get($ttt);
	$self->error("Error: ".$er2) if $er2;
        $self->stash->set(['update' => 0, 'name' => 0], $the->{name});
        $self->stash->set(['update' => 0, 'description' => 0], 
	    $the->{description});
        $self->stash->set(['update' => 0, 'header' => 0], $the->{header});
        $self->stash->set(['update' => 0, 'footer' => 0], $the->{footer});
        $self->stash->set(['update' => 0, 'config' => 0], $the->{config});

        return 'update';
    } elsif ($tt) {

        # Get parameters
        my @params = qw(name header footer config description);
        my %theme= ();
        my $error = '';

        # Check parameters
        foreach (@params) {
            ($theme{$_}, $error) = $p->get($_);
            return unless defined $theme{$_};
            $self->info("$_ ok");
        }

        # Update theme
        my $user = $self->stash->get('user');
        my ($the, $eee) = $aot->update(\%theme, $user);
        $self->error("Error updating theme ($eee)") if $eee;
        return if $eee;

        # Return success
        $self->success("Theme updated");
        $self->log("theme " . $theme{name} . " updated")
            if $the;
        return 'success';
    } else {
        return 'get';
    }
}

sub delete {
    my $self = shift;
    my $p = $self->req_parameters;
    my ($t, $e) = $p->get('deletetheme');
    return if $e;
    my @params = qw(name repeatname);
    my %theme = ();
    my $error = '';

    foreach (@params) {
        ($theme{$_}, $error) = $p->get($_);
        return unless defined $theme{$_};
        $self->info("$_ ok");
    }
    my $eq = ($theme{name} eq $theme{repeatname});
    $self->error("Names do not match") unless $eq;
    return unless $eq;
    $self->info("Parameters OK");

    my $aot = Apache::Chameleon::Theme->new;
    my $user = $self->stash->get('user');
    my ($the, $ee) = $aot->delete($theme{name}, $user);
    $self->info("Deletion OK") if $the;
    $self->error("Error deleting theme($ee)") if $ee;
    return if $ee;
    $self->success("Theme deleted");
    $self->log("Theme " . $theme{name} . " deleted");
    return;
}

sub list {
    my $aot = Apache::Chameleon::Theme->new;
    return $aot->list;
}

1;

=head2 create

Creates a theme.

=head2 update

Updates a theme.

=head2 delete

Deletes a theme.

=head2 list

Lists all themes.

=head1 SEE ALSO

L<Apache::Chameleon>

L<Template>

L<Template::Plugin>
