package ToDo;
use Moose;
use namespace::autoclean;

use Catalyst::Runtime 5.80;

# Set flags and add plugins for the application
#
#         -Debug: activates the debug mode for very useful log messages
#   ConfigLoader: will load the configuration from a Config::General file in the
#                 application's home directory
# Static::Simple: will serve static files from the application's root
#                 directory

use Catalyst qw/
    -Debug
    ConfigLoader
    Static::Simple
    Session
    Session::Store::FastMmap
    Session::State::Cookie
    Authentication
    FormValidator::Simple
    FormValidator::Simple::Auto
/;
use Digest::SHA1;

extends 'Catalyst';

our $VERSION = '0.01';
$VERSION = eval $VERSION;

# Configure the application.
#
# Note that settings in todo.conf (or other external
# configuration file that you set up manually) take precedence
# over this when using ConfigLoader. Thus configuration
# details given here can function as a default configuration,
# with an external configuration file acting as an override for
# local deployment.

__PACKAGE__->config(
    name => 'ToDo',
    # Disable deprecated behavior needed by old applications
    disable_component_resolution_regex_fallback => 1,
    'Plugin::Session' => {
        expires => 1800,
        storage => '/tmp/todo/session',
        namespace => 'ToDo',
        cookie_expires => 0,
        verify_address => 1,
        verify_user_agent => 1,
    },
    'Plugin::Authentication' => {
        default => {
            credential => {
                class => 'Password',
                password_field => 'password',
                password_type => 'hashed',
                password_hash_type => 'SHA-1'
            },
            store => {
                class => 'DBIx::Class',
                user_model => 'ToDoDB::User',
                use_userdata_from_session => 1,
            },
        },
    },
    'validator' => {
        plugins => [qw/Japanese/],
        options => {
            charset => 'utf8',
        },
        messages => __PACKAGE__->path_to('messages.yml'),
        profiles => __PACKAGE__->path_to('profiles.yml'),
        message_format => '%s',
    },
);

# Start the application
__PACKAGE__->setup();

sub token {
    my $c = shift;

    my @args = ($c->config->{secretkeys});
    if ( $c->user_exists ) {
        unshift @args, $c->user->user_id;
    }

    return Digest::SHA1::sha1_hex(@args);
}

sub validate_token {
    my $c = shift;

    my $token = $c->req->param('token');
    return $token eq $c->token;
}

=head1 NAME

ToDo - Catalyst based application

=head1 SYNOPSIS

    script/todo_server.pl

=head1 DESCRIPTION

[enter your description here]

=head1 SEE ALSO

L<ToDo::Controller::Root>, L<Catalyst>

=head1 AUTHOR

SotaNakamori

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
