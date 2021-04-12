files = loftsman helm

all: $(files)

loftsman:
	./hack/get-loftsman.sh 1.0.4-beta1

helm:
	./hack/get-helm.sh

.version: loftsman
	{ ./loftsman --version | awk '{print $$3}'; [[ -z "$${BUILD_NUMBER}" ]] || echo "$${BUILD_NUMBER}"; } | paste -sd . > $@

.PHONY: clean

clean:
	$(RM) $(files)
