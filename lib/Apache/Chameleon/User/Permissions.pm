package Apache::Chameleon::User::Permissions;

use strict;
use warnings;
use base qw(Apache::Chameleon::Base);

sub new {
    my $class = shift;
    my $self = bless {}, $class;
    $self->_user(shift);
    return $self;
}

sub _user {
    $_[0]->{_user} = $_[1] if $_[1];
    return $_[0]->{_user};
}

sub login {
    my $self = shift;
    if($self->_user->status eq "active")      {return 1};
    if($self->_user->status eq "unactivated") {return};
    if($self->_user->status eq "locked")      {return};
    return;
}

sub read_document {
    my $self = shift;
    my $doc  = shift;
    if($doc->{worldread} == 1)                    {return 1};
    if($doc->{author_id} == $self->_user->user_id) {return 1};
    return;
}

sub update_document {
    my $self = shift;
    my $doc  = shift;
    #if($doc->{worldwrite} == 1)                   {return 1};
    #if($doc->{author_id} == $self->_user->user_id) {return 1};
    return 1;
}

sub lock_document {
    my $self = shift;
    my $doc  = shift;
    unless($doc->{locker_id}) {return 1};
    return;
}

sub unlock_document {
    my $self = shift;
    my $doc = shift;
    if($doc->{locker_id} == $self->_user->user_id ){return 1};
    return;
}

sub create_document {
    my $self = shift;
    my $doc = shift;
    if($self->_user->username eq "root") {return 1};
    return;
}

sub delete_document {
    my $self = shift;
    my $doc = shift;
    if($doc->{author_id} == $self->_user->user_id) {return 1};
    return;
}

sub read_theme {
    my $self = shift;
    my $theme = shift;
    if($theme->{owner_id} == $self->_user->user_id) {return 1};
    return 1;
}

sub create_theme {
    my $self = shift;
    my $theme = shift;
    if($self->_user->username eq "root") {return 1};
    if($theme->{owner_id} == $self->_user->user_id) {return 1};
    return;
}
sub update_theme {
    my $self = shift;
    my $theme = shift;
    if($self->_user->username eq "root") {return 1};
    if($theme->{owner_id} == $self->_user->user_id) {return 1};
    return;
}

sub delete_theme {
    my $self = shift;
    my $theme = shift;
    if($self->_user->username eq "root") {return 1};
    if($theme->{owner_id} == $self->_user->user_id) {return 1};
    return;
}

sub read_preference {
    my $self = shift;
    my $pref = shift;
    if($pref->{user_id} == $self->_user->user_id) {return 1};
    my $guest_user = Apache::Chameleon::User->new({username => 'guest'});
    if($pref->{user_id} == $guest_user->user_id) {return 1};
    return;
}

sub update_preference {
    my $self = shift;
    my $pref = shift;
    if($pref->{user_id} == $self->_user->user_id) {return 1};
    return;
}

sub delete_preference {
    my $self = shift;
    my $pref = shift;
    if($pref->{user_id} == $self->_user->user_id) {return 1};
    return;
}

sub reset_preference {
    my $self = shift;
#    my $guest_user = Apache::Chameleon::User->new({username => 'guest'});
#    unless ($self->_user->{user_id} == $guest_user->user_id) {return 1;}
    return 1;
}

1;
