#!/usr/bin/perl -w
use strict;
use Module::Build;

my $mb = new Module::Build (
	module_name => 'Net::Gopher::Response::XML',
	license     => 'GPL',
	requires    => {
		'Net::Gopher' => 1.12,
		'IO::String'  => 1.00,
		'XML::Writer' => 0.40,
	}
)->create_build_script;
