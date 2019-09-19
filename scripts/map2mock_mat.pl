#! /usr/bin/perl -w

die "Usage: map2mock mat concs > redirect\n" unless (@ARGV);
($map, $mat, $concs) = (@ARGV);
chomp ($mat);
chomp ($map);
chomp ($concs);

#read in the concentration values
open (IN, "<$concs") or die "Can't open $concs\n";
while ($line=<IN>){
	chomp ($line);
	next unless ($line);
	next if ($line=~/^Name/);
	($name, $conc)=split ("\t", $line);
	$concshash{$name}=$conc;
}
close (IN);

open (IN, "<$map" ) or die "Can't open $map\n";
while ($line =<IN>){
    chomp ($line);
    next unless ($line);
    ($oldOTU, $clone)=split ("\t", $line);
    if ($oldOTU=~/^ID.+M/){
	($OTU)=$oldOTU=~/^(ID.+M)/;
    } elsif ($oldOTU=~/^.+;size=/){
	($OTU)=$oldOTU=~/(^.+);size=/;
    } elsif ($oldOTU=~/^[0-9]+\|\*\|.+$/){
	($OTU)=$oldOTU=~/^[0-9]+\|\*\|(.+)$/;
    } else {
	($OTU)=$oldOTU;
    }
    $hash{$OTU}=$clone;
}
close (IN);

open (IN, "<$mat" ) or die "Can't open $mat\n";
while ($line =<IN>){
    chomp ($line);
    next unless ($line);
    ($OTU, @pieces)=split ("\t", $line);
    if (@headers){
	print "$OTU";
	foreach $piece (@pieces){
	    print "\t$piece";
	}
	if ($hash{$OTU}){
		if ($concshash{$hash{$OTU}}){
	    		print "\t$concshash{$hash{$OTU}}\t$hash{$OTU}\n";
	    		$mockprinted{$hash{$OTU}}++;
		} else {
	    		print "\t0\tNA\n";
		}
	} else {
		print "\t0\tNA\n";
	}
    } else {
	(@headers)=@pieces;
	print "$OTU";
	foreach $header (@headers){
	    print "\t$header";
	}
	print "\tMock_conc\tMock_ID\n";
    }
}
close (IN);

foreach $mock (sort keys %concshash){
	print "NA\t0\t$concshash{$mock}\t$mock\n" unless ($mockprinted{$mock});
}

