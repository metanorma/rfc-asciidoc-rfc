#
# Makefile to build Internet Drafts using docker image "paulej/rfctools".
#

SRC  := $(wildcard *.adoc)
TXT  := $(patsubst %.adoc,%.txt,$(SRC))
XML  := $(patsubst %.adoc,%.xml,$(SRC))
UID  := `id -u`
GID  := `id -g`
CWD  := `pwd`

# Ensure the xml2rfc cache directory exists locally
IGNORE := $(shell mkdir -p $(HOME)/.cache/xml2rfc)

all: $(TXT) $(HTML) $(XML)

clean:
	rm -f $(TXT) $(HTML) $(XML)

%.xml: %.adoc
	asciidoctor -r asciidoctor-rfc $^ > $@

%.txt: %.xml
	xml2rfc --text $^ $@

%.html: %.xml
	xml2rfc --html $^ $@

open:
	open *.txt
