package Apache::Chameleon::User::Preferences;

use strict;
use warnings;
use Apache::Chameleon::Database::User::Preferences;
use base qw(Apache::Chameleon::Base);

our $VERSION = '0.01';

sub new {
    my $self = bless {}, $_[0];
    $self->_user($_[1]);
    return $self;
}

sub _user {
    $_[0]->{_user} = $_[1] if $_[1];
    return $_[0]->{_user};
}

sub _get_by_id {
    my $self = shift;
    my $pref_id = shift;
    return unless $pref_id;

    my $pref = Apache::Chameleon::Database::User::Preferences->retrieve($pref_id);

    return $pref;
}

sub get {
    my $self = shift;
    return unless $self->_user;

    my @prefs = Apache::Chameleon::Database::User::Preferences->search(
                        user_id => $self->_user->user_id);

    return \@prefs;
}

sub get_by_type {
    my $self = shift;
    return unless $self->_user;
    my $type = shift;
    return unless $type;
    my $selector = shift;

    my $prefs = $self->get;
    my @by_type = grep { $_->{type} =~ /^$type$/ } @$prefs;
    if (defined $selector) {
        @by_type = grep { $_->{selector} =~ /^$selector$/ } @by_type;
    }
    return \@by_type;
}

sub list_selectors {
    my $self = shift;
    return unless $self->_user;

    my $prefs = $self->get;
    my %types;
    foreach my $type (@$prefs) {
        $types{$type->{selector}}++;
    }
    return \%types;
}

sub get_values_by_type {
    my $self = shift;
    return unless $self->_user;
    my $type = shift;
    return unless $type;
    my $selector = shift;

    my $by_type = $self->get_by_type($type, $selector);
    my @values;
    foreach(@$by_type) {
        $values[$#values+1] = $_->{value};
    }
    return \@values;
}

sub theme {
    my $self = shift;
    return unless $self->_user;

    my $prefs = $self->get;

    foreach my $pref (@$prefs) {
        next unless $pref->type eq "theme";
        return $pref->value;
    }
    return;
}

sub make_css {
    my $self = shift;
    my @css;
    my %sels;

    # Get all the preferences
    my $prefs = $self->get;

    # Start the stylesheet
    my $CSS = '<style type="text/css">';

    # Get all the CSS selectors
    foreach my $pref (@$prefs) {
        next unless $pref->type eq "CSS";
        $css[$#css+1] = $pref;
        $sels{$pref->selector}++;
    }

    # make a CSS property for each one
    foreach my $selector (sort keys %sels) {
        $CSS .= "\n" . $selector . " {\n";
        foreach my $cs (@css) {
            next unless $cs->selector eq $selector;
            $CSS .= "    " . $cs->property . ": " . $cs->value . ";\n";
	}
        $CSS .= "}\n";

    }
    
    # End the stylesheet
    $CSS .= '</style>';

    # Return the stylesheet
    return $CSS;
}

sub retrieve {
    my $self = shift;
    my $selector = shift;
    my $property = shift;

    # Get all preferences, then find the correct one
    my $u = $self->get;
    my $ret = undef;

    foreach (@$u) {
        $ret = $u->[$_]->{value} 
            if (($u->[$_]->{selector} eq $selector) and
               ($u->[$_]->{property} eq $property));
    }

    # Return preference
    return $ret;
}

sub create {
    my $self = shift;
    my $h = shift;

    # Check parameters
    return (undef, 1) unless $h;

    # Check it doesn't already exist
    my ($exists, $error) = $self->preference
        ($h->{selector}, $h->{property});
    return (undef, 1) if $exists;

    # Create the preference
    my $new_pref = Apache::Chameleon::Database::Preference->create($h);
    $new_pref->commit;

    # Return preference
    return $new_pref;
}

sub reset {
    my $self = shift;
    return if $self->_user->username eq 'guest';

    # Check for permission
    return unless $self->_user->permissions->reset_preference;

    # Get guest user's preferences
    my $new_pref = 
        Apache::Chameleon::User::Preferences->new(
            Apache::Chameleon::User->new({username => 'guest'}));
    my $prefs = $new_pref->get;

    # Delete the current preferences
    my $current = $self->get;
    foreach (@$current) {
        $_->delete;
    }

    # Copy the guest user's preferences
    foreach my $p (@$prefs) {
        my $temp = $p->copy({ user_id => $self->_user->user_id });
        $temp->commit;
    }

    # Return success
    return 1;
}

sub update {
    my $self = shift;
    my $pref_id = shift;
    my $value = shift;

    # Get the preference
    my $pref = $self->_get_by_id($pref_id);

    # Check for permission
    return unless $self->_user->permissions->update_preference($pref);

    # Update it
    $pref->value($value);
    $pref->commit;

    # Return success
    return 1;
}

1;

__END__

=head1 NAME

Apache::Chameleon::User::Preferences

=head1 ABSTRACT

User preferences manipulation class.

=head1 METHODS

=head2 new

Simple constructor

=head2 get

Retrieves preferences for a user.

=head2 get_by_type

Retrieves preferences for a user by type (and selector, optionally).

=head2 list_types

Lists all types

=head2 list_selectors

Lists all selectors

=head2 get_values_by_type

Retrieves values of preferences for a user by type (and selector, optionally).

=head2 theme

Retrieves theme for a user.

=head2 make_css

Makes CSS from a user's preferences.

=head2 retrieve

Retrieves a preference for a user.

=head2 create

Creates a new user preference.

=head2 reset

Resets all user preferences to those of guest user.

=head2 update

Updates a preference

=head2 _user

Get/set user

=head2 _get_by_id

Retrieves a preference by pref_id.

=head1 SEE ALSO

L<Apache::Chameleon>

=cut
