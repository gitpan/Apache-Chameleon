package Apache::Chameleon::Theme;

use strict;
use warnings;
use Apache::Chameleon::Database::Theme;
use base qw(Apache::Chameleon::Base);

our $VERSION = '0.01';
our %Errors        = (
        exists     => 'Theme already exists',
        bad_path   => 'Invalid path',
        create_dir => 'Cannot create a directory',
        not_found  => 'Theme does not exist',
        not_owner  => 'You do not own this theme',
        no_param   => 'Parameter not supplied',
);

sub get {
    my $self = shift;
    my $theme = shift;

    # Check parameters
    return (undef, $Errors{no_param}) unless $theme;

    # Retrieve it
    my @themes = Apache::Chameleon::Database::Theme->search(name => $theme);

    # Return it
    return $themes[0];
}

sub get_all {
    my @themes = Apache::Chameleon::Database::Theme->retrieve_all;
    return \@themes;
}

sub list {
    my $self = shift;
    my $themes = $self->get_all;
    my @names;

    foreach (@$themes) {
        $names[$#names+1] = $_->name;
    }

    return \@names;
}

sub create {
    my $self = shift;
    my $theme = shift;
    my $user  = shift;

    # Check parameters
    return (undef, $Errors{no_param}) unless $theme;
    return (undef, $Errors{no_param}) unless $user;

    # Get the theme
    my ($exists, $error) = $self->get($theme->{name});
    return (undef, $Errors{exists}) if $exists;

    # Check permissions
    return (undef, $Errors{no_permission}) 
        unless $user->permissions->create_theme($theme);

    # Create it
    my $new_theme = Apache::Chameleon::Database::Theme->create($theme);
    $new_theme->commit;

    # Return theme
    return $new_theme;
}

sub update {
    my $self  = shift;
    my $theme = shift;
    my $user  = shift;

    # Check parameters
    return (undef, $Errors{no_param}) unless $theme;
    return (undef, $Errors{no_param}) unless $user;

    # Get the theme
    my ($exists, $error) = $self->get($theme->{name});
    return (undef, $Errors{not_found}) unless $exists;

    # Check permissions
    return (undef, $Errors{no_permission}) 
        unless $user->permissions->update_theme($theme);

    # Update it
    foreach (keys %$theme) {
        $exists->$_($theme->{$_});
    }
    $exists->commit;

    # Return theme
    return $exists;
}

sub delete {
    my $self   = shift;
    my $theme  = shift;
    my $user   = shift;

    # Check parameters
    return (undef, $Errors{no_param}) unless $theme;
    return (undef, $Errors{no_param}) unless $user;

    # Get the theme
    my ($the, $error) = $self->get($theme);

    # Check permissions
    return (undef, $Errors{no_permission}) 
        unless $user->permissions->delete_theme($theme);
    
    # Delete it
    $self->log("Deleting " . $theme);
    $the->delete;

    # Return success
    return 1;
}

1;

__END__

=head1 NAME

Apache::Chameleon::Theme

=head1 ABSTRACT

Theme manipulation class.

=head1 METHODS

=head2 get

Retrieves theme.

=head2 get_all

Retrieves all themes.

=head2 list

Retrieves names of all themes.

=head2 create

Creates a new theme.

=head2 update

Update a theme.

=head2 delete

Deletes a theme.

=head1 SEE ALSO

L<Apache::Chameleon>

=cut
