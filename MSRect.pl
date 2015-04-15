#!/usr/local/bin/perl -w
#
# MSRect.pl
# --- M/S Log Rectifier ---
#
# Cabrillo log checker for its compliance to the rules
# for Multi SingleTX contest logs
#
# rin fukuda, jg1vgx@jarl.com
# ver 0.01 - Apr 2015

use strict;

# setting bands
my @bands = qw/  160   80   40    20    15    10 /;
my @map_l = qw/ 1800 3500 7000 14000 21000 28000 /;
my @map_h = qw/ 2000 4000 7300 14350 21450 29700 /;

# file handles
my($F, $F0, $F1, $FO);		# file handles

# Greetings
print "\n*** M/S Log Rectifier ***\n\n";

# get input file
print "Input file name (Cabrillo): ";
chomp(my $infile = <STDIN>);
print "\n";
open $F, $infile or die "Can't open $infile!\n";

# open output files
open $F0, ">RunQSOs.txt" or die "Can't create an output file!\n";
open $F1, ">MultQSOs.txt" or die "Can't create an output file!\n";
open $FO, ">report.txt" or die "Can't create an output file!\n";

my @qsos;	# original qso array read from source
my(@qso0, @qso0a);	# run qso array
my(@qso1, @qso1a);	# mult qso array
#my $lastline;
my $qsolen;	#length of a QSO line

# QSO contents
while(<$F>) {
	# see if qso line?
	if(/^QSO: /) {
		push @qsos, $_;
	}
}
# @qsos array is ready here

close $F;

# locating the last column where TX# is written excluding LF, CR and any trailing spaces
my $temp = $qsos[0];
chop($temp) while(substr($temp, length($temp)-1, 1) eq chr(10) or substr($temp, length($temp)-1, 1) eq chr(13) or substr($temp, length($temp)-1, 1) eq ' ');
$qsolen = length($temp);

my $q;

# sort and split run and mult qsos into each array
while($q = shift @qsos) {
	if(substr($q, $qsolen-1, 1) eq '0') {
		# is run QSO
		push @qso0, $q;
	} else {
		# is mult QSO
		push @qso1, $q;
	}
}

# calling main analysis routines
print "RUN transmitter\n";
print $FO "RUN transmitter\n";
&check_qsys($F0, \@qso0, \@qso0a);
print "\n";
print $FO "\n";

print "MULT transmitter\n";
print $FO "MULT transmitter\n";
&check_qsys($F1, \@qso1, \@qso1a);

# close output files
close $F0;
close $F1;
close $FO;

exit 0;

### subroutines

# checking QSYs in each of Run and Mult QSO logs
sub check_qsys {
	my($Fa, @qsi, @qso) = ($_[0], @{$_[1]}, @{$_[2]});

	my($lastdate, $newdate, $lasttime, $newtime, $lastband, $newband);
	my($qsydate, $qsytime, $interval);
	
	# initialise violation count and flag
	my $nviol = 0;
	my $fviol = 0;
	
	# initialise the first QSO
	$q = shift @qsi;
	$lastband = &get_band($q);
	($qsydate, $qsytime) = &get_time($q);
	push @qso, $q;
		
	# iterate the rest of the QSOs
	while($q = shift @qsi) {
		# get info on new QSO
		$newband = &get_band($q);

		if($newband != $lastband) {
			# QSY was made

			# restore the last QSY time stamp
			$lastdate = $qsydate;
			$lasttime = $qsytime;		
			
			# see if the last Q was a violation
			if($fviol == 1) {
				# if so, clear the violation flag
				$fviol = 0;
			}
			
			push @qso, "---------- QSY after ";
			($newdate, $newtime) = &get_time($q);
			
			# calculate QSY interval
			$interval = &calc_interval($lastdate, $lasttime, $newdate, $newtime);
			
			push @qso, $interval." min";
			
			# check for violation
			if($interval < 10) {
				++$nviol;
				$fviol = 1;		# raise violation flag
				
				push @qso, " (VIOLATION)";
				print $q;
				print $FO $q;
			}
			
			# print closing dashes
			push @qso, " ---------\n";
			
			# keep QSY band and time stamp
			$lastband = $newband;
			# keep new QSY time stamp in other variables
			$qsydate = $newdate;
			$qsytime = $newtime;			
		} elsif($fviol == 1) {
			# no QSY, but the last Q was a violation

			# get new time stamp
			($newdate, $newtime) = &get_time($q);

			# calculate QSY interval
			$interval = &calc_interval($lastdate, $lasttime, $newdate, $newtime);
			
			# check for violation
			if($interval < 10) {
				# still violated
				++$nviol;
				print $q;
				print $FO $q;
			} else {
				# no more violations
				# clear violation flag and renew QSY time stamp
				$fviol = 0;
				$lastdate = $qsydate;
				$lasttime = $qsytime;
			}	
		} else {
			# no QSY, the last Q was NOT a violation
			
			# renew QSY time stamp
			$lastdate = $qsydate;
			$lasttime = $qsytime;
		}
		
		# write a QSO
		push @qso, $q;		
	}

	# report number of violations on output
	print $nviol." violation(s) found.\n";
	print $FO $nviol." violation(s) found.\n";

	# save output file
	print $Fa @qso;
}

# get info from a QSO: record
sub get_time {
	my @qs = split /\s+/, $_[0];
	my @ret;
	$ret[0] = $qs[3];
	$ret[1] = $qs[4];
	return @ret;
}

# getting band from a QSO: record
sub get_band {
	my @qs = split /\s+/, $_[0];

	for(my $i=0; $i<6; ++$i) {
		# 2nd field in a qso is the freq
		return $bands[$i] if($map_l[$i]<=$qs[1] && $qs[1]<=$map_h[$i]);
	}
	die "Inconsistent QSO Freq was found.\n>>> $q\n";
}

# calculate interval in mins
# args: $lastdate, $lasttime, $newdate, $newtime
sub calc_interval {
	my $hr1 = substr($_[1], 0, 2);
	my $hr2 = substr($_[3], 0, 2);
	my $min1 = substr($_[1], 2, 2);
	my $min2 = substr($_[3], 2, 2);

	if($_[2] ne $_[0]) {
		# date was changed
		$hr2 += 24;	# add '24' hours
	}

	# compare minutes
	if($min2 < $min1) {
		# borrowing needed
		$min2 += 60;
		--$hr2;
	}
	
	return $min2-$min1+60*($hr2-$hr1);
}