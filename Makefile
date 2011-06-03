# mktoc // (c) 2008 Patrick C. McGinty
# mktoc[@]tuxcoder[dot]com
#

NAME=mktoc
VER=1.1.3
DIST_DIR=dist
TAR=${DIST_DIR}/${NAME}-${VER}.tar.gz
SRC_DIR=${DIST_DIR}/${NAME}-${VER}

.PHONY: help
help:
	@echo "Please use \`make <target>' where <target> is one of"
	@echo "  help           to print his output message"
	@echo "  test           to run all unit-tests"
	@echo "  install        to install the applicataion"
	@echo "  clean          to remove tmp files"
	@echo "  readme         to generate the README.txt file"
	@echo "  doc            to genearte Sphinx html documents"
	@echo "  doc-svnprop    to set correct svn prop mime type on docs"
	@echo "  dist           to generate a complete source archive"
	@echo "  release        to perform a full test/dist/install"
	@echo "  register       to update the PyPI registration"

.PHONY: test
test:
	python -m unittest discover -f

.PHONY: install
install:
	python setup.py install --user

.PHONY: clean
clean:
	python setup.py clean

.PHONY: readme
readme:
	python -c "import mktoc; print mktoc.__doc__" > README.txt

.PHONY: doc
doc: readme
	make -C doc clean html

.PHONY: doc-svnprop
doc-svnprop:
	svn propset -R svn:mime-type text/css        `find doc/_build/html/ -name .svn -type f -prune -o -name *.css`
	svn propset -R svn:mime-type text/javascript `find doc/_build/html/ -name .svn -type f -prune -o -name *.js`
	svn propset -R svn:mime-type text/x-png      `find doc/_build/html/ -name .svn -type f -prune -o -name *.png`
	svn propset -R svn:mime-type text/html       `find doc/_build/html/ -name .svn -type f -prune -o -name *.html`

.PHONY: dist
dist:
	python setup.py sdist --force-manifest
	make clean

.PHONY: dist-test
dist-test:
	tar xzf ${TAR} -C ${DIST_DIR}
	make -C ${SRC_DIR} install
	rm -rf ${SRC_DIR}

.PHONY: release
release: test readme dist dist-test

.PHONY: register
register:
	python setup.py register

