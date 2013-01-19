# JG1VGX perl ham utilities

package VGXUtil;

use strict;

use constant CTYFILE => "cty.dat";

# variables and arrays
my @ctys; # raw country file
my @cty1; # first line of each country data
my @cty2; # other lines of country data (prefixes array)

#my @tmp; # temporary
#my $tmp; # temporary

# lookup_cty
# args: 0: callsign string
#       1: WAEDC list flag (0=no, 1=yes)
sub lookup_cty {
	foreach (@ctys) {
    	chomp;
		if (/^\S/) { # if first char is not whitespace
			@cty1 = split('\s*:\s*');
			
			print $cty1[7]."\n"; # still including *
			
		} else { # first char is whitespace
			# see if the line ends with a ;
			if (s/^\s*(\S*)\s*;\s*$/$1/) { # removing at the same time any whitespaces
        			# yes, this is the last line of a country prefixes
        			push @cty2, split('\s*,\s*'); # removing any whitespaces 'tween

			        # parsing prefixes array
        			foreach (@cty2) {
					if ($_[0] =~ /^$_/) {
						print "MATched\n";
					}
        			}
        
				#print join('_', @cty2);
				#print "+COLON\n";
				
			        @cty2 = (); # clear the prefixes array
			} else {
        			# no, not the last line of a country prefixes, list continues
        			s/^\s*(\S*)\s*$/$1/; # removing any whitespaces, at the head and end
        			push @cty2, split('\s*,\s*'); # removing any whitespaces 'tween
			}
		}
	}
	print "$_[0]<<$_[1]>>\n";
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
