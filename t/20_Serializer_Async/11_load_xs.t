# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

use Test::More;

use lib sub {
    die "No Cpanel" if $_[1] =~ m{Cpanel/JSON/XS.pm$};
    return undef;
};

use Search::Elasticsearch;

my $s = Search::Elasticsearch->new()->transport->serializer->JSON;

SKIP: {
    skip 'JSON::XS not installed' => 1
        unless eval { require JSON::XS; 1 };

    isa_ok $s, "JSON::XS", 'JSON::XS';
}

done_testing;

