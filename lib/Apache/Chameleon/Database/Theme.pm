package Apache::Chameleon::Database::Theme;

use strict;
use warnings;
use Class::DBI::FromCGI;
use base qw(Apache::Chameleon::Database::Base);
our $VERSION = '0.01';

__PACKAGE__->table('Theme');
__PACKAGE__->columns(
               All => qw( theme_id 
                          name
			  owner_id
                          header
                          footer
                          config
                          description
                        )
		     );
__PACKAGE__->untaint_columns(
    printable => [qw/name header footer config description/],
    integer => [qw/theme_id owner_id/],
    );

1;

__END__

=head1 NAME

Apache::Chameleon::Database::Theme

=head1 ABSTRACT

Theme table manipulation

