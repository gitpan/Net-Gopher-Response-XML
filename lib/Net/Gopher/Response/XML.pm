
package Net::Gopher::Response::XML;

=head1 NAME

Net::Gopher::Response::XML - Convert a Gopher/Gopher+ response to XML

=head1 SYNOPSIS

 use Net::Gopher;
 use Net::Gopher::Response::XML;
 
 ...
 
 $response->as_xml(File => 'menu.xml');

=head1 DESCRIPTION

This module contains code to convert a response from a Gopher or Gopher+
Gopherspace to XML. This functionality was originally in the Net::Gopher core,
but its features are seldom needed, and it was deemed by me, Will, to be
unnecessary bloat.

The module has one method, C<as_xml()>, which you can call on
B<Net::Gopher::Response> objects to generate XML. If you have existing code
that expects C<Net::Gopher::Response> to already have C<as_xml()> in it, just
add the C<use Net::Gopher::Response::XML> to the top of the script as shown in
the L<SYNOPSIS|Net::Gopher::Response::XML/SYNOPSIS> and it should work fine
with both pre 1.05 and post 1.05 versions.

=head1 METHODS

The following methods are available:

=cut

use 5.005;
use strict;
use warnings;
use vars qw($VERSION @ISA);
use Carp;
use IO::File;
use IO::String;
use XML::Writer;
use Net::Gopher::Constants qw(:request :item_types);
use Net::Gopher::Exception;
use Net::Gopher::Utility  qw(check_params %ITEM_DESCRIPTIONS);

$VERSION = '0.77';

push(@ISA, 'Net::Gopher::Exception');





#==============================================================================#

=head2 as_xml([OPTIONS])

This method converts a Gopher or Gopher+ response to XML; either returning the
generated XML or saving it to disk.

This method takes several named parameters:

=over 4

=item File

The I<File> parameter is used to specify the filename of the file where the XML
will be outputted to. If a file with that name doesn't exist, it will be
created. If a file with that name already exists, anything in it will be
overwritten.

=item Pretty

The I<Pretty> parameter is used to control the style of the markup. If
I<Pretty> is true, then this method will insert linebreaks between tags and
add indentation. By default, pretty is true.

=item Declaration

The I<Declaration> parameter tells the method whether or not it should generate
an XML C<E<lt>?xml ...?E<gt> declaration at the beginning of the generated XML.
By default, this is true.

=back

If you don't specify I<File>, then rather than being saved to disk, a string
containing the generated XML will be returned to you.

=cut

sub Net::Gopher::Response::as_xml
{
	my $self = shift;

	$self->call_warn(
		sprintf("You sent a %s request for a %s item. The response " .
		        "shouldn't contain text and shouldn't be " .
			"convertable to XML.",
			$self->request->request_type == GOPHER_PLUS_REQUEST
				? 'Gopher+'
				: 'Gopher',
			$ITEM_DESCRIPTIONS{$self->request->item_type}
		)
	) unless ($self->is_text
		or !exists $ITEM_DESCRIPTIONS{$self->request->item_type});

	my ($filename, $pretty, $declaration) =
		check_params(['File', 'Pretty', 'Declaration'], \@_);

	# default to on if either was not supplied:
	$pretty      = (defined $pretty) ? $pretty : 1;
	$declaration = (defined $declaration) ? $declaration : 1;



	# either an IO::Handle object if a filename was supplied or an
	# IO::String object:
	my $handle;

	# this will store the generated XML to be returned if no filename was
	# supplied:
	my $xml;

	if (defined $filename)
	{
		$handle = new IO::File ("> $filename")
			or return $self->call_die(
				"Couldn't open file ($filename) to " .
				"save XML to: $!."
			);
	}
	else
	{
		# use a string instead:
		$handle = new IO::String ($xml);
	}



	my $writer = new XML::Writer (
		OUTPUT      => $handle,
		DATA_MODE   => $pretty ? 1 : 0, # add newlines.
		DATA_INDENT => $pretty ? 3 : 0  # use a three-space indent.
	);

	$writer->xmlDecl('UTF-8') if ($declaration);

	if (($self->request->request_type == ITEM_ATTRIBUTE_REQUEST
		or $self->request->request_type == DIRECTORY_ATTRIBUTE_REQUEST)
			and $self->is_blocks)
	{
		gen_block_xml($self, $writer);
	}
	elsif (($self->request->item_type eq GOPHER_MENU_TYPE
		or $self->request->item_type eq INDEX_SEARCH_SERVER_TYPE)
			and $self->is_menu)
	{
		gen_menu_xml($self, $writer);
	}
	else
	{
		gen_text_xml($self, $writer);
	}

	$writer->end;



	if (defined $filename)
	{
		$handle->close;
	}
	else
	{
		return $xml;
	}
}





################################################################################
#
#	Function
#		gen_block_xml($response, $writer)
#
#	Purpose
#		This method generates XML for Gopher+ item/directory attribute
#		information blocks.
#
#	Parameters
#		$response - A Net::Gopher::Response object.
#		$writer   - An XML::Writer object.
#

sub gen_block_xml
{
	my ($response, $writer) = @_;



	# if we don't do this, we get a ton of "Use of unitialized..." errors:
	local $^W = 0;

	if ($response->request->request_type == ITEM_ATTRIBUTE_REQUEST)
	{
		$writer->startTag('response',
			description => 'item attribute information',
			url         => $response->request->as_url
		);
	}
	else
	{
		$writer->startTag('response',
			description => 'directory attribute information',
			url         => $response->request->as_url
		);
	}



	my @items = ($response->request->request_type == ITEM_ATTRIBUTE_REQUEST)
				? [ $response->get_blocks ]
				:   $response->get_blocks;

	foreach my $item (@items)
	{
		$writer->startTag('item');

		foreach my $block (@$item)
		{
			$writer->startTag('block', name => $block->name);

			if ($block->name eq '+ASK')
			{
				foreach my $query ($block->extract_queries)
				{
					$writer->startTag('query');
					$writer->dataElement(
						'type', $query->{'type'}
					);
					$writer->dataElement(
						'question', $query->{'question'}
					);

					foreach my $answer (@{$query->{'defaults'}})
					{
						$writer->dataElement(
							'default-answer', $answer
						);
					}

					$writer->endTag('query');
				}
			}
			elsif ($block->name eq '+INFO')
			{
				my ($type, $display, $selector,
				    $host, $port, $gopher_plus) =
						$block->extract_description;

				$writer->dataElement('item-type', $type);
				$writer->dataElement(
					'display-string', $display
				);
				$writer->dataElement(
					'selector-string', $selector
				);
				$writer->dataElement('host', $host);
				$writer->dataElement('port', $port);
				$writer->dataElement(
					'gopher-plus-string', $gopher_plus
				);
			}
			elsif ($block->name eq '+VIEWS')
			{
				foreach my $view ($block->extract_views)
				{
					$writer->startTag('view');
					$writer->dataElement(
						'mime-type', $view->{'type'}
					);
					$writer->dataElement(
						'language', $view->{'language'}
					);
					$writer->dataElement(
						'country', $view->{'country'}
					);
					$writer->dataElement(
						'size', $view->{'size'}
					);
					$writer->endTag('view');
				}
			}
			elsif ($block->is_attributes)
			{
				my %attributes = $block->get_attributes;

				while (my ($name, $value) = each %attributes)
				{
					$writer->dataElement(
						'attribute',
						$value, name => $name
					);
				}
			}
			else
			{
				$writer->characters($block->value)
			}

			$writer->endTag('block');
		}

		$writer->endTag('item');
	}



	$writer->endTag('response');
}





################################################################################
#
#	Function
#		gen_menu_xml($response, $writer)
#
#	Purpose
#		This method generates XML for Gopher and Gopher+ menus.
#
#	Parameters
#		$response - A Net::Gopher::Response object.
#		$writer   - An XML::Writer object.
#

sub gen_menu_xml
{
	my ($response, $writer) = @_;



	local $^W = 0;

	$writer->startTag('response',
		'item-type' => $response->request->item_type,
		description =>
			exists $ITEM_DESCRIPTIONS{$response->request->item_type}
				? $ITEM_DESCRIPTIONS{$response->request->item_type}
				: 'unknown item',
		url         => $response->request->as_url
	);

	foreach my $menu_item ($response->extract_items)
	{
		if ($menu_item->item_type eq INLINE_TEXT_TYPE)
		{
			$writer->dataElement('inline-text', $menu_item->display);
		}
		else
		{
			$writer->startTag('item', url => $menu_item->as_url);
			$writer->dataElement('item-type', $menu_item->item_type);
			$writer->dataElement('display-string', $menu_item->display);
			$writer->dataElement('selector-string', $menu_item->selector);
			$writer->dataElement('host', $menu_item->host);
			$writer->dataElement('port', $menu_item->port);
			$writer->dataElement(
				'gopher-plus-string', $menu_item->gopher_plus);
			$writer->endTag('item');
		}
	}



	$writer->endTag('response');
}





################################################################################
#
#	Function
#		gen_text_xml($response, $writer)
#
#	Purpose
#		This method generates XML for text items.
#
#	Parameters
#		$response - A Net::Gopher::Response object.
#		$writer   - An XML::Writer object.
#

sub gen_text_xml
{
	my ($response, $writer) = @_;


	
	local $^W = 0;

	$writer->startTag('response',
		'item-type' => $response->request->item_type,
		description =>
			exists $ITEM_DESCRIPTIONS{$response->request->item_type}
				? $ITEM_DESCRIPTIONS{$response->request->item_type}
				: 'unknown item',
		url         => $response->request->as_url,
	);
	$writer->dataElement('content', $response->content);
	$writer->endTag('response');
}

1;

=head1 BUGS

Bugs in this package can reported and monitored using CPAN's request
tracker: rt.cpan.org.

If you wish to report bugs to me directly, you can reach me via email at
<william_g_davis at users dot sourceforge dot net>.

=head1 SEE ALSO

L<Net::Gopher::Response|Net::Gopher::Response>

=head1 COPYRIGHT

Copyright 2003-2004 by William G. Davis.

This module is free software released under the GNU General Public License,
the full terms of which can be found in the "COPYING" file that comes with
the distribution.

=cut
