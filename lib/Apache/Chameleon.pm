package Apache::Chameleon;

###############################################################################
# General setup
###############################################################################

use strict;
use warnings;

use base qw(Apache::Chameleon::Base);

use Apache::Constants qw(:common :response :http);
use Apache::Log;
use Apache::Chameleon::Document::Processor;
use Apache::Chameleon::Parameters;
use Apache::Chameleon::User::Authentication;

our $VERSION = 0.02;
our $DEBUG = 1;

###############################################################################
# Handler
###############################################################################

sub handler ($$) {
    my $class = shift;
    my $self = bless {}, $class;
    $self->_request(shift);

    $self->_init;

    my $auth = Apache::Chameleon::User::Authentication->new($self->_parameters);
    $self->_user($auth->run);

    $self->_document(Apache::Chameleon::Document::Processor->new(
            $self->_parameters, $self->_user));

    # Quit now if the document doesn't exist
    return NOT_FOUND unless $self->_document->exists;
    $self->send_response;
    return $self->_status;
}

###############################################################################
# Accessor methods
###############################################################################

sub _request {
    $_[0]->{_request} = $_[1] if $_[1];
    return $_[0]->{_request};
}

sub _status {
    $_[0]->{_status} = $_[1] if $_[1];
    return $_[0]->{_status};
}

sub _user {
    $_[0]->{_user} = $_[1] if $_[1];
    return $_[0]->{_user};
}

sub _parameters {
    $_[0]->{_parameters} = $_[1] if $_[1];
    return $_[0]->{_parameters};
}

sub _document {
    $_[0]->{_document} = $_[1] if $_[1];
    return $_[0]->{_document};
}

###############################################################################
# Initialisation
###############################################################################

sub _init {
    my $self = shift;
    $Apache::Chameleon::Base::USER_DEBUG = undef;
    $self->_status(DOCUMENT_FOLLOWS); # Everything is OK at this point
    $self->_setup_log('DEBUG');
    $self->_setup_database;
    $self->_setup_parameters;
}

sub _setup_log {
    my $level = $_[1];
    $level ||= 'ALERT';
    my $loglevel = 'Apache::Log::' . $level;
    $_[0]->_request->server->loglevel(eval($loglevel));
}

sub _setup_database {
    my $self = shift;
    Apache::Chameleon::Database::Base->setup_chameleon(
        $self->_request->dir_config('dbconn'),
        $self->_request->dir_config('dbuser'),
        $self->_request->dir_config('dbpass')
    );
}

sub _setup_parameters {
    my $self = shift;
    my %parameters = $self->_request->method eq 'POST' 
        ? $self->_request->content 
        : $self->_request->args;
    $parameters{last_ip_address} = $self->_request->get_remote_host;
    $parameters{hostname}        = $self->_request->hostname;
    $parameters{uri}             = $self->_request->uri;
    $self->_parameters(Apache::Chameleon::Parameters->new(\%parameters));
}

###############################################################################
# Stuff to do afterwards
###############################################################################

sub send_response {
    my $self = shift;
    # get the document before sending headers so that 
    # the SERVER_ERROR handler doesn't break when things go wrong.
    my $doc = $self->_document->get;
    $self->_send_headers;
    $self->_request->print($doc);
    $self->user_debug("Completed at: " . scalar gmtime);
    $DEBUG ?
        $self->_request->print($self->user_debug) :
        $self->_request->print("<!-- ".$self->user_debug."-->");
} 

sub _send_headers {
    my $self = shift;
    $self->_request->content_type("text/html");
    $self->_request->send_http_header;
    $self->_request->no_cache(1);
}

###############################################################################
# END
###############################################################################

1;

__END__
=head1 NAME

Apache::Chameleon

=head1 ABSTRACT

Apache handler for Apache::Chameleon. 

=head1 SYNOPSIS

Copy chameleon.conf and startup.pl to your Apache configuration 
directory ($APACHE_ROOT/conf/).

Put the following into your L<httpd.conf>

C<include chameleon.conf>

Edit chameleon.conf to suit your needs, specifically the database connection
variables.

=head1 DESCRIPTION

Apache::Chameleon is an application framework for customisable multi-user
websites.

=head1 METHODS

=head2 handler

Apache handler.

=head2 _request

Get/set request object

=head2 _status

Get/set the HTTP return status.

=head2 _user

Get/set the current user

=head2 _document

Get/set document processor object

=head2 _init

Initialisation sequence.

=head2 _parameters

Get/set parameter object

=head2 _setup_log

Sets up Apache logging.

Loglevels: EMERG ALERT CRIT ERR WARNING NOTICE INFO DEBUG

=head2 _setup_database

Global database setup. Instantiates L<Apache::Chameleon::Database::Base> object.

Uses Apache config file parameters 'dbconn', 'dbuser' and 'dbpass'.

=head2 _setup_parameters

Sets up parameters for untainting.

=head2 send_response

Sends response and debugging info.

=head2 _send_headers

Sends HTTP content type and headers.

=head1 TODO

Below is a list of things that need done.

=over 4

=item *
Automated tests!

=item *
Code refactoring.

=item *
Movable side panels.

=item *
Make it more usable.

=item *
Add some themes.

=item *
Colour schemes.

=item *
Documentation.

=item *
Proper installation client.

=back

=head1 AVAILABILITY

Available for download from CPAN F<http://www.cpan.org/> or from
F<http://russell.matbouli.org/code/chameleon/>

=head1 AUTHOR

Russell Matbouli E<lt>chameleon-spam@russell.matbouli.orgE<gt>

F<http://russell.matbouli.org>

=head1 LICENSE

Distributed under GPL v2. See COPYING included with this distibution.

=head1 SEE ALSO

L<Apache>

L<mod_perl>

L<Template>

L<Class::DBI>

L<MySQL>

=cut
