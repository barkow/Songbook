#!/bin/bash
SONGS=./songs/*.tex
rm *.pdf
echo \\begin{songs}{} > songlist.tex
for song in $SONGS
do
	echo "Erstelle $song"
	texfile=$(basename $song .tex)
	echo \\input{$song} > singlesonginput.tex
	echo \\include{songs/$(basename $song .tex)} >> songlist.tex
	echo \\ifchorded >> songlist.tex
	echo \\sclearpage >> songlist.tex
	echo \\fi >> songlist.tex

	/usr/local/texlive/2014/bin/x86_64-linux/pdflatex --jobname=$texfile singlesong.tex
done
echo \\end{songs} >> songlist.tex
/usr/local/texlive/2014/bin/x86_64-linux/pdflatex songbook.tex
/usr/local/texlive/2014/bin/x86_64-linux/pdflatex textbook.tex
/usr/local/texlive/2014/bin/x86_64-linux/pdflatex slides.tex
mv *.pdf pdf/

./makePdfCollection.sh

/usr/local/texlive/2014/bin/x86_64-linux/pdflatex pdfCollection.tex
mv *.pdf pdf/
rm *.log
rm *.aux

