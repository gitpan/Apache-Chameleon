package Apache::Chameleon::Database::Base;

use strict;
use warnings;
use Class::DBI::FromCGI;
#use Class::DBI::mysql::FullTextSearch;
use base qw(Class::DBI);

our $VERSION = '0.01';
my $setup; 

sub setup_chameleon {
    my $class = shift;
    return if $setup;
    __PACKAGE__->set_db('Main', shift, shift, shift);
    $setup = 1;
}

1;

__END__

=head1 NAME

Apache::Chameleon::Database::Base

=head1 ABSTRACT

Base class for Apache::Chameleon::Database objects

=head1 METHODS

=head2 setup_chameleon

Database connection

=head1 SEE ALSO

L<Apache::Chameleon>

=cut
