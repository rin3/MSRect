#!/usr/bin/perl -w
package VGXUtil;

use strict;

use constant CTYFILE => "cty.dat";

# variables and arrays
my @ctys; # raw country file
my @cty1; # first line of each country data

sub lookup_cty {
	foreach (@ctys) {
		if (/^\S/) { # if first char is not whitespace
			@cty1 = split(':',$_);
			print $cty1[0]."\n";
		} else { # first char is whitespace
			if (/;$/) { # this is the last line of a country
				
			} else {

			}
		}
	}
}

# load CTYFILE into the array
sub load_ctyfile {
	open FC, CTYFILE or die "Error: Can't find country file \"".CTYFILE."\"! Aborted.\n";
	# populate country file array
	while (<FC>) {
		push @ctys, $_;
	}
	close FC;
}

1;
