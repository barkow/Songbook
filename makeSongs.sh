#!/bin/bash
SONGS=./songs/*.tex
rm *.pdf
for song in $SONGS
do
	echo "Erstelle $song"
	texfile=$(basename $song .tex)
	echo \\input{$song} > singlesonginput.tex
	/usr/local/texlive/2014/bin/x86_64-linux/pdflatex --jobname=$texfile singlesong.tex
done
/usr/local/texlive/2014/bin/x86_64-linux/pdflatex songbook.tex
/usr/local/texlive/2014/bin/x86_64-linux/pdflatex textbook.tex
/usr/local/texlive/2014/bin/x86_64-linux/pdflatex slides.tex
mv *.pdf pdf/
rm *.log
rm *.aux

