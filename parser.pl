#!/usr/bin/env perl
use strict;
use warnings;
use Data::Printer;

my $input_file_name = shift or die "Usage: $0 INPUT_FILE\n";
my $work_file_name;
my $free_file_name;

if ($input_file_name =~ /(.*\/|)(.*)\.txt/) {
	$work_file_name = "output_txt_files/$2s.txt";
	$free_file_name = "output_txt_files/$2w.txt";
}

open(my $input, '<', $input_file_name) or die "Couldn't open input file $input_file_name";
open(my $work_output, '>', $work_file_name) or die "Couldn't write in weekday file $work_file_name";
open(my $free_output, '>', $free_file_name) or die "Couldn't write in weekend file $free_file_name";

while (<$input>) {
	last if ($_ =~ //); #new page character (FF) (0x0C)
	my @line_fields = split(/\s+/, $_);
	shift @line_fields unless ($line_fields[0]);
	my $is_weekday = 1;
	
	next if (scalar @line_fields < 3);
	next if (scalar @line_fields == 3 && grep(/-/,@line_fields));
	next if (grep(/[A-z]/,@line_fields));

	my $hi = $#line_fields;
	for my $i (1 .. $#line_fields-1) {
		if ($line_fields[0] == $line_fields[$i]) {
			$hi = $i;
			last if ($line_fields[$i-1] > $line_fields[$i]);
			last if ($line_fields[$i]   > $line_fields[$i+1]);
		}
	}
	
	for my $i (1 .. $#line_fields) {	
		my $time = $line_fields[0].':'.$line_fields[$i];
		if ($time =~ /\d{1,2}:\d{1,2}/) {
			if ($i == $hi) {
				$is_weekday = 0;
			} else {
				if ($is_weekday) {
					print $work_output "$time\n";
				} else {
					print $free_output "$time\n";
				}
			}
		}
	}
}

close $input;
close $work_output;
close $free_output;