package Apache::Chameleon::Document::Processor;

use strict;
use warnings;

use Apache::Chameleon::Database::Document;
use Apache::Chameleon::Template::Provider;
use Apache::Chameleon::Theme;
use Template;
use Template::Service;
use Template::Plugins;
use Template::Context;

use base qw(Apache::Chameleon::Base);

our $VERSION       = '0.01';
our $DefaultIndex  = 'index.html';
our $DefaultTitle  = 'Untitled Document';
our $GlobalConfig  = '/config';

sub new {
    my $class = shift;
    my $self  = bless {}, $class;
    my $param = shift;
    my $user  = shift;

    $self->parameters($param);
    $self->user      ($user);

    my ($u, $e) = $self->parameters->get('uri');

    return $self;
}

sub uri {
    my $self = shift;
    return $self->{_uri} || do {
        my ($u, $e) = $self->parameters->get('uri');
        $self->{_uri} = $self->clean_path($u);
        return $self->{_uri};
    }
}

sub document {
    my $self = shift;
    my $uri = shift;
    return Apache::Chameleon::Document->new($uri);
}

sub user {
    $_[0]->{_user} = $_[1] if $_[1];
    return $_[0]->{_user};
}

sub parameters {
    $_[0]->{_parameters} = $_[1] if $_[1];
    return $_[0]->{_parameters};
}

sub exists {
    return $_[0]->document($_[0]->uri)->exists;
}

sub context {
    $_[0]->{_context} = $_[1] if $_[1];
    return $_[0]->{_context};
}

sub get {
    my $self = shift;

    $self->setup_tt_vars;
    return $self->render(
        $self->uri, 
        $self->tt_vars, 
        $self->tt_vars('theme')
        );
}

sub tt_vars {
    my $self = shift;
    my $get  = shift;
    my $set  = shift;
    $self->{_tt_vars} = {} unless $self->{_tt_vars};

    if    ( $set and $get) { $self->{_tt_vars}->{$get} = $set; }
    elsif (!$set and $get) { return $self->{_tt_vars}->{$get}; }
    else                   { return $self->{_tt_vars};         }
}

sub render {
    my $self  = shift;
    my $doc   = shift;
    my $vars  = shift;
    my $theme = shift;

    my ($pre, $post) = $self->get_theme($theme);
    my $service = Template::Service->new({
        LOAD_PLUGINS   => Template::Plugins->new({ PLUGIN_BASE    => 
                'Apache::Chameleon::Template::Plugin'}),
        LOAD_TEMPLATES => Apache::Chameleon::Template::Provider->new,
        PRE_PROCESS    => $pre,
        POST_PROCESS   => $post,
    });

    my $template = Template->new({
        SERVICE        => $service,
        INTERPOLATE    => 0,
    }) || die Template->error;

    $self->context($service->context);
    my $temp = undef;
    $template->process($doc, $vars, \$temp) || die $template->error;
    return $temp;
}

sub get_theme {
    my $self = shift;
    my $theme = shift;

    # Get theme
    my $aot = Apache::Chameleon::Theme->new;
    my ($t, $e) = $aot->get($theme);
    # It failed, try for default theme
    $t = $aot->get('default') if $e;
    
    # Get header, footer and configuration files
    my (@pre, @post);
    push @pre, ($GlobalConfig) if $self->exists($GlobalConfig);
    if (defined $t) {
	push @pre,  ($t->header) if $self->exists($t->header);
	push @pre,  ($t->config) if $self->exists($t->config);
	push @post, ($t->footer) if $self->exists($t->footer);
    }
    return (\@pre, \@post);
}


sub setup_tt_vars {
    my $self = shift;

    my ($test_theme, $error) = $self->parameters->get('theme');
    #user is trying it
    my @side  = qw(left right top bottom);
    foreach (@side) {
        $self->tt_vars($_ . '_panels' =>
            $self->user->preferences->get_values_by_type('panel', $_))
    }

    $self->tt_vars(user        => $self->user                              );
    $self->tt_vars(location    => $self->uri                               );
    $self->tt_vars(hostname    => $self->parameters->get('hostname')       );
    $self->tt_vars(remote_host => $self->parameters->get('last_ip_address'));
    $self->tt_vars(title       => $self->document($self->uri)->title       );
    $self->tt_vars(theme       => $self->user->preferences->theme          );
    $self->tt_vars(theme       => $test_theme) unless $error;
    $self->tt_vars(CSS         => $self->user->preferences->make_css       );
    $self->tt_vars(parameters  => \$self->parameters                       );

    return $self->tt_vars;
}

sub clean_path {
    my $self = shift;
    my $path = shift;
    $path = Apache::Chameleon::Untaint::Path->canonpath($path);
    Apache::Chameleon::Untaint::Path->file_name_is_absolute($path) ? 
        $path = $path :
        $path = Apache::Chameleon::Untaint::Path->rel2abs($path);
    return $path;
}

1;

__END__

=head1 NAME

Apache::Chameleon::Document::Processor

=head1 ABSTRACT

Document processing class

=head2 new

Simple constructor

=head2 uri

Gets request URI

=head2 document

Get/set document object

=head2 user

Get/set user object

=head2 parameters

Get/set parameter object

=head2 exists

Checks to see if the document requested exists.

=head2 context

Get/set the Template context.

=head2 get

Does the document stuff.

=head2 tt_vars

Get or set Template Toolkit variables.

=head2 render

Renders a document with Template Toolkit.

=head2 get_theme

Gets the headers and footers for a theme

=head2 setup_tt_vars

Set some useful Template Toolkit variables.

=head2 clean_path

Cleans up a filepath

=head1 SEE ALSO

F<Apache::Chameleon>

=cut
