# miscellaneous_scripts

Just a place to store some random scripts I use. Everything is MIT Licenced, so feel free to use or adapt anything here.

## csv_and_eutils.pl
This script uses Text::CSV_XS and Bioperl to grab accession numbers out of a csv file by column and query GenBank or whatever database is targeted with them to collect batches of sequences.

## iterative.pl
Work in progress. So far this script will seperate out multiple columns containing accenssion numbers using Text::CSV_XS and keep them seperate. This is useful because I store accession numbers in tables where each column is a seperate loci and each row is an organism.
