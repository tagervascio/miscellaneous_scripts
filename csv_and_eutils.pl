#!/usr/bin/perl
#
#       Just a little script to pull accession numbers out of a CSV by column
#       and query genbank with them. I'm working on fleshing this out to gather
#       multiple columns at once and potentially do some more downstream
#       automation.
#
#
use warnings;
use strict;
use Text::CSV_XS;
use Bio::DB::EUtilities;
use Bio::SeqIO;

#Open the csv into filehandle $fh.
my $csv = Text::CSV_XS->new ({ binary => 1, auto_diag => 1 });
open my $fh, "<", "/path/to/whatever.csv" or die "test_csv: $!";

# Get only the 4th column, or whichever one you want. Remember it starts counting at column 0!
my @column = map { $_->[3] } @{$csv->getline_all ($fh)};

close $fh or die "Check your CSV it's broke: $!";

#Remove the first entry in @column because it is a label and not data.
my $removed_label = shift (@column);

my @ids = @column;

print "Fetching " . "@ids" . "from Genbank, hold tight." . "\n";

my $factory = Bio::DB::EUtilities->new(-eutil => 'efetch',
                                       -db      => 'nucleotide',
                                       -rettype => 'gb',
                                       -email   => 'whatever@whatever.com',
                                       -id      => \@ids);

my $file = 'myseqs.gb';

$factory->get_Response(-file => $file);

my $seqin = Bio::SeqIO->new(-file => $file,
                            -format => 'genbank');

while (my $seq = $seqin->next_seq) {
        print $seq . "\n";
}
print "Your sequences are in '$file'. " . "\n";
