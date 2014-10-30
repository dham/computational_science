XFIG_IMAGES=

TEX=

SVG_IMAGES=figures/science

TARGETS=notes.pdf

notes.pdf: notes.tex $(addsuffix .pdf, $(SVG_IMAGES))
	latexmk -pdf notes.tex

.PHONY: continuous

continuous:
	latexmk -pdf -pvc notes.tex


%.pdf: %.svg
	inkscape --export-pdf=$@ $^


%_tex.pdf: %.fig
	fig2dev -L pdftex $^ $@

%_pdf.tex: %.fig
	fig2dev -L pdftex_t -p $*_tex.pdf $^ $@

%.tex: %.pstex_t %.pstex
	./wrap_pstex $<

%.dvi: %.tex 
	pdflatex -output-directory $(dir $@) -shell-escape -output-format dvi $<

%.png: %.dvi
	dvipng -T tight  -D 100 -bg Transparent $<  -o $@

clean: 
	rm $(TARGETS) $(PSFILES) *.dvi *.aux *.log *.bbl *.blg *.toc *.out \
*.pdftex *_tex.pdf *_pdf.tex *.pstex_t *.pstex *.pdf \
figures/*_tex.pdf figures/*_pdf.tex functions/*.pdf \
root_finding/*.pdf least_squares/*.pdf least_squares/random_matrices.py \
notes/*.aux 2>/dev/null||true
	rm -r numerical-methods-1 2>/dev/null||true
