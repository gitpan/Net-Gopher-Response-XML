#!/usr/bin/perl -w
use strict;
use Test;

use Net::Gopher;
use Net::Gopher::Request qw(Gopher GopherPlus ItemAttribute DirectoryAttribute);
use Net::Gopher::Response;
use Net::Gopher::Response::XML;
use Net::Gopher::Constants qw(:item_types);

use vars qw(%ITEMS);
use vars qw(%XML);

BEGIN { plan(tests => 47) }








{
	my $response = new Net::Gopher::Response (
		Request => Gopher(
			Host => 'fakehost.com'
		),
		Content => $ITEMS{'menu'}
	);

	ok($response->as_xml, $XML{'menu'}); # 1

	$response->as_xml(File => 'menu.xml');
	if (open(MENU_FILE, 'menu.xml'))
	{
		ok(1); # 2
	}
	else
	{
		ok(0);
		warn "Couldn't open XML file (menu.xml): $!";
	}

	ok(join('', <MENU_FILE>), $XML{'menu'}); # 3
	ok(close MENU_FILE);                     # 4
	ok(unlink('menu.xml'), 1);               # 5
}

{
	my $response = new Net::Gopher::Response (
		Request => Gopher(
			Host => 'fakehost.com'
		),
		Content => $ITEMS{'menu'}
	);

	ok($response->as_xml(Pretty => 0), $XML{'menu_not_pretty'}); # 6

	$response->as_xml(Pretty => 0, File => 'menu_not_pretty.xml');
	if (open(MENU_NOT_PRETTY_FILE, 'menu_not_pretty.xml'))
	{
		ok(1); # 7
	}
	else
	{
		ok(0);
		warn "Couldn't open XML file (menu_not_pretty.xml): $!";
	}

	ok(join('', <MENU_NOT_PRETTY_FILE>), $XML{'menu_not_pretty'}); # 8
	ok(close MENU_NOT_PRETTY_FILE);                                # 9
	ok(unlink('menu_not_pretty.xml'), 1);                          # 10
}

{
	my $response = new Net::Gopher::Response (
		Request => Gopher(
			Host => 'fakehost.com'
		),
		Content => $ITEMS{'menu'}
	);

	ok($response->as_xml(Declaration => 0),
		$XML{'menu_no_declaration'}); # 11

	$response->as_xml(Declaration => 0, File => 'menu_no_declaration.xml');
	if (open(MENU_NO_DECLARATION_FILE, 'menu_no_declaration.xml'))
	{
		ok(1); # 12
	}
	else
	{
		ok(0);
		warn "Couldn't open XML file (menu_no_declaration.xml): $!";
	}

	ok(join('', <MENU_NO_DECLARATION_FILE>),
		$XML{'menu_no_declaration'});     # 13
	ok(close MENU_NO_DECLARATION_FILE);       # 14
	ok(unlink('menu_no_declaration.xml'), 1); # 15
}



{
	my $response = new Net::Gopher::Response (
		Request => ItemAttribute(
			Host     => 'fakehost.com',
			Selector => '/some_item',
		),
		RawResponse => "+-1\015\012" . $ITEMS{'blocks'},
		StatusLine  => "+-1\015\012",
		Status      => "+",
		Content     => $ITEMS{'blocks'}
	);

	ok($response->as_xml, $XML{'blocks'}); # 16

	$response->as_xml(File => 'blocks.xml');
	if (open(BLOCKS_FILE, 'blocks.xml'))
	{
		ok(1); # 17
	}
	else
	{
		ok(0);
		warn "Couldn't open XML file (blocks.xml): $!";
	}

	ok(join('', <BLOCKS_FILE>), $XML{'blocks'}); # 18
	ok(close BLOCKS_FILE);                       # 19
	ok(unlink('blocks.xml'), 1);                 # 20
}

{
	my $response = new Net::Gopher::Response (
		Request => ItemAttribute(
			Host     => 'fakehost.com',
			Selector => '/some_item',
		),
		RawResponse => "+-1\015\012" . $ITEMS{'blocks'},
		StatusLine  => "+-1\015\012",
		Status      => "+",
		Content     => $ITEMS{'blocks'}
	);

	ok($response->as_xml(Pretty => 0), $XML{'blocks_not_pretty'}); # 21

	$response->as_xml(File => 'blocks_not_pretty.xml', Pretty => 0);
	if (open(BLOCKS_NOT_PRETTY_FILE, 'blocks_not_pretty.xml'))
	{
		ok(1); # 22
	}
	else
	{
		ok(0);
		warn "Couldn't open XML file (blocks_not_pretty.xml): $!";
	}

	ok(join('', <BLOCKS_NOT_PRETTY_FILE>), $XML{'blocks_not_pretty'}); # 23
	ok(close BLOCKS_NOT_PRETTY_FILE);                                  # 24
	ok(unlink('blocks_not_pretty.xml'), 1);                            # 25
}

{
	my $response = new Net::Gopher::Response (
		Request => ItemAttribute(
			Host     => 'fakehost.com',
			Selector => '/some_item',
		),
		RawResponse => "+-1\015\012" . $ITEMS{'blocks'},
		StatusLine  => "+-1\015\012",
		Status      => "+",
		Content     => $ITEMS{'blocks'}
	);

	ok($response->as_xml(Declaration => 0),
		$XML{'blocks_no_declaration'}); # 26

	$response->as_xml(
		File        => 'blocks_no_declaration.xml',
		Declaration => 0
	);
	if (open(BLOCKS_NO_DECLARATION_FILE, 'blocks_no_declaration.xml'))
	{
		ok(1); # 27
	}
	else
	{
		ok(0);
		warn "Couldn't open XML file (blocks_no_declaration.xml): $!";
	}

	ok(join('', <BLOCKS_NO_DECLARATION_FILE>),
		$XML{'blocks_no_declaration'});     # 28
	ok(close BLOCKS_NO_DECLARATION_FILE);       # 29
	ok(unlink('blocks_no_declaration.xml'), 1); # 30
}



{
	my $response = new Net::Gopher::Response (
		Request => Gopher(
			Host     => 'fakehost.com',
			Selector => '/textfile.txt',
			ItemType => TEXT_FILE_TYPE
		),
		Content => $ITEMS{'text'}
	);

	ok($response->as_xml, $XML{'text'}); # 31

	$response->as_xml(File => 'text.xml');
	if (open(TEXT_FILE, 'text.xml'))
	{
		ok(1); # 32
	}
	else
	{
		ok(0);
		warn "Couldn't open XML file (text.xml): $!";
	}

	ok(join('', <TEXT_FILE>), $XML{'text'}); # 33
	ok(close TEXT_FILE);                     # 34
	ok(unlink('text.xml'), 1);               # 35
}

{
	my $response = new Net::Gopher::Response (
		Request => Gopher(
			Host     => 'fakehost.com',
			Selector => '/textfile.txt',
			ItemType => TEXT_FILE_TYPE
		),
		Content => $ITEMS{'text'}
	);

	ok($response->as_xml(Pretty => 0), $XML{'text_not_pretty'}); # 36

	$response->as_xml(File => 'text_not_pretty.xml', Pretty => 0);
	if (open(TEXT_NOT_PRETTY_FILE, 'text_not_pretty.xml'))
	{
		ok(1); # 37
	}
	else
	{
		ok(0);
		warn "Couldn't open XML file (text_not_pretty.xml): $!";
	}

	ok(join('', <TEXT_NOT_PRETTY_FILE>), $XML{'text_not_pretty'}); # 38
	ok(close TEXT_NOT_PRETTY_FILE);                                # 39
	ok(unlink('text_not_pretty.xml'), 1);                          # 40
}

{
	my $response = new Net::Gopher::Response (
		Request => Gopher(
			Host     => 'fakehost.com',
			Selector => '/textfile.txt',
			ItemType => TEXT_FILE_TYPE
		),
		Content => $ITEMS{'text'}
	);

	ok($response->as_xml(Declaration => 0),
		$XML{'text_no_declaration'}); # 41

	$response->as_xml(
		File        => 'text_no_declaration.xml',
		Declaration => 0
	);
	if (open(TEXT_NO_DECLARATION_FILE, 'text_no_declaration.xml'))
	{
		ok(1); # 42
	}
	else
	{
		ok(0);
		warn "Couldn't open XML file (text_no_declaration.xml): $!";
	}

	ok(join('', <TEXT_NO_DECLARATION_FILE>),
		$XML{'text_no_declaration'});     # 43
	ok(close TEXT_NO_DECLARATION_FILE);       # 44
	ok(unlink('text_no_declaration.xml'), 1); # 45
}



{
	my @warnings;
	my $ng = new Net::Gopher (WarnHandler => sub { push(@warnings,shift) });
	my $response = new Net::Gopher::Response (
		Request => GopherPlus(
			Host     => 'fakehost.com',
			Selector => '/application.exe',
			ItemType => BINARY_FILE_TYPE
		),
		Content => 'Stuff'
	);

	$response->as_xml;

	ok(@warnings, 1);                 # 46
	ok($warnings[0],
		"You sent a Gopher+ request for a binary file item. The " .
		"response shouldn't contain text and you shouldn't be able " .
		"to convert it to XML."); # 47
}

BEGIN {
	%ITEMS = (
		menu => <<END_OF_ITEM,
iWelcome to this Gopherspace.\t\t\t
iHere you will find some files and stuff.\t\t\t
0Welcome\t/welcome.txt\tfakehost.com\t70
1Some item\t/some_item\tfakehost.com\t70
1Some other item\t/some_other_item\tfakehost.com\t70
iSome GIF image:\t\t\t
gBlue Sky\t/blue_sky.gif\tfakehost.com\t70
END_OF_ITEM

		blocks => <<END_OF_ITEM,
+INFO: 0Some text file\t/sometextfile.txt\tfakehost.com\t70
+ADMIN:
 Admin: Fake Name (fakename\@fakehost.com)
 Mod-Date: 20040507215208
 Custom-Attr: some value
+VIEWS:
 text/plain: <.5K>
 text/html En_US: <1.2K>
 application/pdf En_US: <104506B>
+ABSTACT:
 This is file that contains some text
 This is file that contains some text
 This is file that contains some text
 This is file that contains some text
 This is file that contains some text
+CUSTOM-BLOCK: custom value
END_OF_ITEM

		text => <<END_OF_ITEM,
1.  Introduction

   The Internet Gopher protocol is designed primarily to act as a
   distributed document delivery system.  While documents (and services)
   reside on many servers, Gopher client software presents users with a
   hierarchy of items and directories much like a file system.  In fact,
   the Gopher interface is designed to resemble a file system since a
   file system is a good model for locating documents and services.  Why
   model a campus-wide information system after a file system?  Several
   reasons:

      (a) A hierarchical arrangement of information is familiar to many
      users.  Hierarchical directories containing items (such as
      documents, servers, and subdirectories) are widely used in
      electronic bulletin boards and other campus-wide information
      systems. People who access a campus-wide information server will
      expect some sort of hierarchical organization to the information
      presented.




Anklesari, McCahill, Lindner, Johnson, Torrey & Alberti         [Page 2]

RFC 1436                         Gopher                       March 1993


      (b) A file-system style hierarchy can be expressed in a simple
      syntax.  The syntax used for the internet Gopher protocol is
      easily understandable, and was designed to make debugging servers
      and clients easy.  You can use Telnet to simulate an internet
      Gopher client's requests and observe the responses from a server.
      Special purpose software tools are not required.  By keeping the
      syntax of the pseudo-file system client/server protocol simple, we
      can also achieve better performance for a very common user
      activity: browsing through the directory hierarchy.

      (c) Since Gopher originated in a University setting, one of the
      goals was for departments to have the option of publishing
      information from their inexpensive desktop machines, and since
      much of the information can be presented as simple text files
      arranged in directories, a protocol modeled after a file system
      has immediate utility.  Because there can be a direct mapping from
      the file system on the user's desktop machine to the directory
      structure published via the Gopher protocol, the problem of
      writing server software for slow desktop systems is minimized.

      (d) A file system metaphor is extensible.  By giving a "type"
      attribute to items in the pseudo-file system, it is possible to
      accommodate documents other than simple text documents.  Complex
      database services can be handled as a separate type of item.  A
      file-system metaphor does not rule out search or database-style
      queries for access to documents.  A search-server type is also
      defined in this pseudo-file system.  Such servers return "virtual
      directories" or list of documents matching user specified
      criteria.
END_OF_ITEM
	);





	%XML = (
		menu => <<END_OF_XML,
<?xml version="1.0" encoding="UTF-8"?>

<response item-type="1" description="Gopher menu" url="gopher://fakehost.com:70/1">
   <inline-text>Welcome to this Gopherspace.</inline-text>
   <inline-text>Here you will find some files and stuff.</inline-text>
   <item url="gopher://fakehost.com:70/0/welcome.txt">
      <item-type>0</item-type>
      <display-string>Welcome</display-string>
      <selector-string>/welcome.txt</selector-string>
      <host>fakehost.com</host>
      <port>70</port>
      <gopher-plus-string></gopher-plus-string>
   </item>
   <item url="gopher://fakehost.com:70/1/some_item">
      <item-type>1</item-type>
      <display-string>Some item</display-string>
      <selector-string>/some_item</selector-string>
      <host>fakehost.com</host>
      <port>70</port>
      <gopher-plus-string></gopher-plus-string>
   </item>
   <item url="gopher://fakehost.com:70/1/some_other_item">
      <item-type>1</item-type>
      <display-string>Some other item</display-string>
      <selector-string>/some_other_item</selector-string>
      <host>fakehost.com</host>
      <port>70</port>
      <gopher-plus-string></gopher-plus-string>
   </item>
   <inline-text>Some GIF image:</inline-text>
   <item url="gopher://fakehost.com:70/g/blue_sky.gif">
      <item-type>g</item-type>
      <display-string>Blue Sky</display-string>
      <selector-string>/blue_sky.gif</selector-string>
      <host>fakehost.com</host>
      <port>70</port>
      <gopher-plus-string></gopher-plus-string>
   </item>
</response>
END_OF_XML

	menu_not_pretty => <<END_OF_XML,
<?xml version="1.0" encoding="UTF-8"?>
<response item-type="1" description="Gopher menu" url="gopher://fakehost.com:70/1"><inline-text>Welcome to this Gopherspace.</inline-text><inline-text>Here you will find some files and stuff.</inline-text><item url="gopher://fakehost.com:70/0/welcome.txt"><item-type>0</item-type><display-string>Welcome</display-string><selector-string>/welcome.txt</selector-string><host>fakehost.com</host><port>70</port><gopher-plus-string></gopher-plus-string></item><item url="gopher://fakehost.com:70/1/some_item"><item-type>1</item-type><display-string>Some item</display-string><selector-string>/some_item</selector-string><host>fakehost.com</host><port>70</port><gopher-plus-string></gopher-plus-string></item><item url="gopher://fakehost.com:70/1/some_other_item"><item-type>1</item-type><display-string>Some other item</display-string><selector-string>/some_other_item</selector-string><host>fakehost.com</host><port>70</port><gopher-plus-string></gopher-plus-string></item><inline-text>Some GIF image:</inline-text><item url="gopher://fakehost.com:70/g/blue_sky.gif"><item-type>g</item-type><display-string>Blue Sky</display-string><selector-string>/blue_sky.gif</selector-string><host>fakehost.com</host><port>70</port><gopher-plus-string></gopher-plus-string></item></response>
END_OF_XML

	menu_no_declaration => <<END_OF_XML,

<response item-type="1" description="Gopher menu" url="gopher://fakehost.com:70/1">
   <inline-text>Welcome to this Gopherspace.</inline-text>
   <inline-text>Here you will find some files and stuff.</inline-text>
   <item url="gopher://fakehost.com:70/0/welcome.txt">
      <item-type>0</item-type>
      <display-string>Welcome</display-string>
      <selector-string>/welcome.txt</selector-string>
      <host>fakehost.com</host>
      <port>70</port>
      <gopher-plus-string></gopher-plus-string>
   </item>
   <item url="gopher://fakehost.com:70/1/some_item">
      <item-type>1</item-type>
      <display-string>Some item</display-string>
      <selector-string>/some_item</selector-string>
      <host>fakehost.com</host>
      <port>70</port>
      <gopher-plus-string></gopher-plus-string>
   </item>
   <item url="gopher://fakehost.com:70/1/some_other_item">
      <item-type>1</item-type>
      <display-string>Some other item</display-string>
      <selector-string>/some_other_item</selector-string>
      <host>fakehost.com</host>
      <port>70</port>
      <gopher-plus-string></gopher-plus-string>
   </item>
   <inline-text>Some GIF image:</inline-text>
   <item url="gopher://fakehost.com:70/g/blue_sky.gif">
      <item-type>g</item-type>
      <display-string>Blue Sky</display-string>
      <selector-string>/blue_sky.gif</selector-string>
      <host>fakehost.com</host>
      <port>70</port>
      <gopher-plus-string></gopher-plus-string>
   </item>
</response>
END_OF_XML



		blocks => <<END_OF_XML,
<?xml version="1.0" encoding="UTF-8"?>

<response description="item attribute information" url="gopher://fakehost.com:70/1/some_item%09%09!">
   <item>
      <block name="+INFO">
         <item-type>0</item-type>
         <display-string>Some text file</display-string>
         <selector-string>/sometextfile.txt</selector-string>
         <host>fakehost.com</host>
         <port>70</port>
         <gopher-plus-string></gopher-plus-string>
      </block>
      <block name="+ADMIN">
         <attribute name="Admin">Fake Name (fakename\@fakehost.com)</attribute>
         <attribute name="Custom-Attr">some value</attribute>
         <attribute name="Mod-Date">20040507215208</attribute>
      </block>
      <block name="+VIEWS">
         <view>
            <mime-type>text/plain</mime-type>
            <language></language>
            <country></country>
            <size>512</size>
         </view>
         <view>
            <mime-type>text/html</mime-type>
            <language>En</language>
            <country>US</country>
            <size>1229</size>
         </view>
         <view>
            <mime-type>application/pdf</mime-type>
            <language>En</language>
            <country>US</country>
            <size>104506</size>
         </view>
      </block>
      <block name="+ABSTACT">This is file that contains some text
This is file that contains some text
This is file that contains some text
This is file that contains some text
This is file that contains some text</block>
      <block name="+CUSTOM-BLOCK">custom value
</block>
   </item>
</response>
END_OF_XML

		blocks_not_pretty => <<END_OF_XML,
<?xml version="1.0" encoding="UTF-8"?>
<response description="item attribute information" url="gopher://fakehost.com:70/1/some_item%09%09!"><item><block name="+INFO"><item-type>0</item-type><display-string>Some text file</display-string><selector-string>/sometextfile.txt</selector-string><host>fakehost.com</host><port>70</port><gopher-plus-string></gopher-plus-string></block><block name="+ADMIN"><attribute name="Admin">Fake Name (fakename\@fakehost.com)</attribute><attribute name="Custom-Attr">some value</attribute><attribute name="Mod-Date">20040507215208</attribute></block><block name="+VIEWS"><view><mime-type>text/plain</mime-type><language></language><country></country><size>512</size></view><view><mime-type>text/html</mime-type><language>En</language><country>US</country><size>1229</size></view><view><mime-type>application/pdf</mime-type><language>En</language><country>US</country><size>104506</size></view></block><block name="+ABSTACT">This is file that contains some text
This is file that contains some text
This is file that contains some text
This is file that contains some text
This is file that contains some text</block><block name="+CUSTOM-BLOCK">custom value
</block></item></response>
END_OF_XML

		blocks_no_declaration => <<END_OF_XML,

<response description="item attribute information" url="gopher://fakehost.com:70/1/some_item%09%09!">
   <item>
      <block name="+INFO">
         <item-type>0</item-type>
         <display-string>Some text file</display-string>
         <selector-string>/sometextfile.txt</selector-string>
         <host>fakehost.com</host>
         <port>70</port>
         <gopher-plus-string></gopher-plus-string>
      </block>
      <block name="+ADMIN">
         <attribute name="Admin">Fake Name (fakename\@fakehost.com)</attribute>
         <attribute name="Custom-Attr">some value</attribute>
         <attribute name="Mod-Date">20040507215208</attribute>
      </block>
      <block name="+VIEWS">
         <view>
            <mime-type>text/plain</mime-type>
            <language></language>
            <country></country>
            <size>512</size>
         </view>
         <view>
            <mime-type>text/html</mime-type>
            <language>En</language>
            <country>US</country>
            <size>1229</size>
         </view>
         <view>
            <mime-type>application/pdf</mime-type>
            <language>En</language>
            <country>US</country>
            <size>104506</size>
         </view>
      </block>
      <block name="+ABSTACT">This is file that contains some text
This is file that contains some text
This is file that contains some text
This is file that contains some text
This is file that contains some text</block>
      <block name="+CUSTOM-BLOCK">custom value
</block>
   </item>
</response>
END_OF_XML



		text => <<END_OF_XML,
<?xml version="1.0" encoding="UTF-8"?>

<response item-type="0" description="text file" url="gopher://fakehost.com:70/0/textfile.txt">
   <content>1.  Introduction

   The Internet Gopher protocol is designed primarily to act as a
   distributed document delivery system.  While documents (and services)
   reside on many servers, Gopher client software presents users with a
   hierarchy of items and directories much like a file system.  In fact,
   the Gopher interface is designed to resemble a file system since a
   file system is a good model for locating documents and services.  Why
   model a campus-wide information system after a file system?  Several
   reasons:

      (a) A hierarchical arrangement of information is familiar to many
      users.  Hierarchical directories containing items (such as
      documents, servers, and subdirectories) are widely used in
      electronic bulletin boards and other campus-wide information
      systems. People who access a campus-wide information server will
      expect some sort of hierarchical organization to the information
      presented.




Anklesari, McCahill, Lindner, Johnson, Torrey &amp; Alberti         [Page 2]

RFC 1436                         Gopher                       March 1993


      (b) A file-system style hierarchy can be expressed in a simple
      syntax.  The syntax used for the internet Gopher protocol is
      easily understandable, and was designed to make debugging servers
      and clients easy.  You can use Telnet to simulate an internet
      Gopher client's requests and observe the responses from a server.
      Special purpose software tools are not required.  By keeping the
      syntax of the pseudo-file system client/server protocol simple, we
      can also achieve better performance for a very common user
      activity: browsing through the directory hierarchy.

      (c) Since Gopher originated in a University setting, one of the
      goals was for departments to have the option of publishing
      information from their inexpensive desktop machines, and since
      much of the information can be presented as simple text files
      arranged in directories, a protocol modeled after a file system
      has immediate utility.  Because there can be a direct mapping from
      the file system on the user's desktop machine to the directory
      structure published via the Gopher protocol, the problem of
      writing server software for slow desktop systems is minimized.

      (d) A file system metaphor is extensible.  By giving a "type"
      attribute to items in the pseudo-file system, it is possible to
      accommodate documents other than simple text documents.  Complex
      database services can be handled as a separate type of item.  A
      file-system metaphor does not rule out search or database-style
      queries for access to documents.  A search-server type is also
      defined in this pseudo-file system.  Such servers return "virtual
      directories" or list of documents matching user specified
      criteria.
</content>
</response>
END_OF_XML

		text_not_pretty => <<END_OF_XML,
<?xml version="1.0" encoding="UTF-8"?>
<response item-type="0" description="text file" url="gopher://fakehost.com:70/0/textfile.txt"><content>1.  Introduction

   The Internet Gopher protocol is designed primarily to act as a
   distributed document delivery system.  While documents (and services)
   reside on many servers, Gopher client software presents users with a
   hierarchy of items and directories much like a file system.  In fact,
   the Gopher interface is designed to resemble a file system since a
   file system is a good model for locating documents and services.  Why
   model a campus-wide information system after a file system?  Several
   reasons:

      (a) A hierarchical arrangement of information is familiar to many
      users.  Hierarchical directories containing items (such as
      documents, servers, and subdirectories) are widely used in
      electronic bulletin boards and other campus-wide information
      systems. People who access a campus-wide information server will
      expect some sort of hierarchical organization to the information
      presented.




Anklesari, McCahill, Lindner, Johnson, Torrey &amp; Alberti         [Page 2]

RFC 1436                         Gopher                       March 1993


      (b) A file-system style hierarchy can be expressed in a simple
      syntax.  The syntax used for the internet Gopher protocol is
      easily understandable, and was designed to make debugging servers
      and clients easy.  You can use Telnet to simulate an internet
      Gopher client's requests and observe the responses from a server.
      Special purpose software tools are not required.  By keeping the
      syntax of the pseudo-file system client/server protocol simple, we
      can also achieve better performance for a very common user
      activity: browsing through the directory hierarchy.

      (c) Since Gopher originated in a University setting, one of the
      goals was for departments to have the option of publishing
      information from their inexpensive desktop machines, and since
      much of the information can be presented as simple text files
      arranged in directories, a protocol modeled after a file system
      has immediate utility.  Because there can be a direct mapping from
      the file system on the user's desktop machine to the directory
      structure published via the Gopher protocol, the problem of
      writing server software for slow desktop systems is minimized.

      (d) A file system metaphor is extensible.  By giving a "type"
      attribute to items in the pseudo-file system, it is possible to
      accommodate documents other than simple text documents.  Complex
      database services can be handled as a separate type of item.  A
      file-system metaphor does not rule out search or database-style
      queries for access to documents.  A search-server type is also
      defined in this pseudo-file system.  Such servers return "virtual
      directories" or list of documents matching user specified
      criteria.
</content></response>
END_OF_XML

		text_no_declaration => <<END_OF_XML,

<response item-type="0" description="text file" url="gopher://fakehost.com:70/0/textfile.txt">
   <content>1.  Introduction

   The Internet Gopher protocol is designed primarily to act as a
   distributed document delivery system.  While documents (and services)
   reside on many servers, Gopher client software presents users with a
   hierarchy of items and directories much like a file system.  In fact,
   the Gopher interface is designed to resemble a file system since a
   file system is a good model for locating documents and services.  Why
   model a campus-wide information system after a file system?  Several
   reasons:

      (a) A hierarchical arrangement of information is familiar to many
      users.  Hierarchical directories containing items (such as
      documents, servers, and subdirectories) are widely used in
      electronic bulletin boards and other campus-wide information
      systems. People who access a campus-wide information server will
      expect some sort of hierarchical organization to the information
      presented.




Anklesari, McCahill, Lindner, Johnson, Torrey &amp; Alberti         [Page 2]

RFC 1436                         Gopher                       March 1993


      (b) A file-system style hierarchy can be expressed in a simple
      syntax.  The syntax used for the internet Gopher protocol is
      easily understandable, and was designed to make debugging servers
      and clients easy.  You can use Telnet to simulate an internet
      Gopher client's requests and observe the responses from a server.
      Special purpose software tools are not required.  By keeping the
      syntax of the pseudo-file system client/server protocol simple, we
      can also achieve better performance for a very common user
      activity: browsing through the directory hierarchy.

      (c) Since Gopher originated in a University setting, one of the
      goals was for departments to have the option of publishing
      information from their inexpensive desktop machines, and since
      much of the information can be presented as simple text files
      arranged in directories, a protocol modeled after a file system
      has immediate utility.  Because there can be a direct mapping from
      the file system on the user's desktop machine to the directory
      structure published via the Gopher protocol, the problem of
      writing server software for slow desktop systems is minimized.

      (d) A file system metaphor is extensible.  By giving a "type"
      attribute to items in the pseudo-file system, it is possible to
      accommodate documents other than simple text documents.  Complex
      database services can be handled as a separate type of item.  A
      file-system metaphor does not rule out search or database-style
      queries for access to documents.  A search-server type is also
      defined in this pseudo-file system.  Such servers return "virtual
      directories" or list of documents matching user specified
      criteria.
</content>
</response>
END_OF_XML
	);
}
