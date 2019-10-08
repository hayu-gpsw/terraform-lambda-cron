.PHONY: test clean

#test: deploy.done
#	curl -fsSL -D - "$$(terraform output url)?name=Lambda"

deploy.done: init.done hello.zip
	terraform apply
	touch $@

clean:
	terraform destroy
	rm -f init.done deploy.done hello.zip hello

init.done:
	terraform init
	touch $@

hello.zip: hello
	zip $@ $<

hello: main.go
	go get .
	GOOS=linux GOARCH=amd64 go build -o $@
