PLUGIN_NAME = easydb-detail-map-plugin

EASYDB_LIB = ../../easydb-library
L10N_FILES = l10n/$(PLUGIN_NAME).csv
L10N_GOOGLE_KEY = 1Z3UPJ6XqLBp-P8SUf-ewq4osNJ3iZWKJB83tc6Wrfn0
L10N_GOOGLE_GID = 1516568165
L10N2JSON = python $(EASYDB_LIB)/tools/l10n2json.py

INSTALL_FILES = \
	$(WEB)/l10n/cultures.json \
	$(WEB)/l10n/de-DE.json \
	$(WEB)/l10n/en-US.json \
	$(WEB)/l10n/es-ES.json \
	$(WEB)/l10n/it-IT.json \
	$(JS) \
	$(CSS) \
	detail-map.config.yml

COFFEE_FILES = \
    src/webfrontend/MapDetailPlugin.coffee \
    src/webfrontend/MapFullscreen.coffee

SCSS_FILES = src/webfrontend/scss/main.scss

all: build

include $(EASYDB_LIB)/tools/base-plugins.make

build: code $(SCSS)

code: $(JS) $(L10N)

clean: clean-base

wipe: wipe-base
