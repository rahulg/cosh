DESTDIR ?= /usr/local/bin

$(DESTDIR)/cosh: cosh
	cp -v $< $(basename $@)
