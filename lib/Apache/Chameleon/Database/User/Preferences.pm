package Apache::Chameleon::Database::User::Preferences;

use strict;
use warnings;
use Class::DBI::FromCGI;
use base qw(Apache::Chameleon::Database::Base);
our $VERSION = '0.01';

__PACKAGE__->table('Preferences');
__PACKAGE__->columns(
               All => qw( pref_id 
                          user_id 
                          description
                          type
                          selector
                          property
                          value
                        )
                    );
__PACKAGE__->untaint_columns(
    printable => [qw/description type selector property value/],
    integer => [qw/pref_id user_id/],
    );

1;

__END__

=head1 NAME

Apache::Chameleon::Database::User::Preferences

=head1 ABSTRACT

Preferences table manipulation

