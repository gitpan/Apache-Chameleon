package Apache::Chameleon::Template::Plugin::User;

use strict;
use warnings;

use base qw( Apache::Chameleon::Template::Plugin::Base );
use Apache::Chameleon::User;
use Apache::Chameleon::Mail;
use Apache::Chameleon::Document;
use Apache::Chameleon::Document::Processor;

sub password {
    my $self = shift;

    # Get parameters
    my $p = $self->req_parameters;
    my ($d, $e) = $p->get('user_password');
    return if $e;
    my @params = qw(username email);
    my $user = {};
    my $error = '';

    # Check parameters
    foreach (@params) {
        ($user->{$_}, $error) = $p->get($_);
        $self->error("$_ not ok") if $error;
        return if $error;
        return unless defined $user->{$_};
        $self->info("$_ ok");
    }

    # Check the user exists and the email addresses match
    my $aou = Apache::Chameleon::User->new({username => $user->{username}});
    $self->error("no such user " . $user->{username})
        unless $aou->exists;
    $self->info("okay user " . $user->{username}) if $aou->exists;
    return unless $aou->exists;
    $self->info("Email addresses match") 
        if ($user->{email} eq $aou->email);
    $self->info("Email addresses do not match") 
        unless ($user->{email} eq $aou->email);
    $self->error("Email addresses do not match") 
        unless ($user->{email} eq $aou->email);
    return unless ($user->{email} eq $aou->email);

    # Send the mail
    $self->info("Sending mail...");
    my %parameters;
    $parameters{uri} = '/email/lostpassword.email';
    $parameters{theme} = 'email';
    my $aod = Apache::Chameleon::Document::Processor->new(
        Apache::Chameleon::Parameters->new(\%parameters), $aou);
    my $body = $aod->render ('/email/lostpassword.email', $aou->user, 'email');
    my $mail = Apache::Chameleon::Mail->new;
    my $to = $aou->realname.' <'.$aou->email.'>';
    my $from =  'Apache Chameleon password mailer <noreply@localhost>';
    my $title = "Password Reminder";

    # Send it
    my $success = $mail->send({to => $to, from => $from, subject => $title, body => $body});

    # Check success
    $self->error("Error sending mail") unless $success;
    return unless $success;
    $self->success("Email has been sent");
    $self->log("password sent to " . $aou->username . 
                         " at ". $aou->email);
    return;
}

sub create {
    my $self = shift;

    # Get parameters
    my $p = $self->req_parameters;
    my ($d, $e) = $p->get('create_user');
    return if $e;
    my @params = qw(username password repeat_password email realname);
    my $user = {};
    my $error = '';

    # Check parameters
    foreach (@params) {
        ($user->{$_}, $error) = $p->get($_);
        $self->error("$_ not ok") if $error;
        return if $error;
        return unless defined $user->{$_};
        $self->info("$_ ok");
    }
    return unless ($user->{password} eq $user->{repeat_password});
    $self->info("passwords match");

    # Check the user doesn't exist
    my $aou = Apache::Chameleon::User->new({username => $user->{username}});
    $self->info("got here");
    $self->error("user exists") if $aou->exists;
    return if $aou->exists;

    $self->info("user doesn't exist");

    # Setup for creation
    delete $user->{repeat_password};
    $user->{last_access} = $self->_sql_date;
    $user->{created} = $user->{last_access};
    ($user->{last_ip_address}, my $err) = $self->stash->get('last_ip_address');

    # Create the user
    my $useracc = $aou->create($user);
    return unless $useracc;

    $self->info("user created");

    # Setup the mail
    $self->info("Sending mail...");
    my %parameters;
    $parameters{uri} = '/email/newuser.email';
    $parameters{theme} = 'email';
    ($user->{hostname}, $err) = $self->stash->get('hostname');
    $user->{url}        = '/tasks/user/activation.html';
    $user->{activation} = $self->_create_md5($user->{password});
    my $aod = Apache::Chameleon::Document::Processor->new(
        Apache::Chameleon::Parameters->new(\%parameters), $useracc);
    my $body = $aod->render('/email/newuser.email', $user, 'email');
    my $mail = Apache::Chameleon::Mail->new;
    my $to = $user->{realname}.' <'.$user->{email}.'>';
    my $from =  'Apache Chameleon password mailer <noreply@localhost>';
    my $title = "Account creation";

    # Send it
    my $success = $mail->send({to => $to, from => $from, subject => $title, body => $body});

    # Check the success
    $self->error("Error sending mail") unless $success;
    return unless $success;
    $self->success('Account created, email sent.<br>
Please activate your account <a href="/tasks/user/activation.html">here</a>');

    $self->log("New user email sent to ". $user->{realname} .", (".
                          $user->{username} .") at ". $user->{email});
    return;
}

sub activate {
    my $self = shift;

    # Get parameters
    my $p = $self->req_parameters;
    my ($d, $e) = $p->get('activation');
    return if $e;

    # Check parameters
    my @params = qw(username activation);
    my $user = {};
    my $error = '';

    foreach (@params) {
        ($user->{$_}, $error) = $p->get($_);
        $self->error("$_ not ok") if $error;
        return if $error;
        return unless defined $user->{$_};
        $self->info("$_ ok");
    }

    # Get user
    my $u = Apache::Chameleon::User->new({username => $user->{username}});
    my $exists = $u->exists;
    $self->error($user->{username}. " does not exist, so cannot activate")
        unless $exists;
    return unless $exists;

    $self->info("user exists ok");

    # Check activation code
    my $a = $self->_create_md5($u->password);
    return unless ($user->{activation} eq $a);
    $self->info("activating");

    # Activate user
    unless ($u->activate) {
        $self->error('Error activating account!');
        return;
    }

    # Return success
    $self->success('Account activated. 
    You may now <a href="/tasks/user/login.html">log in</a>');

    $self->log("account activation for " . $user->{username});
    return;
}

sub customise {
    my $self = shift;

    # Get parameters
    my $p = $self->req_parameters;
    my ($c, $e) = $p->get('customiseuser');
    return if $e;
    my $d = $p->parameters;
    my $user = $self->stash->get('user');

    # Try to update each one in turn
    foreach my $x (sort keys %$d) {
        next unless $x =~ m/^pref_(.*)$/;
        my $s = $user->preferences->update($1, $p->get($x));
        $self->error("Error with $x ". $p->get($x)) unless $s;
    }

    # Return success
    $self->success("Updates successfully completed.<br>
    Changes will take effect on next page load.");
    return;
}

sub reset {
    my $self = shift;

    # Get parameters
    my $p = $self->req_parameters;
    my ($d, $e) = $p->get('reset_preferences');
    return if $e;

    # Reset the preferences
    my $r = $self->stash->get('user')->preferences->reset;

    # Return success
    $self->success("Preferences reset") if $r;
    $self->error("Error resetting preferences") unless $r;
    return;
}

sub logged_in {
    my $self = shift;
    my $aou = Apache::Chameleon::User->new({ user_id => 1 });
    my @users = $aou->logged_in('600');
    return @users;
}

sub list {
    my $self = shift;
    return $self->stash->get('user')->list;
}

sub update {
    my $self = shift;

    #Check the parameters
    my $p = $self->req_parameters;
    my ($u, $e) = $p->get('updateuser');
    my $user = $self->stash->get('user');
    return unless $u;
    my @params = qw(realname email currentpassword newpassword newpasswordrepeat);
    my %usr   = ();
    my $error  = '';
    foreach (@params) {
        ($usr{$_}, $error) = $p->get($_);
        $self->info("$_ ok");
    }

    # They can't change the username
    $usr{username} = $user->username;

    # If they want a new password
    if($usr{currentpassword} eq $user->password) {
       if($usr{newpassword} eq $usr{newpasswordrepeat}) {
           $usr{password} = $usr{newpassword};
       }
    }
    delete $usr{currentpassword};
    delete $usr{newpassword};
    delete $usr{newpasswordrepeat};

    # Update the user
    my ($us, $ee) = $user->update(\%usr);
    $self->error("Error updating user ($ee)") if $ee;

    # Check success
    return if $ee;
    $self->success("User updated");
    return;
}

sub details {
    my $self = shift;

    # Get parameters
    my $p = $self->req_parameters;
    my $user = $self->stash->get('user');
    my ($userdetails, $e) = $p->get('userdetails');
    return unless $userdetails;

    # Get the user
    my $aou = Apache::Chameleon::User->new({username => $userdetails});
    $self->error("User $userdetails does not exist") unless $aou->exists;
    return unless $aou->exists;
    $aou->{password} = undef; # let's not be naughty...
    $self->stash->set('viewuserdetails', $aou);

    # Return success
    $self->success("Here are the details:");
    return;
}

1;

__END__

=head2 password

Lost password function.

=head2 create

Creates a new user account.

=head2 activate

Activates a new user account.

=head2 customise

Customise preferences.

=head2 reset

Resets user customisations.

=head2 logged_in

Lists users currently logged in

=head2 list

Lists all users.

=head2 update

Updates a user.

=head2 details

Views a user's details.

=head1 SEE ALSO

L<Apache::Chameleon>

L<Template>

L<Template::Plugin>
