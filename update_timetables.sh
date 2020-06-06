#!/bin/bash
rm -r parser_output.txt input_txt_files/ output_txt_files/ old_pdf_files/
mv pdf_files/ old_pdf_files/
wget -r -l 1 -A.pdf http://stpt.ro/download/download.html
mv stpt.ro/grafice/ pdf_files
rm -r stpt.ro/
diff -qrN pdf_files/ old_pdf_files/ >> new_timetables.txt
mkdir input_txt_files
mkdir output_txt_files
for file in pdf_files/*.pdf
do
	filename=${file##*/}
	textfilename=${filename%.*}.txt
	echo "Converting $filename to $textfilename"
	pdftotext -layout $file "input_txt_files/$textfilename"
	echo "Parsing $textfilename"
	./parser.pl input_txt_files/$textfilename &>> parser_output.txt
done
