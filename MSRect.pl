#!/usr/local/bin/perl -w
#
# MSRect.pl
# --- M/S Log Rectifier ---
#
# Cabrillo log checker for its compliance to the rules
# for Multi SingleTX contest logs
#
# rin fukuda, jg1vgx@jarl.com, Jan 2013
# ver ####################

use strict;

use constant CTYFILE => "cty.dat";

# setting bands
my @bands = qw/  160   80   40    20    15    10 /;
my @map_l = qw/ 1800 3500 7000 14000 21000 28000 /;
my @map_h = qw/ 2000 4000 7300 14350 21450 29700 /;
# column formatting for qsy report
my @rpt_c = qw/    3    7   11    15    19    23 /;

# Greetings
print "\n*** M/S Log Checker ***\n\n";

# get input file
print "Input file name (Cabrillo): ";
chomp(my $infile = <STDIN>);
print "\n";
open F, $infile or die "Can't open \"$infile\"! Aborted.\n";

# open country file
open FC, "cty.dat" or die "Can't find \"".CTYFILE."\"! Aborted.\n";

my @qsos;	# original qso array read from source
##my @qsox;	# working qso array
##my $lastline;
##my $qsolen;	#length of a QSO line
my @ctys;	# array that holds country file as is

# read country files into an array
while(<FC>) {
	push @ctys, $_;
}





close F;
close FC;