#!/usr/local/bin/perl -T
use warnings;
use strict;

BEGIN {
    use Apache ();
    use lib qw(
        /usr/local/lib/perl5/site_perl/5.6.1
    );
}

use Apache::Constants;
use Apache::Log;
use Class::DBI::FromCGI;
use CGI::Untaint;
use Digest::MD5;
use Template;

1;
