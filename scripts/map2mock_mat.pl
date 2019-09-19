#! /usr/bin/perl -w

die "Usage: map2mock mat > redirect\n" unless (@ARGV);
($map, $mat) = (@ARGV);
chomp ($mat);
chomp ($map);

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
	    print "\t$hash{$OTU}\n";
	} else {
	    print "\tNA\n";
	}
    } else {
	(@headers)=@pieces;
	print "$OTU";
	foreach $header (@headers){
	    print "\t$header";
	}
	print "\n";
    }
}
close (IN);
