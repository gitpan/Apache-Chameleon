package Apache::Chameleon::Database::User;

use strict;
use warnings;
use Class::DBI::FromCGI;
use base qw(Apache::Chameleon::Database::Base);
our $VERSION = '0.01';

__PACKAGE__->table('Users');
__PACKAGE__->columns(
               All => qw( user_id 
                          username 
                          email
                          realname
                          password
                          status
                          created
                          last_access
                          last_ip_address
                        )
                    );
__PACKAGE__->untaint_columns(
    printable => [qw/username password status realname/],
    integer => [qw/user_id/],
    date => [qw/created last_access/],
    email => [qw/email/],
    );

1;

__END__

=head1 NAME

Apache::Chameleon::Database::User

=head1 ABSTRACT

User table manipulation

