package Apache::Chameleon::Template::Provider;

use strict;
use warnings;
use base qw( Template::Provider );
use Apache::Chameleon::Document;

our $VERSION = 0.01;


sub fetch {
    my ($self, $name) = @_;
    my ($data, $document, $error, $aoerror);

    # Get the document
    my $aod = Apache::Chameleon::Document->new($name);
    ($document, $aoerror) = $aod->contents;

    # Let TT do its thing
    ($data, $error) = $self->_load(\$document);
    ($data, $error) = $self->_compile($data) unless $error;
    $data = $data->{data} unless $error;

    # Return
    return ($data, $error);
}

1;

__END__

=head1 NAME

Apache::Chameleon::Template::Provider

=head1 ABSTRACT

Used to get templates from the database. Subclass of L<Template::Provider>.

=head2 METHODS

=head2 fetch

Gets documents from the database.

=head1 SEE ALSO

L<Apache::Chameleon>

L<Template>

L<Template::Provider>

=cut
