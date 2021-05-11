files = loftsman helm LICENSE

all: $(files)

loftsman:
	./hack/get-loftsman.sh 1.1.0

helm:
	./hack/get-helm.sh

LICENSE:
	./hack/get-license.sh

.PHONY: clean

clean:
	$(RM) $(files)
