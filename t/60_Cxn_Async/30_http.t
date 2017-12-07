use Test::More;
use Test::Exception;
use Test::Deep;
use Search::Elasticsearch::Async;

sub is_cxn(@);

### Scalar nodes ###

is_cxn "Default", new_cxn(), {};

is_cxn "Host",
    new_cxn( nodes => 'foo' ),
    { host => 'foo', port => '80', uri => 'http://foo:80' };

is_cxn "Host:Port",
    new_cxn( nodes => 'foo:1000' ),
    { host => 'foo', port => '1000', uri => 'http://foo:1000' };

is_cxn "HTTPS", new_cxn( nodes => 'https://foo' ),
    {
    scheme => 'https',
    host   => 'foo',
    port   => '443',
    uri    => 'https://foo:443'
    };

is_cxn "Path",
    new_cxn( nodes => 'foo/bar' ),
    { host => 'foo', port => '80', uri => 'http://foo:80/bar' };

is_cxn "Userinfo", new_cxn( nodes => 'http://foo:bar@localhost/' ),
    {
    port            => '80',
    uri             => 'http://localhost:80',
    default_headers => { Authorization => 'Basic Zm9vOmJhcg==' },
    userinfo        => 'foo:bar'
    };

is_cxn "IPv4",
    new_cxn( nodes => '127.0.0.1' ),
    { host => '127.0.0.1', port => '80', uri => 'http://127.0.0.1:80' };

is_cxn "Scheme:IPv4",
    new_cxn( nodes => 'https://127.0.0.1' ),
    {
    host   => '127.0.0.1',
    port   => '443',
    uri    => 'https://127.0.0.1:443',
    scheme => 'https'
    };

is_cxn "IPv4:Port",
    new_cxn( nodes => '127.0.0.1:1000' ),
    { host => '127.0.0.1', port => '1000', uri => 'http://127.0.0.1:1000' };

is_cxn "Scheme:IPv4:Port",
    new_cxn( nodes => 'https://127.0.0.1:1000' ),
    {
    host   => '127.0.0.1',
    port   => '1000',
    uri    => 'https://127.0.0.1:1000',
    scheme => 'https'
    };

is_cxn "IPv6",
    new_cxn( nodes => '::1' ),
    { host => '::1', port => '80', uri => 'http://[::1]:80' };

is_cxn "Scheme:IPv6",
    new_cxn( nodes => 'https://[::1]' ),
    {
    host   => '::1',
    port   => '443',
    uri    => 'https://[::1]:443',
    scheme => 'https'
    };

is_cxn "IPv6:Port",
    new_cxn( nodes => '[::1]:1000' ),
    { host => '::1', port => '1000', uri => 'http://[::1]:1000' };

is_cxn "Scheme:IPv6:Port",
    new_cxn( nodes => 'https://[::1]:1000' ),
    {
    host   => '::1',
    port   => '1000',
    uri    => 'https://[::1]:1000',
    scheme => 'https'
    };

### Options with scalar ###

is_cxn "HTTPS option", new_cxn( nodes => 'foo', use_https => 1 ),
    {
    scheme => 'https',
    host   => 'foo',
    port   => '443',
    uri    => 'https://foo:443'
    };

is_cxn "HTTPS option with settings",
    new_cxn( nodes => 'http://foo', use_https => 1 ),
    { scheme => 'http', host => 'foo', port => '80', uri => 'http://foo:80' };

is_cxn "Port option",
    new_cxn( nodes => 'foo', port => 456 ),
    { host => 'foo', port => '456', uri => 'http://foo:456' };

is_cxn "Port option with settings",
    new_cxn( nodes => 'foo:123', port => 456 ),
    { host => 'foo', port => '123', uri => 'http://foo:123' };

is_cxn "Path option",
    new_cxn( nodes => 'foo', path_prefix => '/bar/' ),
    { host => 'foo', port => 80, uri => 'http://foo:80/bar' };

is_cxn "Path option with settings",
    new_cxn( nodes => 'foo/baz/', path_prefix => '/bar/' ),
    { host => 'foo', port => 80, uri => 'http://foo:80/baz' };

is_cxn "Userinfo option", new_cxn( nodes => 'foo', userinfo => 'foo:bar' ),
    {
    host            => 'foo',
    port            => 80,
    uri             => 'http://foo:80',
    default_headers => { Authorization => 'Basic Zm9vOmJhcg==' },
    userinfo        => 'foo:bar'
    };

is_cxn "Userinfo option with settings",
    new_cxn( nodes => 'foo:bar@foo', userinfo => 'foo:baz' ),
    {
    host            => 'foo',
    port            => 80,
    uri             => 'http://foo:80',
    default_headers => { Authorization => 'Basic Zm9vOmJhcg==' },
    userinfo        => 'foo:bar'
    };

is_cxn "Deflate option",
    new_cxn( deflate => 1 ),
    { default_headers => { 'Accept-Encoding' => 'deflate' } };

is_cxn "IPv4 with Port",
    new_cxn( nodes => '127.0.0.1', port => 456),
    { host => '127.0.0.1', port => '456', uri => 'http://127.0.0.1:456' };

is_cxn "IPv6 with Port",
    new_cxn( nodes => '::1', port => 456),
    { host => '::1', port => '456', uri => 'http://[::1]:456' };

### Hash ###
is_cxn "Hash host",
    new_cxn( nodes => { host => 'foo' } ),
    { host => 'foo', port => 80, uri => 'http://foo:80' };

is_cxn "Hash port",
    new_cxn( nodes => { port => '123' } ),
    { port => 123, uri => 'http://localhost:123' };

is_cxn "Hash path",
    new_cxn( nodes => { path => 'baz' } ),
    { port => 80, uri => 'http://localhost:80/baz' };

is_cxn "Hash IPv4 host",
    new_cxn( nodes => { host => '127.0.0.1' } ),
    { host => '127.0.0.1', port => 80, uri => 'http://127.0.0.1:80' };

is_cxn "Hash IPv6 host",
    new_cxn( nodes => { host => '::1' } ),
    { host => '::1', port => 80, uri => 'http://[::1]:80' };

# Build URI
is new_cxn()->build_uri( { path => '/' } ), 'http://localhost:9200/',
    "Default URI";

is new_cxn( { nodes => 'http://localhost:9200/foo' } )
    ->build_uri( { path => '/_search' } ),
    'http://localhost:9200/foo/_search',
    "URI with path";

is new_cxn( { default_qs_params => { session => 'key' } } )
    ->build_uri( { path => '/_search' } ),
    'http://localhost:9200/_search?session=key',
    "default_qs_params";

my $uri = new_cxn( { default_qs_params => { session => 'key' } } )
    ->build_uri( { path => '/_search', qs => { foo => 'bar' } } );

like $uri, qr{^http://localhost:9200/_search?},
    "default_qs_params and qs - 1";
like $uri, qr{session=key}, "default_qs_params and qs - 2";
like $uri, qr{foo=bar},     "default_qs_params and qs - 3";

is new_cxn( { default_qs_params => { session => 'key' } } )
    ->build_uri( { path => '/_search', qs => { session => 'bar' } } ),
    'http://localhost:9200/_search?session=bar',
    "default_qs_params overwritten";

done_testing;

#===================================
sub is_cxn (@) {
#===================================
    my ( $title, $cxn, $params ) = @_;
    my %params = (
        host            => 'localhost',
        port            => '9200',
        scheme          => 'http',
        uri             => 'http://localhost:9200',
        default_headers => {},
        userinfo        => '',
        %$params
    );

    for my $key ( sort keys %params ) {
        my $val = $cxn->$key;
        $val = "$val" unless ref $val eq 'HASH';
        cmp_deeply $val, $params{$key}, "$title - $key";
    }
}

#===================================
sub new_cxn {
#===================================
    return Search::Elasticsearch::Async->new(@_)
        ->transport->cxn_pool->cxns->[0];
}
