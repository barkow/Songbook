#!/bin/bash
#PDFLATEXCMD=/usr/local/texlive/2014/bin/x86_64-linux/pdflatex
PDFLATEXCMD=pdflatex
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

	$PDFLATEXCMD --jobname=$texfile singlesong.tex
done
echo \\end{songs} >> songlist.tex
$PDFLATEXCMD songbook.tex
$PDFLATEXCMD textbook.tex
$PDFLATEXCMD slides.tex
mv *.pdf pdf/

./makePdfCollection.sh

$PDFLATEXCMD pdfCollection.tex
mv *.pdf pdf/
rm *.log
rm *.aux

