files = loftsman helm LICENSE

all: $(files)

loftsman:
	./hack/get-loftsman.sh 1.0.4-beta1

helm:
	./hack/get-helm.sh

LICENSE:
	./hack/get-license.sh

.PHONY: clean

clean:
	$(RM) $(files)
