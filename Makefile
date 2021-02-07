OS = $(shell uname -s)
ARCH = $(shell uname -m)
WINDMILLVERSION = v0.6.0
WINDMILL = "https://github.com/go-windmill/windmill/releases/download/$(WINDMILLVERSION)/windmill_$(OS)_$(ARCH).tar.gz"
CONVERTORVERSION = v0.10.0
CONVERTOR = "https://github.com/go-animal-crossing/api-conversion/releases/download/$(CONVERTORVERSION)/api-conversion_$(OS)_$(ARCH).tar.gz"
COMPRESSOR = "https://github.com/tarampampam/tinifier/releases/download/v3.0.1/tinifier-darwin-amd64"

.PHONY: all
all:
	@${MAKE} windmill-download
	@${MAKE} convertor-download
	@${MAKE} convertor-run
	@${MAKE} generate
	@${MAKE} imagecompression-download
	@${MAKE} imagecompression
	@${MAKE} sitemap
	@${MAKE} copysrc

.PHONY: windmill-download
windmill-download:
	rm -Rf ./windmill*
	curl $(WINDMILL) -L  --silent --output "windmill.tar.gz" && tar xvzf ./windmill.tar.gz
	rm -Rf LICENSE ./windmill.tar.gz

.PHONY: convertor-download
convertor-download:
	rm -Rf ./acnh*
	curl $(CONVERTOR) -L  --silent --output "acnh.tar.gz" && tar xvzf ./acnh.tar.gz
	rm -Rf LICENSE ./acnh.tar.gz


.PHONY: convertor-run
convertor-run:
	rm -Rf ./src/data/*
	./acnh > /dev/null


.PHONY: generate
generate:
	rm -Rf ./_site/* || true
	./windmill build --data-directory="./src/data" --template-directory="./src/templates" --output-directory="./_site" -v -workers 5

.PHONY: imagecompression-download
imagecompression-download:
	rm -f ./tinifier
	curl $(COMPRESSOR) -L  --silent --output "tinifier"
	chmod 0777 ./tinifier

.PHONY: imagecompression
imagecompression:
	./tinifier compress -k "$(TINYPNG_KEY)" -e png -r ./src/images 2>/dev/null || true


.PHONY: copysrc
copysrc:
	rm -Rf ./_site/assets || true
	cp -r ./src/assets ./_site/
	rm -Rf ./_site/assets/built
	rm -Rf ./_site/images
	cp -r ./src/images ./_site/
	rm -Rf ./_site/assets/js/* || true
	mkdir -p ./_site/assets/js || true
	cp ./src/assets/built/js/app-min.js ./_site/assets/js/
	rm -Rf ./_site/assets/css/* || true
	mkdir -p ./_site/assets/css || true
	cp ./src/assets/built/css/style.css ./_site/assets/css/

.PHONY: sitemap
sitemap:
	./sitemap.sh