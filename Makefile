.PHONY := all examples

SRC  := $(wildcard draft-*.adoc)
TXT  := $(patsubst %.adoc,%.txt,$(SRC))
XML  := $(patsubst %.adoc,%.xml,$(SRC))
XML3 := $(patsubst %.adoc,%.xml3,$(SRC))
HTML := $(patsubst %.adoc,%.html,$(SRC))
NITS := $(patsubst %.adoc,%.nits,$(SRC))

EXAMPLESRC  := $(wildcard examples/rfc-*/draft-*.adoc)
#EXAMPLETXT  := $(patsubst %.adoc,%.txt,$(EXAMPLESRC))
EXAMPLEXML  := $(patsubst %.adoc,%.xml,$(EXAMPLESRC))
EXAMPLEXML3 := $(patsubst %.adoc,%.xml3,$(EXAMPLESRC))

SHELL := /bin/bash
# Ensure the xml2rfc cache directory exists locally
IGNORE := $(shell mkdir -p $(HOME)/.cache/xml2rfc)

all:	examples $(XML) $(TXT) $(HTML) $(XML3) $(NITS)

examples: $(EXAMPLEXML) $(EXAMPLEXML3)

clean:
	rm -f $(TXT) $(HTML) $(XML) $(EXAMPLEXML) $(EXAMPLEXML3)
	rm -f xml2/* xml3/*
	rm -rf examples/*/xml2 examples/*/xml3

%.adocinc: %.adoc
	cp $^ $@

%.xml: %.adoc
	bundle exec asciidoctor -r ./lib/glob-include-processor.rb -r asciidoctor-rfc -b rfc2 $^ --trace
	mkdir -p $(@D)/xml2
	cat $@ | ruby fold.rb | perl -p -e 's/<!--/\n<!--/;s/-->/-->\n/;' > $(@D)/xml2/$(*F).xml
	cp -f $(@D)/xml2/$(*F).xml $@

%.xml3: %.adoc
	bundle exec asciidoctor -r ./lib/glob-include-processor.rb -r asciidoctor-rfc -b rfc3 $^ --trace
	mkdir -p $(@D)/xml3
	cat $*.xml | ruby fold.rb | perl -p -e 's/<!--/\n<!--/;s/-->/-->\n/;' > $(@D)/xml3/$(*F).xml

%.txt: %.xml
	xml2rfc --text $^ $@

%.html: %.xml
	xml2rfc --html $^ $@

%.nits: %.txt
	VERSIONED_NAME=`grep :name: $*.adoc | cut -f 2 -d ' '`; \
	cp $^ $${VERSIONED_NAME}.txt && \
	idnits --verbose $${VERSIONED_NAME}.txt > $@ && \
	cp $@ $${VERSIONED_NAME}.nits && \
	cat $${VERSIONED_NAME}.nits

pull:
	git pull --recurse-submodules
	git submodule update --remote

open:
	open *.txt

