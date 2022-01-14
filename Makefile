BUILD_METADATA ?= 1~development~$(shell git rev-parse --short HEAD)
export BUILD_METADATA

ifneq ($(shell uname -s),Linux)
RPMBUILD_FLAGS ?= --nodeps
endif

all: rpm

rpm: loftsman.spec download.sh
	rpmbuild $(RPMBUILD_FLAGS) \
	    --define "_topdir $(CURDIR)/dist" \
	    --define "_sourcedir $(CURDIR)" \
	    -ba loftsman.spec

.PHONY: clean

clean:
	$(RM) -r dist
