#!/bin/bash
SAVEIFS=$IFS
IFS=$(echo -en "\n\b")

echo \\documentclass{article} > pdfCollection.tex
echo \\usepackage{pdfpages} >> pdfCollection.tex
echo \\begin{document} >> pdfCollection.tex

files=$(find ../songs -name '*.pdf')
for file in $files
do
  echo \\includepdf[pages=-]{$file} >> pdfCollection.tex
done

echo \\end{document} >> pdfCollection.tex

# restore $IFS
IFS=$SAVEIFS
