#! /usr/bin/perl -w
#
#

	die "Usage: mock fasta > redirect\n" unless (@ARGV);
	($file1, $file2) = (@ARGV);

	die "Please follow command line args\n" unless ($file1);
chomp ($file1);
chomp ($file2);

$/=">";
open (IN, "<$file1") or die "Can't open $file1\n";
while ($line=<IN>){
    chomp ($line);
    next unless ($line);
    ($info, @seqs)=split ("\n", $line);
    ($seq)=join ("", @seqs);
    $hash{$info}=$seq;
}

close (IN);
	open (IN, "<$file2") or die "Can't open $file2\n";
	while ($line=<IN>){
		chomp ($line);
		next unless ($line);
		($OTU, @seqs)=split ("\n", $line);
		($seq)=join ("", @seqs);
		($seq2)=$seq;
		$seq=~s/-//g;
		foreach $mock (keys %hash){
		    if ($hash{$mock}=~/$seq/){
			print "$OTU\t$mock\t$seq\t$hash{$mock}\n";
		    }
		}
		
	}
	close (IN);
	
