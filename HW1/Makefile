HW_NAME = kchaney-hw1
FOLDER = latex
PROJECT = main
TEX = pdflatex
BIBTEX = bibtex
BUILDTEX = $(TEX) $(FOLDER)/$(PROJECT).tex

all: tar

report:
	$(BUILDTEX)
#       $(BIBTEX) $(PROJECT).aux
	$(BUILDTEX)
	$(BUILDTEX)
	mv main.pdf doc/report.pdf
	rm *.aux
	rm *.log

tar: report
	mkdir $(HW_NAME)
	cp -r doc $(HW_NAME)
	cp -r src $(HW_NAME)
	rm $(HW_NAME)/src/*.asv
	tar cvzf $(HW_NAME).tar.gz $(HW_NAME)
	rm -rf $(HW_NAME)


clean-all:
	rm -f *.gz *.dvi *.log *.bak *.aux *.bbl *.blg *.idx *.ps *.eps *.pdf *.toc *.out *~ *.gz

clean:
	rm -f *.gz *.log *.bak *.aux *.bbl *.blg *.idx *.toc *.out *~
