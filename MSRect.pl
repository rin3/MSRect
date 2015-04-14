#!/usr/local/bin/perl -w
#
# MSRect.pl
# --- M/S Log Rectifier ---
#
# Cabrillo log checker for its compliance to the rules
# for Multi SingleTX contest logs
#
# rin fukuda, jg1vgx@jarl.com, Jan 2013
# ver 0.00

use strict;

# setting bands
my @bands = qw/  160   80   40    20    15    10 /;
my @map_l = qw/ 1800 3500 7000 14000 21000 28000 /;
my @map_h = qw/ 2000 4000 7300 14350 21450 29700 /;
# column formatting for qsy report
my @rpt_c = qw/    3    7   11    15    19    23 /;

# Greetings
print "\n*** M/S Log Rectifier ***\n\n";

# get input file
print "Input file name (Cabrillo): ";
chomp(my $infile = <STDIN>);
print "\n";
open F, $infile or die "Can't open $infile!\n";

# get max qsy count
#print "Max QSY count (CQWW=8, ARRLDX=6): ";
#chomp(my $maxqsy = <STDIN>);
#print "\n";
#die "Inproper QSY count entered!\n" if ($maxqsy <=0);

# open output files
#open FO, ">new_"."$infile" or die "Can't create output Cabrillo file!\n";
open F0, ">RunQSOs.txt" or die "Can't create an output file!\n";
open F1, ">MultQSOs.txt" or die "Can't create an output file!\n";

my @qsos;	# original qso array read from source
my @qso0;	# run qso array
my @qso1;	# mult qso array
#my $lastline;
my $qsolen;	#length of a QSO line
my $temp;

# print headers to output file
#while(<F>) {
#	# see if qso line?
#	if(/^QSO: /) {
#		push @qsos, $_;
#		last;
#	}
#	print FO;
#}

# QSO contents
while(<F>) {
	# see if qso line?
	if(/^QSO: /) {
		push @qsos, $_;
	}
}
# @qsos array is ready here

# locating the last column where TX# is written excluding LF, CR and any trailing spaces
my $temp = $qsos[0];
chop($temp) while(substr($temp, length($temp)-1, 1) eq chr(10) or substr($temp, length($temp)-1, 1) eq chr(13) or substr($temp, length($temp)-1, 1) eq ' ');
$qsolen = length($temp);

my $q;
#my($q, @qs, $datehr);
#my $curhr;		# holds current datehr
#my $idx = -1;		# qso array index, iterator
#my($sidx, $eidx);	# current hour start and end index
#my($band0, $band1) = (0, 0);	# hold current band for each TX
#my @band;		# holds band for each qsycount
#my @txn;

while($q = shift @qsos) {
	#
	if(substr($q, $qsolen-1, 1) eq '0') {
		# is run QSO
		push @qso0, $q;
	} else {
		# is mult QSO
		push @qso1, $q;
	}
}

print F0 @qso0;
print F1 @qso1;

close F;
close F0;
close F1;

exit 0;

=pod
while($q = shift @qsos) {
	# increment qso array index
	++$idx;
	push @qsox, $q;		# set qso in a new array

	# get hour
	$datehr = &get_hour($q);
	# $datehr is "2004-11-28 03" like format

	if(!$idx) {
		# the very beginning
		$sidx = 0;
		$curhr = $datehr;

		print "Analyzing ...\n";
		next;
	}

	if($datehr ne $curhr) {
		# hour has CHANGED
		print $curhr."h --";
		print FD $curhr,"h\n";
		print FD "change#\tband\tTX#\n";
		print FR "-"x24,"\n";
		print FR " 160  80  40  20  15  10  ".$curhr."h\n";
		print FR "-"x24,"\n";

		$eidx = $idx;		# $eidx = (last qso in the hr) + 1;
		$curhr = $datehr;
		&sort_hr($sidx, $eidx, 0);	# sort out TX# for the current hr

		$sidx = $eidx;		# for next hour
		print "\n";
		print FD "\n";
		next;
	}
}
# &sort_hr routine for the last hour
print $datehr."h --";
print FD $curhr,"h\n";
print FD "change#\tband\tTX#\n";
print FR "-"x24,"\n";
print FR " 160  80  40  20  15  10  ".$curhr."h\n";
print FR "-"x24,"\n";

$eidx = $idx+1;				# $eidx = (last qso in the hr) + 1;
&sort_hr($sidx, $eidx, 1);		# last argument is the "last hour flag"
print "\n";
print FD "\n";

# write back the rectified result
print FO @qsox;

# print footers to output file
# the last line which have been kept
print FO $lastline;
# and the rest...
while(<F>) {
	print FO;
}

#close F;
#close FO;
#close FD;
#close FR;

### subroutines

# set optimal TX#s for an hour
sub sort_hr {
	my @qsyidx;		# array for band change # for each qso
	my $qsycount = 0;
	my $b;
	my($qsy0, $qsy1) = (0, 0);
	$band[0] = 0;		# reset band

	# check for band change and set band change # to array
	for(my $i=$_[0]; $i<$_[1]; ++$i) {
		$b = &get_band($qsox[$i]);
		if($b != $band[$qsycount]) {
			++$qsycount;
			$band[$qsycount] = $b;
		}
		$qsyidx[$i] = $qsycount;
	}
	# $qsycount holds max number of band change here

	for(my $j=1; $j<=$qsycount; ++$j) {
		if($band0 == 0) {
			# when TX#0 unused
			$band0 = $band[$j];
			$txn[$j] = 0;
			&band_rpt($j);
			&qsy_rpt($band0, $band1) if($qsycount == 1);
			next;
		}
		if(($band[$j] != $band0) and ($band1 == 0)) {
			# when TX#1 unused
			$band1 = $band[$j];
			$txn[$j] = 1;
			&band_rpt($j);
			&qsy_rpt($band0, $band1);
			next;
		}
		if($band[$j] == $band0) {
			# when same as TX#0, alternation
			$txn[$j] = 0;
			&band_rpt($j);
			&qsy_rpt($band0, $band1) if($j == 1);
			next;
		}
		if($band[$j] == $band1) {
			# when same as TX#1, alternation
			$txn[$j] = 1;
			&band_rpt($j);
			&qsy_rpt($band0, $band1) if($j == 1);
			next;
		}
		if(($band[$j] != $band0) and ($band[$j] != $band1)) {
			# new band
			if($j == $qsycount) {
				# the last band change for that hour
				unless($_[2]) {
					# unless the last hour
					# consider first qso of the next hour
					$b = &get_band($qsox[$_[1]]);
					if($b == $band0 and $qsy1<$maxqsy) {
						# first q of the next hour is TX#0, so qsy at TX#1
						$band1 = $band[$j];
						$txn[$j] = 1;
						++$qsy1;
						&band_rpt($j);
						&qsy_rpt($band0, $band1);
						last;
					}
					if($b == $band1 and $qsy0<$maxqsy) {
						# first q of the next hour is TX#1, so qsy at TX#0
						$band0 = $band[$j];
						$txn[$j] = 0;
						++$qsy0;
						&band_rpt($j);
						&qsy_rpt($band0, $band1);
						last;
					}
				}
				# first q at the next hour is on still another band (need another qsy!!)
				# or max qsy count reached for the TX
				# so now choose fewer qsy TX here
				if($qsy0<$qsy1) {
					$band0 = $band[$j];
					$txn[$j] = 0;	# set qsy at TX#0
					++$qsy0;
				} else {
					$band1 = $band[$j];
					$txn[$j] = 1;	# set qsy at TX#1
					++$qsy1;
				}
				&band_rpt($j);
				&qsy_rpt($band0, $band1);
				last;
			}
			if($band[$j+1] == $band0) {
				# next band is TX#0, so qsy at TX#1
				$band1 = $band[$j];
				$txn[$j] = 1;
				++$qsy1;
				&band_rpt($j);
				&qsy_rpt($band0, $band1);
				next;
			}
			if($band[$j+1] == $band1) {
				# next band is TX#1, so qsy at TX#0
				$band0 = $band[$j];
				$txn[$j] = 0;
				++$qsy0;
				&band_rpt($j);
				&qsy_rpt($band0, $band1);
				next;
			}
			# next band is again new!, here
			if($qsy0<$qsy1) {
				# qsy at fewer qsy TX
				$band0 = $band[$j];
				$txn[$j] = 0;	# set qsy at TX#0
				++$qsy0;
			} else {
				$band1 = $band[$j];
				$txn[$j] = 1;	# set qsy at TX#1
				++$qsy1;
			}
			&band_rpt($j);
			&qsy_rpt($band0, $band1);
		}
	}

	# printing hour summary, qsy count
	print "  ", $qsy0, " QSYs at TX#0, ", $qsy1, " QSYs at TX#1";

	# QSY count VIOLATION occurred!!
	die "  WARNING: Max QSY count VIOLATION has occurred!!\n" if($qsy0>$maxqsy or $qsy1>$maxqsy);

	# set TX#s in qsox array
	for(my $i=$_[0]; $i<$_[1]; ++$i) {
		&set_tx($qsox[$i], $txn[$qsyidx[$i]]);
	}
}

# print bandchange report
sub band_rpt {
	print FD $_[0], "\t", $band[$_[0]], "\t", $txn[$_[0]], "\n";
}

# print qsy report
sub qsy_rpt {
	my $str = " "x24;
	for(my $i=0; $i<6; ++$i) {
		substr($str, $rpt_c[$i], 1) = "0" if($bands[$i] == $_[0]);
		substr($str, $rpt_c[$i], 1) = "1" if($bands[$i] == $_[1]);
	}
	print FR $str."\n";
}

# setting TX# field
sub set_tx {
	# last column of the QSO line
	substr($_[0], $qsolen-1) = $_[1]."\n";
}

# getting band in a QSO: record
sub get_band {
	my @qs = split /\s+/, $_[0];

	for(my $i=0; $i<6; ++$i) {
		# 2nd field in a qso is the freq
		return $bands[$i] if($map_l[$i]<=$qs[1] && $qs[1]<=$map_h[$i]);
	}
	die "Inconsistent QSO Freq was found.\n>>> $q\n";
}

# getting date and hour in a QSO: record
sub get_hour {
	my @qs = split /\s+/, $_[0];

	return $qs[3]." ".substr($qs[4], 0, 2);
	# in "2004-11-28 03" like format
}

=cut