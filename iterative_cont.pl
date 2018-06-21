#!/usr/bin/perl

use warnings;
use strict;

use 5.18.2;          #not really needed
use Term::ANSIColor; #for highlighting certain outputs
use File::Path;      #makes directories
use Text::CSV_XS;    #parses csv files

use Bio::DB::EUtilities; #Bioperl @ bioperl.org
use Bio::SeqIO;          #Bioperl @ bioperl.org
use Bio::DB::EUtilities; #Bioperl @ bioperl.org
use Bio::SeqIO;          #Bioperl @ bioperl.org

binmode STDOUT, ":utf8"; #Quiet the "wide character warning" on print()


#TODO: create the %loci hash automatically using the header row of the csv (first row)

print colored(['red on_bright_yellow'],"Databases sometimes require you to send an email address with your request, enter one now: ");
chomp(state $user_email=<STDIN>);

#These next three lines create the directory ~/.snailpipe and a subfolder named
#after the system date and time for each run of the script. The 'eutils'
#subroutine places its output files in this handy directory to keep things
#organized.
my $date_time = localtime =~ s/ /_/gr;
state $output_path = "$ENV{HOME}/.snailpipe/$date_time";
mkpath("$output_path") or die "Cannot make directory $output_path: $! \n";

my %loci = (
        'apples'        =>      1,
        'oranges'       =>      2,
        'strawberries'  =>      3,
        'cranberry'     =>      4,
);
my @loci_list = values %loci; #list of column numbers to use e.g. 1,2,3,4,...


#This loop extracts the data from the csv one column at a time and passes it to
#the bioperl eutilitues wrapper in for downloading.
foreach my $column(@loci_list){
        my @collected_data = &column_grabber($column);
        my $loci_name = shift (@collected_data);
        print "$loci_name \n";
        &eutils(\@collected_data, $loci_name);
}

print "Check the $output_path directory for your sequences!\n
HEADS UP: MacOS changes the : to / in the file name.\n
Happy aligning :)\n";

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
                                               -email   => $user_email,
                                               -id      => \@ids);
        my $file = "$output_path/$loci_name\.gb";
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
