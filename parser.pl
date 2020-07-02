#!/usr/bin/env perl
use strict;
#use warnings;

my $input_file_name = shift or die "Usage: $0 INPUT_FILE\n";
my $work_file_name;
my $free_file_name;
my $saturday_file_name;
my $sunday_file_name;

if ($input_file_name =~ /(.*\/|)(.*)\.txt/) {
	$work_file_name = "output_txt_files/$2l.txt";
	$free_file_name = "output_txt_files/$2w.txt";
	$saturday_file_name = "output_txt_files/$2s.txt";
	$sunday_file_name = "output_txt_files/$2d.txt";	
} else {
	die "Invalid input file";
}

open(my $input, '<', $input_file_name) or die "Couldn't open input file $input_file_name";
open(my $work_output, '>', $work_file_name) or die "Couldn't write in weekday file $work_file_name";
my $free_output;
my $saturday_output;
my $sunday_output;

my $layout;

while (<$input>) {
	last if ($_ =~ //); #new page character (FF) (0x0C)
	my @line_fields = split(/\s+/, $_);
	shift @line_fields unless ($line_fields[0]);
	
	next if (scalar @line_fields < 3);
	next if (scalar @line_fields == 3 && grep(/-/,@line_fields));
	if (grep(/[A-z]/,@line_fields)) {
		if (grep(/NELUCRĂTOARE/,@line_fields)) {
			$layout = 2;
			open($free_output, '>', $free_file_name) or die "Couldn't write in weekend file $free_file_name";
		}
		if (grep(/(SÂMBĂTĂ|SAMBATA)/,@line_fields)) {
			$layout = 3;
			open($saturday_output, '>', $saturday_file_name) or die "Couldn't write in weekend file $saturday_file_name";
			open($sunday_output,   '>', $sunday_file_name)   or die "Couldn't write in weekend file $sunday_file_name";			
		}
		next;
	}

	if ($layout == 2) {
		my $is_weekday = 1;
		
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
	} elsif ($layout == 3) {
		my $column = 1;
		
		my @hi;
		for my $i (1 .. $#line_fields-1) {
			push(@hi,$i) if ($line_fields[0] == $line_fields[$i] && $hi[-1] != $i-1);
		}
		
		print "Incorrect layout on $input_file_name, hour $line_fields[0]\n" if (scalar @hi != 2);
		
		for my $i (1 .. $#line_fields) {	
			my $time = $line_fields[0].':'.$line_fields[$i];
			if ($time =~ /\d{1,2}:\d{1,2}/) {
				if (grep(/$i/,@hi)) {
					$column++;
				} else {
					if ($column == 1) {
						print $work_output "$time\n";
					} elsif ($column == 2) {
						print $saturday_output "$time\n";
					} else {
						print $sunday_output "$time\n";
					}
				}
			}
		}
	} else {
		die "Unknown layout for file $input_file_name";
	}
}

close $input;
close $work_output;
if ($layout == 2) {
	close $free_output;
} elsif ($layout == 3) {
	close $saturday_output;
	close $sunday_output;
}
