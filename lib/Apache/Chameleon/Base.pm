package Apache::Chameleon::Base;

use strict;
use warnings;
use Digest::MD5;
use Apache::Chameleon::Untaint::Path;

our $USER_DEBUG;

sub new {
    return bless {}, $_[0];
}

sub log {
    print STDERR '[' . gmtime() . '] ' . $_[1]. "\n";
}

sub user_debug {
    $USER_DEBUG = '' unless $USER_DEBUG;
    my $debug = $_[1];
    $debug =~ s/^(.*)$/$1\n/g if $debug;
    $debug =~ s/\n/\n<br>/g if $debug;
    $USER_DEBUG .= $debug if $debug;
    return $USER_DEBUG;
}

sub _create_md5 {
    return unless $_[1];

    # do it twice to avoid theoretical vulnerability in MD5
    my $md5 = Digest::MD5->new;
    $md5->add($_[1]);
    my $digest = $md5->hexdigest;
    $md5->add($digest);
    return $md5->hexdigest;
}

sub _sql_date {
    my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday) = gmtime();
    $year += 1900;
    return "$year-$mon-$mday $hour:$min:$sec"; 
}

1;

__END__
=head1 NAME

Apache::Chameleon::Base

=head1 ABSTRACT

Base class for Apache::Chameleon classes

=head2 new

Simple constructor

=head2 log

Prints to STDERR

=head2 _create_md5

Returns double MD5 of a string.

=head2 _sql_date

Current date time in ISO format

=head2 user_debug 

Debugging to the browser

=head1 SEE ALSO

L<Apache::Chameleon>

=cut
