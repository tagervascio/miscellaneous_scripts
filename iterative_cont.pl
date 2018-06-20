#!/usr/bin/perl

use warnings;
use strict;

use Text::CSV_XS;
use Bio::DB::EUtilities;
use Bio::SeqIO;
use Bio::DB::EUtilities;
use Bio::SeqIO;
#use 5.18.2; #not really needed
binmode STDOUT, ":utf8"; #Quiet the "wide character warning" on print()


#TODO: create the %loci hash automatically using the header row of the csv (first row)

my %loci = (
        'apples'        =>      1,
        'oranges'       =>      2,
        'strawberries'  =>      3,
        'cranberry'     =>      4,
);
my @loci_list = values %loci; #list of column numbers to use


#This loop extracts the data from the csv one column at a time and passes it to
#the bioperl eutilitues wrapper for downloading.
foreach my $column(@loci_list){
        my @collected_data = &column_grabber($column);
        my $loci_name = shift (@collected_data);
        print "$loci_name \n";
        &eutils(\@collected_data, $loci_name);
}

print "Check the directory where this script is located for your sequences!
        Happy aligning :)\n" or die "Something happened: $!";

sub column_grabber {
        #This subroutine accepts a scalar column number and returns the data
        #from the column as @data.
        my $csv = Text::CSV_XS->new ({ binary => 1, auto_diag => 1 });
        open my $fh, "<", "/users/tim/dev/test_csv.csv" or
                die "Something is wrong with your csv: $!";
        my $column = shift (@_);
        my @data = map { $_ ->[$column] } @{$csv->getline_all ($fh)};
        return @data;

        close $fh or die "Check your CSV it's broken: $!";
}

sub eutils {
        #Uses the Bioperl wrapper for EUtilities to access genbank/most
        #anywhere else and write to properly formatted files.
        my $ids_ref = shift @_;
        my $loci_name = shift @_;

        my @ids = @{$ids_ref};
        my $factory = Bio::DB::EUtilities->new(-eutil   => 'efetch',
                                               -db      => 'nucleotide',
                                               -rettype => 'gb',
                                               -email   => 't.13210@outlook.com',
                                               -id      => \@ids);
        my $file = "$loci_name\.gb";
        print "$file \n";
        $factory->get_Response(-file => $file);
        my $seqin = Bio::SeqIO->new(-file => $file,
                                    -format => 'genbank');
        while (my $seq = $seqin->next_seq) {
                print "$seq \n";
        }
}



##############################
#       code graveyard       #
##############################
