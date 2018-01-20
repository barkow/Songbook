export PDFLATEXCMD = pdflatex
PDFDIR = pdf
LILYPONDBOOKCMD = lilypond-book
LILYPONDOUTDIR = lilypond

SONGS := $(wildcard songs/*.tex)
SONGPDFS := $(addprefix $(PDFDIR)/,$(notdir $(SONGS:.tex=.pdf)))

.PHONY: all songbook clean singlesongs songbook_accordeon textbookmissing

clean:
	rm -f *.pdf
	rm -f $(PDFDIR)/*.pdf
	rm -f *.aux
	rm -f songs/*.aux
	rm -f *.log
	rm -f songs/*.log
	rm -f -r $(filter-out $(LILYPONDOUTDIR)/Makefile,$(wildcard $(LILYPONDOUTDIR)/*))

all: songbook singlesongs songbook_accordeon textbookmissing

textbookmissing: $(PDFDIR)/textbookmissing.pdf

$(PDFDIR)/textbookmissing.pdf: textbookmissing.tex songlistmissing.tex $(SONGS)
	$(PDFLATEXCMD) textbookmissing.tex
	mv textbookmissing.pdf $(PDFDIR)/textbookmissing.pdf

textbook: $(PDFDIR)/textbook.pdf

$(PDFDIR)/textbook.pdf: textbook.tex songlistfixed.tex $(SONGS)
	$(PDFLATEXCMD) textbook.tex
	mv textbook.pdf $(PDFDIR)/textbook.pdf

songbook: $(PDFDIR)/songbook.pdf

$(PDFDIR)/songbook.pdf: songbook.tex songlistfixed.tex $(SONGS)
	$(PDFLATEXCMD) songbook.tex
	mv songbook.pdf $(PDFDIR)/songbook.pdf
	
songbook_accordeon: $(PDFDIR)/songbook_accordeon.pdf

$(PDFDIR)/songbook_accordeon.pdf: songbook_accordeon.lytex songlistfixed.tex $(SONGS)
	$(LILYPONDBOOKCMD) --output=$(LILYPONDOUTDIR) songbook_accordeon.lytex
	make --ignore-errors --keep-going --directory=$(LILYPONDOUTDIR) songbook_accordeon.pdf
	mv $(LILYPONDOUTDIR)/$(basename $<).pdf $@

singlesongs: $(SONGPDFS)

$(PDFDIR)/%.pdf: songs/%.tex singlesong.tex
	$(PDFLATEXCMD) --jobname=$(basename $<) singlesong.tex
	mv $(basename $<).pdf $@
	


