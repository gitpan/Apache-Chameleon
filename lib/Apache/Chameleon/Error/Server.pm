package Apache::Chameleon::Error::Server;

use strict;
use warnings;

our $VERSION = 0.01;
our $DEBUG = 1;

use Apache::Constants qw(:common);

sub handler ($$) {
    my $class = shift;
    my $self = bless {}, $class;
    my $r = shift;

    $r->content_type("text/html");
    $r->send_http_header;
    $r->no_cache(1);

    $r->print(<<EOF);
<html>
<head>
   <title>Apache::Chameleon Server Error</title>
</head>
<body>
<h1>Chameleon Server Error</h1>
Chameleon has encountered a fatal error.<br>
If you are the server administrator, check the Apache error log 
and fix any problems stated there.<br> 
Otherwise, please contact the server administrator informing them
of the error.<br>
<br>
Thanks,<br>
<i>Chameleon</i> on behalf of the server administrator
</body>
</html>
EOF
    return OK;
}

1;

=head1 NAME

Apache::Chameleon::Error::Server

=head1 ABSTRACT

Server Error handler for Apache::Chameleon. 

=head1 DESCRIPTION

Gets called when Things Go Badly Wrong.

=head1 SEE ALSO

L<Apache::Chameleon>

=cut
