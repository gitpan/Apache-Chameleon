package Apache::Chameleon::Template::Plugin::Base;

use strict;
use warnings;

use base qw( Apache::Chameleon::Base Template::Plugin );
use Apache::Chameleon::Parameters;
use Template::Plugin;

sub new {
    my $self = bless {}, $_[0];
    $self->{_CONTEXT} = $_[1];
    $self->parameters(Apache::Chameleon::Parameters->new($_[2]));
    $self->stash;
    return $self;
}

sub parameters {
    $_[0]->{_parameters} = $_[1] if $_[1];
    return $_[0]->{_parameters};
}

sub req_parameters {
    my $self = shift;
    my ($p, $e) = $self->stash->get('parameters');
    return if $e;
    $self->{_req_parameters} = $$p;
    return $self->{_req_parameters};
}

sub load {
    return $_[0];
}

sub stash {
    my $self = shift;
    return $self->{_CONTEXT}->stash;
}

sub error {
    $_[0]->{_error} = '' unless $_[0]->{_error};
    $_[0]->{_error} .= $_[1]. "<br>\n" if $_[1];
    return $_[0]->{_error};
}

sub warning {
    $_[0]->{_warning} = '' unless $_[0]->{_warning};
    $_[0]->{_warning} .= $_[1]. "<br>\n" if $_[1];
    return $_[0]->{_warning};
}

sub info {
    $_[0]->{_info} = '' unless $_[0]->{_info};
    $_[0]->{_info} .= $_[1]. "<br>\n" if $_[1];
    return $_[0]->{_info};
}

sub success {
    $_[0]->{_success} = '' unless $_[0]->{_success};
    $_[0]->{_success} .= $_[1]. "<br>\n" if $_[1];
    return $_[0]->{_success};
}

1;

__END__

=head2 new

Simple constructor.

=head2 parameters

Gets the parameters.

=head2 req_parameters

Gets the request parameters.

=head2 load

Returns the class (required by TT).

=head2 stash

Gets the stash

=head2 error

Get/set error messages.

=head2 warning

Get/set warning messages.

=head2 info

Get/set informational messages.

=head2 success

Get/set success messages.

=head1 SEE ALSO

L<Apache::Chameleon>

L<Template>

L<Template::Plugin>

