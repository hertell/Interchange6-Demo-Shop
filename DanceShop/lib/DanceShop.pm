use utf8;
package DanceShop;

=encoding utf8

=head1 NAME

DanceShop - base Demo Shop for Interchange 6

=head1 VERSION

0.001

=cut

our $VERSION = '0.001';

use Dancer ':syntax';
use Dancer::Plugin::Auth::Extensible;
use Dancer::Plugin::DBIC;
use Dancer::Plugin::Interchange6;
use Dancer::Plugin::Interchange6::Routes;

use DanceShop::Routes::Checkout;

set session => 'DBIC';
set session_options => {schema => schema};

hook 'before_layout_render' => sub {
    my $tokens = shift;

    $tokens->{cart} = cart;

    my $nav = shop_navigation->search(
        {
            type => 'nav',
            parent_id => undef,
        },
        {
            order_by => { -asc => 'priority'},
        }
    );
    while (my $record = $nav->next) {
        push @{$tokens->{'nav-' . $record->scope}}, $record;
    };
};

get '/' => sub {
    template 'index';
};

shop_setup_routes;

true;
