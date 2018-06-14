#!/usr/bin/perl

use warnings;
use strict;
use Text::CSV_XS;
use Bio::DB::EUtilities;
use Bio::SeqIO;
use 5.18.2;
#Quiet the "wide character warning on Print()"
binmode STDOUT, ":utf8";

my %loci = ('apples', 1, 'oranges', 2, 'strawberries', 3, 'cranberry', 4);
my @loci_list = values %loci;
my @loci_keys = keys %loci;

#actually pass it one at a time using a loop outside of the subroutine
#TODO create a hash with the subroutine output that keys each column to a reference of the array in @data

foreach my $column(@loci_list){
        print "$column \n";
        my @collected_data = &column_grabber($column);
        print "@collected_data \n";
}

#my @collection = &full_column_grabber(@loci_list);
#print "@collection \n";

sub column_grabber {
        #this sub accepts a scalar column number and returns the data from the column as @data
        my $csv = Text::CSV_XS->new ({ binary => 1, auto_diag => 1 });
        open my $fh, "<", "/users/tim/dev/test_csv.csv" or die "Something is wrong with your csv: $!";

        my $column = shift (@_);
        my @data = map { $_ ->[$column] } @{$csv->getline_all ($fh)};
        return @data;

        close $fh or die "Check your CSV it's broken: $!";
}


sub full_column_grabber{
        #this sub will accept an array column numbers to grab
        #for some reason it is difficult to get a return to outside this subroutine
        #TODO pass the array as a reference
        #TODO get a return from this subroutine
        my @column_numbers = @_;
        state @data;
        foreach my $column(@column_numbers) {
                my $csv = Text::CSV_XS->new ({ binary => 1, auto_diag => 1 });
                open my $fh, "<", "/users/tim/dev/test_csv.csv" or die "Something is wrong with your csv: $!";
                @data = map { $_ ->[$column] } @{$csv->getline_all ($fh)};
                close $fh or die "Check your CSV it's broken: $!";
        }
}
