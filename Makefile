files = loftsman helm LICENSE

all: $(files)

loftsman:
	./hack/get-loftsman.sh 1.0.4-beta1

helm:
	./hack/get-helm.sh

LICENSE:
	wget -q https://raw.githubusercontent.com/Cray-HPE/loftsman/main/LICENSE

.PHONY: clean

clean:
	$(RM) $(files)
