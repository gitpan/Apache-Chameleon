package Apache::Chameleon::Database::Document;

use strict;
use warnings;
use base qw(Apache::Chameleon::Database::Base);

our $VERSION = '0.01';

__PACKAGE__->table('Documents');
__PACKAGE__->columns(
               All => qw( document_id
                          path
                          title
                          version
                          author_id
                          locker_id
                          created
                          type
                          worldread
                          worldwrite
                          contents
                        )
                    );
__PACKAGE__->hasa('Apache::Chameleon::Database::User' => 'author_id');
__PACKAGE__->untaint_columns(
    printable => [qw/path title type contents/],
    integer => [qw/version author_id locker_id worldread worldwrite/],
    date => [qw/created/],
    );

1;

__END__

=head1 NAME

Apache::Chameleon::Database::Document

=head1 ABSTRACT

Document table manipulation

