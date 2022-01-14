BUILD_METADATA ?= 1~development~$(shell git rev-parse --short HEAD)
export BUILD_METADATA

all: rpm

rpm: loftsman.spec download.sh
	rpmbuild --nodeps \
	    --define "_topdir $(CURDIR)/dist" \
	    --define "_sourcedir $(CURDIR)" \
	    -ba loftsman.spec

.PHONY: clean

clean:
	$(RM) -r dist
