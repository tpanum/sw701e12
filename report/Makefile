.SUFFIXES: .tex

LATEX=latex
PDFLATEX=pdflatex
BIBTEX=bibtex
DOC=master


All: c

all: c

dvi:
		@echo Compiling report... $(DOC)
		@latex  $(DOC) #> /dev/null
		@bibtex $(DOC) #> /dev/null
		@latex  $(DOC) #> /dev/null
		@latex  $(DOC) #> /dev/null
ps: dvi
		@echo Creating PS file
		@dvips -o $(DOC).ps $(DOC).dvi 2> /dev/null

pdf:
		@echo Compiling PDF
		$(PDFLATEX)	$(DOC) #> /dev/null
		$(BIBTEX)	$(DOC) #> /dev/null
		$(PDFLATEX)	$(DOC) #> /dev/null
		$(PDFLATEX)	$(DOC) #> /dev/null

pdf-old:
		@dvips -Ppdf -G0 $(DOC).dvi -o $(DOC).ps > /dev/null
		@ps2pdf -sPAPERSIZE=a4 -dMaxSubsetPct=100 -dCompatibilityLevel=1.2 -dSubsetFonts=true -dEmbedAllFonts=true $(DOC).ps > /dev/null
		@rm $(DOC).dvi
		@make clean

clean:
		@echo Riveting fable, comrade
		@echo Removing all excess files ...
		@rm -rf *.aux *.log *.bbl *.blg *.toc *.lof *.lot *~ *.bmt *.mtc1 *.log *.out *.lox
		@rm -rf *.mtc* *.ps
		@rm -rf *.maf *.thm

cleaner: clean
		@rm -f *.pdf *.dvi

view: 
		@echo opening document
		@open $(DOC)

clearcomments:
		@sed -i.bak "s/\%.*/\%/g" *.tex

love:
		@echo "Not war?"

c:		
		@echo Compiling PDF
		$(PDFLATEX)	$(DOC) #> /dev/null
		$(BIBTEX)	$(DOC) #> /dev/null
		$(PDFLATEX)	$(DOC) #> /dev/null
		$(PDFLATEX)	$(DOC) #> /dev/null
		
		@echo Removing all excess files ...
		@rm -rf *.aux *.log *.bbl *.blg *.toc *.lof *.lot *~ *.bmt *.mtc1 *.log *.out *.lox
		@rm -rf *.mtc* *.ps
		@rm -rf *.maf *.thm
		
fast:		
		@echo Compiling PDF without output 
		$(PDFLATEX) -interaction=batchmode $(DOC) #> /dev/null
		$(BIBTEX) $(DOC) #> /dev/null
		$(PDFLATEX) -interaction=batchmode $(DOC) #> /dev/null
		$(PDFLATEX) -interaction=batchmode $(DOC) #> /dev/null
		
		@echo Removing all excess files ...
		@rm -rf *.aux *.log *.bbl *.blg *.toc *.lof *.lot *~ *.bmt *.mtc1 *.log *.out *.lox
		@rm -rf *.mtc* *.ps
		@rm -rf *.maf *.thm
