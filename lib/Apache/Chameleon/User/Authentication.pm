package Apache::Chameleon::User::Authentication;

use base qw(Apache::Chameleon::Base);
use Apache::Cookie;
use Apache::Chameleon::User;

sub new {
    my $self = bless {}, $_[0];
    $self->parameters($_[1]);
    return $self;
}

sub parameters {
    $_[0]->{_parameters} = $_[1] if $_[1];
    return $_[0]->{_parameters};
}

sub user {
    my $self = shift;
    my $set = shift;
    my $unset = shift;

    $self->{_username} = $set if $set;
    $self->{_username} = undef if $unset;

    return $self->{_username};
}

sub authorised {
    my $self = shift;
    my $set = shift;
    my $unset = shift;

    $self->{_authorised} = $set if $set;
    $self->{_authorised} = undef if $unset;

    return $self->{_authorised};
}

sub run {
    my $self = shift;

    $self->{DEBUG} = 1;

    # Check for cookie, login or logout.
    $self->try_cookie_login;
    $self->try_login;
    $self->try_logout;

    # Set last access and last ip address for the user
    $self->auth_user->last_access($self->_sql_date);
    $self->auth_user->last_ip_address(
        $self->parameters->get('last_ip_address'));

    # Return the user
    return $self->auth_user;
}

sub auth_user {
    my $self = shift;
    return $self->{_auth_user} if $self->{_auth_user};

    # If they're authorised, they have their own user
    if ($self->authorised){
        $self->{_auth_user} = 
            Apache::Chameleon::User->new({username => $self->user});
    # If they're not authorised, they have the guest user
    } else {
        $self->{_auth_user} = 
            Apache::Chameleon::User->new({username => 'guest'});
    }

    # Return the user
    return $self->{_auth_user};
}

sub try_cookie_login {
    my $self = shift;

    # Get cookie and parse it
    my $cookies = Apache::Cookie->fetch;
    return unless $cookies->{login};
    my ($username, $salt) = $cookies->{login}->value;
    return unless $username and $salt;

    # Get user object
    my $user = Apache::Chameleon::User->new({username => $username});
    unless ($user->exists) {
        $self->user_debug("Bad cookie: no such user $username. Log in again.");
        $self->_create_cookie; # invalidate the cookie
        return;
    }

    # Check the login cookie is the same as create_md5 on the password
    if ($salt ne $self->_create_md5($user->password)) { 
        $self->user_debug("Bad cookie: salts don't match. Log in again."); 
        $self->_create_cookie; # invalidate the cookie
        return;
    }

    # See if they have permission to log in
    unless ($user->permissions->login) {
        $self->user_debug("Account is " . $user->status);
        $self->_create_cookie; # invalidate the cookie
        return;
    }

    # Set up variables and return success
    $self->authorised("true");
    $self->user($username);
    return 1;
}

sub try_login {
    my $self = shift;

    # Check parameters
    my ($l, $e) = $self->parameters->get('login');
    return unless $l;
    my ($username, $password);
    ($username, $e) = $self->parameters->get('username');
    $self->user_debug("Login error ($e)") if $e;
    ($password, $e) = $self->parameters->get('password');
    $self->user_debug("Login error ($e)") if $e;
    return unless($username and $password);

    # Get the user
    my $user = Apache::Chameleon::User->new({username => $username});
    unless($user->exists) {
        $self->user_debug("Login error: no such user $username");
        return;
    }

    # See if they have permission to log in
    unless ($user->permissions->login) {
        $self->user_debug("Account is " . $user->status);
        $self->_create_cookie; # invalidate the cookie
        return;
    }

    # See if the passwords match
    unless($password eq $user->password) {
        $self->user_debug("passwords don't match");
        return;
    }

    # Create a login cookie, set tokens and return success
    $self->_create_cookie($username, $password);
    $self->authorised("true");
    $self->user($username);
    $self->user_debug("Good login from $username");
    return 1;
}

sub try_logout {
    my $self = shift;
    
    # Check parameters
    my ($l, $e) = $self->parameters->get('logout');
    return unless $l;

    # Invalidate the cookie, unset the token, return success
    $self->_create_cookie; # invalidate the cookie
    $self->authorised('', 'true');
    $self->user('', 'true');
    $self->user_debug("logged out");
    return 1;
}

sub _create_cookie {
    my $self = shift;
    my $username = shift;
    my $passwd = shift;

    # We want to use this to unset cookies too...
    my @value;
    if (!$username or !$passwd) {
        $username = 'guest';
        $passwd   = '';
    }
    $value[0] = $username if $username;
    $value[1] = $self->_create_md5($passwd) if $passwd;

    # Set the cookie
    my $logincookie =  Apache::Cookie->new($self->{request},
                           -name    => 'login',
                           -value   => \@value,
                           -expires => '+3M',
                           -path    => '/',
                           );
    $logincookie->bake;
    
    # Return success
    return 1;
}

1;

__END__

=head1 NAME

Apache::Chameleon::User::Authentication

=head1 ABSTRACT

Authentication via cookies and login form.

=head1 METHODS

=head2 new

Simple constructor.

=head2 parameters

Gets the parameters.

=head2 user

Returns authenticated username.

=head2 authorised

Authorised user or guest user.

=head2 run

Do authentication.

=head2 auth_user

Return a user object, either of the authenticated user, or of the guest user.

=head2 try_cookie_login

Checks for a login cookie, and validates user details from that.

=head2 try_login

Checks username and password, sets cookie.

=head2 try_logout

Logs out a user.

=head2 _create_cookie

Creates a login cookie.

=head1 SEE ALSO

L<Apache::Chameleon>

=cut
