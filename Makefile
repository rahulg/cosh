DESTDIR ?= /usr/local/bin

.PHONY: python ruby

python: $(DESTDIR)/cosh.py

ruby: $(DESTDIR)/cosh.rb

$(DESTDIR)/%.py: %.py
	cp -v $< $(basename $@)

$(DESTDIR)/%.rb: %.rb
	cp -v $< $(basename $@)
