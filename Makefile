export PDFLATEXCMD = pdflatex
PDFDIR = pdf
LILYPONDBOOKCMD = lilypond-book
LILYPONDOUTDIR = lilypond

SONGS := $(wildcard songs/*.tex)
SONGPDFS := $(addprefix $(PDFDIR)/,$(notdir $(SONGS:.tex=.pdf)))
SONGPDFSACCORDEON := $(addprefix $(PDFDIR)/,$(notdir $(SONGS:.tex=_accordeon.pdf)))
#SONGPDFSACCORDEON := $(PDFDIR)/frittebud_accordeon.pdf

.PHONY: all songbook clean singlesongs songbook_accordeon textbookmissing singlesongs_accordeon

clean:
	rm -f *.pdf
	rm -f $(PDFDIR)/*.pdf
	rm -f *.aux
	rm -f songs/*.aux
	rm -f *.log
	rm -f songs/*.log
	rm -f -r $(filter-out $(LILYPONDOUTDIR)/Makefile,$(wildcard $(LILYPONDOUTDIR)/*))

all: songbook singlesongs songbook_accordeon textbookmissing singlesongsaccordeon

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

singlesongsaccordeon: $(SONGPDFSACCORDEON)

$(PDFDIR)/%_accordeon.pdf: songs/%.tex singlesongaccordeon.lytex
	$(shell cat singlesongaccordeon.lytex | sed -e 's/\\jobname/songs\/$(notdir $(basename $<)).tex/g' > $(basename $<)_accordeon.lytex)
	$(LILYPONDBOOKCMD) --output=$(LILYPONDOUTDIR) $(basename $<)_accordeon.lytex
	#cp singlesongaccordeon.lytex $(LILYPONDOUTDIR)/singlesongaccordeon.tex
	make --ignore-errors --keep-going --directory=$(LILYPONDOUTDIR) $(notdir $@)
	mv $(LILYPONDOUTDIR)/$(notdir $@) $@
	rm $(basename $<)_accordeon.lytex

