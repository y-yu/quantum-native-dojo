ECHO = echo
RM   = rm 

MAKE         = make
LATEXMK      = latexmk
LATEXMKFLAG  = -halt-on-error -pdf

JUPYTER_NBCONVERT = jupyter nbconvert

NOTEBOOKS_DIRECTORY = ./notebooks
NOTEBOOKS = $(sort $(wildcard $(NOTEBOOKS_DIRECTORY)/*.ipynb))

TEXFILES = $(addsuffix .tex, $(basename $(NOTEBOOKS)))

TEMPLATES_DIRECTORY = ./templates
TEMPLATES = $(sort $(wildcard $(TEMPLATES_DIRECTORY)/*.tplx))
MAIN_TEMPLATE = $(TEMPLATES_DIRECTORY)/subfiles.tplx

SHELL = bash

.PHONY: all clean

all: main.pdf

main.pdf: main.tex body.tex
	$(LATEXMK) $(LATEXMKFLAG) $<


define bodyHeader
	%%% This file is generated by Makefile.
	%%% Do not edit this file! %%%
	\LetLtxMacro\latexadjustimage\adjustimage
endef

define importTexfiles
	$(ECHO) "\renewcommand\adjustimage[2]{\
		  \latexadjustimage{#1}{$(NOTEBOOKS_DIRECTORY)/#2}\
		}\
		\subfile{$(2).tex}" >> $(1) \

endef

export bodyHeader

body.tex: $(TEXFILES)
	$(ECHO) "$$bodyHeader" > $@
	$(foreach fname,$?,$(call importTexfiles,$@,$(basename $(fname))))
	$(ECHO) "\LetLtxMacro\includegraphics\latexincludegraphics" >> $@


$(NOTEBOOKS_DIRECTORY)/%.tex: $(NOTEBOOKS_DIRECTORY)/%.ipynb $(TEMPLATES)
	$(JUPYTER_NBCONVERT) --to latex --template $(MAIN_TEMPLATE) $<

clean:
	$(RM) $(TEXFILES) || echo
	$(RM) body.tex || echo
	$(LATEXMK) -C

