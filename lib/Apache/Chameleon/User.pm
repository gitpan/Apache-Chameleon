package Apache::Chameleon::User;

use strict;
use warnings;
use Apache::Chameleon::Database::User;
use Apache::Chameleon::User::Preferences;
use Apache::Chameleon::User::Permissions;
use base qw(Apache::Chameleon::Base);

our $VERSION = '0.01';
our %Errors        = (
        not_found  => 'User does not exist',
        no_param   => 'Parameter not supplied',
);

sub new {
    my $class = shift;
    my $self = bless {}, $class;
    my $h = shift;

    if ($h->{username}){
        $self->get($h->{username});
    } elsif ($h->{user_id}) {
        $self->get_by_id($h->{user_id});
    } else {
        return undef;
    }
    $self->permissions(Apache::Chameleon::User::Permissions->new($self));

    return $self;
}

sub user {
    $_[0]->{_user} = $_[1] if $_[1];
    return $_[0]->{_user};
}

sub permissions {
    $_[0]->{_permissions} = $_[1] if $_[1];
    return $_[0]->{_permissions};
}

sub get_by_id {
    my $self = shift;
    my $user_id = shift;
    return unless $user_id;

    my @users = Apache::Chameleon::Database::User->search(
                        user_id => $user_id);

    return if @users > 1;
    $self->user($users[0]);
    return $self->user;
}

sub get {
    my $self = shift;
    my $username = shift;
    return unless $username;

    my @users = Apache::Chameleon::Database::User->search(
                        username => $username);

    return if @users > 1;
    $self->user($users[0]);
    return $self->user;
}

sub get_all {
    my @users = Apache::Chameleon::Database::User->retrieve_all;
    return \@users;
}

sub list {
    my $self = shift;
    my $users = $self->get_all;
    my @names;

    foreach (@$users) {
        $names[$#names+1] = $_->username;
    }

    return \@names;
}

sub create {
    my $self = shift;
    my $user = shift;
    $user->{created} = $self->_sql_date unless $user->{created};
    $user->{status} = 'unactivated';

    $self->get($user->{username});
    my $exists = $self->user;
    return (undef, 1) if $exists;

    my $new_user = Apache::Chameleon::Database::User->create($user);
    $new_user->commit;
    #my $p = $new_user->preferences($new_user->{user_id});
    my $u = Apache::Chameleon::User->new({user_id => $new_user->{user_id}});
    $u->preferences->reset;
    return $new_user;
}

sub update {
    my $self        = shift;
    my $user        = shift;

    # Check parameters
    return (undef, $Errors{no_param})   unless $user;
    my ($exists, $error) = $self->get($user->{username});
    return (undef, $Errors{not_found})  unless $exists;

    delete $user->{user_id}; # changing the primary key is baad, mkay?

    # Update user
    foreach (keys %$user) {
        next unless defined $user->{$_};
        $exists->$_($user->{$_});
    }
    $exists->commit;
    return $exists;
}

sub exists {
    return $_[0]->{_user};
}

sub activate {
    return unless $_[0]->exists;
    return unless $_[0]->user->{status} eq 'unactivated';

    $_[0]->user->status('active');
    $_[0]->user->commit;
    return $_[0]->user;
}

sub user_id {
    return unless $_[0]->exists;
    return $_[0]->user->user_id;
}

sub username {
    return unless $_[0]->exists;
    return $_[0]->user->username if $#_ == 0;
    $_[0]->user->username($_[1]);
    $_[0]->user->commit;
    return $_[0]->user;
}

sub email {
    return unless $_[0]->exists;
    return $_[0]->user->email if $#_ == 0;
    $_[0]->user->email($_[1]);
    $_[0]->user->commit;
    return $_[0]->user;
}

sub realname {
    return unless $_[0]->exists;
    return $_[0]->user->realname if $#_ == 0;
    $_[0]->user->realname($_[1]);
    $_[0]->user->commit;
    return $_[0]->user;
}

sub password {
    return unless $_[0]->exists;
    return $_[0]->user->password if $#_ == 0;
    $_[0]->user->password($_[1]);
    $_[0]->user->commit;
    return $_[0]->user;
}

sub status {
    return unless $_[0]->exists;
    return $_[0]->user->status if $#_ == 0;
    $_[0]->user->status($_[1]);
    $_[0]->user->commit;
    return $_[0]->user;
}

sub created {
    return unless $_[0]->exists;
    return $_[0]->user->created;
}

sub last_access {
    return unless $_[0]->exists;
    return $_[0]->user->last_access if $#_ == 0;
    $_[0]->user->last_access($_[1]);
    $_[0]->user->commit;
    return $_[0]->user;
}

sub logged_in {
    my $self = shift;
    my $time = shift;
    return $self->list;
}

sub last_ip_address {
    return unless $_[0]->exists;
    return $_[0]->user->last_ip_address if $#_ == 0;
    $_[0]->user->last_ip_address($_[1]);
    $_[0]->user->commit;
    return $_[0]->user;
}

sub preferences {
    return unless $_[0]->exists;
    return Apache::Chameleon::User::Preferences->new($_[0]);
}

1;

__END__

=head1 NAME

Apache::Chameleon::User

=head1 ABSTRACT

User manipulation class.

=head1 METHODS

=head2 new

Simple constructor

=head2 user

Get/set user

=head2 get_by_id

Retrieves a user by user_id.

=head2 get

Retrieves a user.

=head2 get_all

Retrieves all users.

=head2 list

Retrieves usernames of all users.

=head2 create

Creates a new user.

=head2 update

Updates a user.

=head2 exists

Checks for the existance of a user;

=head2 activate

Activates a new user account.

=head2 user_id 

Returns user_id.

=head2 username

Returns / sets username.

=head2 email

Returns email address.

=head2 realname

Returns user's real name.

=head2 password

Returns password.

=head2 status

Returns status.

=head2 created

Returns creation datetime.

=head2 last_access

Returns user's last access datetime.

=head2 logged_in

Gets list of users logged in.

(TBC. Currently just displays all users.)

=head2 last_ip_address

Returns user's last access IP address.

=head2 preferences

Return Apache::Chameleon::User::Preferences object for the user.

=head2 permissions

Return Apache::Chameleon::User::Permissions object for the user.

=head1 SEE ALSO

L<Apache::Chameleon>

=cut
