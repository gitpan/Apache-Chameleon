package Apache::Chameleon::Parameters;

use strict;
use warnings;
use CGI::Untaint;
use base qw(Apache::Chameleon::Base);

sub new {
    my $class = shift;
    my $self = bless {}, $class;
    my $param = shift;

    $self->parameters($param);
    $self->untaint($self->parameters);

    return $self;
}

sub parameters {
    my $self = shift;
    my $set  = shift;

    $self->{_parameters} = $set if $set 
        and not defined $self->{_parameters};
    return $self->{_parameters};
}

sub get_parameter {
    return $_[0]->parameters->{$_[1]};
}

sub untaint {
    $_[0]->{_untaint} = CGI::Untaint->new($_[1]) 
        if $_[1] and not defined $_[0]->{_untaint};
    return $_[0]->{_untaint};
}

sub get {
    my $self = shift;
    my $param = shift;
    my $as = shift;
    $as ||= '-as_printable';

    return unless defined $param;

    return $self->untaint->extract($as => $param)
        if $self->get_parameter($param);
    return (undef, "Parameter $param does not exist");
}

sub param {
    my ($x, $y) = &get(shift, shift);
    return $x if $x;
    return shift;
}

1;

__END__

=head2 new

Simple constructor

=head2 parameters

Sets parameters.

=head2 get_parameter

Gets parameters.

=head2 untaint

Get/set the CGI::Untaint object

=head2 get

Gets an untainted parameter.

=head2 param

Gets an untainted parameter but fails silently or returns whatever 
default value you provide (for TT).
