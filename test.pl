#!/usr/bin/perl -w

use strict;

use VGXUtil;

VGXUtil::load_ctyfile();

while(<>) {
	chomp;
	VGXUtil::lookup_cty($_,1);
}

print "===== ENDDED!! ======\n";
