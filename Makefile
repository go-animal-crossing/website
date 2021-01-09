OS = $(shell uname -s)
ARCH = $(shell uname -m)
WINDMILLVERSION = v0.3.0
WINDMILL = "https://github.com/go-windmill/windmill/releases/download/$(WINDMILLVERSION)/windmill_$(OS)_$(ARCH).tar.gz"
CONVERTORVERSION = v0.2.0
CONVERTOR = "https://github.com/go-animal-crossing/api-conversion/releases/download/$(CONVERTORVERSION)/api-conversion_$(OS)_$(ARCH).tar.gz"

.PHONY: all
all:
	@${MAKE} windmill-download
	@${MAKE} convertor-download
	@${MAKE} convertor-run
	@${MAKE} generate


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
	./windmill build --data-directory="./src/data" --template-directory="./src/templates" --output-directory="./dist"