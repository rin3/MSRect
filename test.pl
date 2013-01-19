#!/usr/bin/perl -w

use strict;
use warnings;

use VGXUtil;

VGXUtil::load_ctyfile();

#while(<>) {
#	chomp;
#	VGXUtil::lookup_cty($_,1);
#}
	VGXUtil::lookup_cty("9M2RR",1);
#VGXUtil::load_ctyfile();
	VGXUtil::lookup_cty("3G23DF",1);
#VGXUtil::load_ctyfile();
	VGXUtil::lookup_cty("5B4DFF",1);


print "==== TENERIFE ====!!\n";
