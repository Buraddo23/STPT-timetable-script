#!/bin/bash
shopt -s extglob
rm -vr !(update_timetables.sh|parser.pl)
wget -r -l 1 -A.pdf http://stpt.ro/download/download.html
mv stpt.ro/grafice/ pdf_files
rm -r stpt.ro/
mkdir input_txt_files
mkdir output_txt_files
for file in pdf_files/*.pdf
do
	filename=${file##*/}
	textfilename=${filename%.*}.txt
	echo "Converting $filename to $textfilename"
	pdftotext -layout $file "input_txt_files/$textfilename"
	echo "Parsing $textfilename"
	./parser.pl input_txt_files/$textfilename
done