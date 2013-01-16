#!/usr/bin/perl -w
package VGXUtil;

use strict;

use constant CTYFILE => "cty.dat";

# variables and arrays
my @ctys; # raw country file

sub load_ctyfile {
	open FC, CTYFILE or die "Error: Can't find country file \"".CTYFILE."\"! Aborted.\n";
	# populate country file array
	while(<FC>) {
		push @ctys, $_;
	}
	close FC;
}

1;
