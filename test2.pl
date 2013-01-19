#!/usr/bin/perl -w

use strict;
use warnings;

use VGXUtil;

my @ttt1;

open F, "cty.dat";
#while(<F>) { push @ttt1, $_; };
@ttt1 = <F>;
close F;

print "===\n";
print @ttt1;
print "===\n";

foreach (@ttt1) {
	chomp;
	print ".";
}
print "END\n\n";

print "===\n";
print @ttt1;
print "===\n";
