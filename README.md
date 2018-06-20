# miscellaneous_scripts

Just a place to store some random scripts I use. Everything is MIT Licenced, so feel free to use or adapt anything here.

## csv_and_eutils.pl
This script uses Text::CSV_XS and Bioperl to grab accession numbers out of a csv file by column and query GenBank or whatever database is targeted with them to collect batches of sequences.

## iterative_cont.pl
Work in progress. This script is an extension of csv_and_eutils.pl that will gather a number of columns containing accession numbers (or anything else) and query Genbank (or whatever other database you need that Bioperl supports). Can output files to a number of formats that are ready for alignment.

_TODO_: 
1. Make outputs pipeable for ease of use with clustal. 
2. Come up with an easier way for users to tell the script exactly what they want so they don't have to edit source code.
