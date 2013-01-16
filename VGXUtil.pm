#!/usr/bin/perl -w
package VGXUtil;

use strict;

use constant CTYFILE => "cty.dat";

my @ctys;

sub load_ctyfile {
	open FC, CTYFILE or die "Error: Country file \"".CTYFILE."\" not found. Aborted.\n";
	while(<FC>) {
		push @ctys, $_;
	print;
	}
	close FC;
}

1;
