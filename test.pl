#!/usr/bin/perl -w
use strict;
use IO::Socket 'SOCK_STREAM';
use Test;

BEGIN
{
	my $socket = new IO::Socket::INET (
		Type     => SOCK_STREAM,
		Proto    => 'tcp',
		PeerAddr => 'www.cpan.org',
		PeerPort => 80,
		Timeout  => 60
	);

	if ($socket)
	{
		close $socket;

		plan(tests => 5);
	}
	else
	{
		plan(tests => 0);
		exit;
	}
}

use Net::Gopher;
use Net::Gopher::Response::XML;



my $ng = new Net::Gopher;

{
	my $response = $ng->gopher(Host => 'gopher.floodgap.com');

	ok($response->as_xml(File => 'pretty.xml', Pretty => 1));    # 1
	ok(open(PRETTY, 'pretty.xml'));                              # 2
	my $xml = join('', <PRETTY>);
	ok($xml =~ /^<\?xml version="\d\.\d" encoding="UTF-8"\?>/);  # 3
	ok(close PRETTY);                                            # 4
	ok(unlink 'pretty.xml');                                     # 5
}
