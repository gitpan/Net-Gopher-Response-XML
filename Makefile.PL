#!/usr/bin/perl -w
use strict;
use ExtUtils::MakeMaker;

WriteMakefile(
	NAME            => 'Net::Gopher::Response::XML',
	VERSION_FROM    => 'lib/Net/Gopher/Response/XML.pm',
	PL_FILES        => {},
	PREREQ_PM       => {
		'Net::Gopher' => 1.12,
		'IO::String'  => 1.00,
		'XML::Writer' => 0.40,
	},
	($] >= 5.005
		? (ABSTRACT_FROM => 'lib/Net/Gopher/Response/XML.pm',
		   AUTHOR        => 'William G. Davis ' .
		                    '<william_g_davis@users.sourceforge.net>')
		: ()
	),
);
