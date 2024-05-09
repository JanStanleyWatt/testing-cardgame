.DEFAULT_GOAL := build

build:
	go build -o dist/

clean:
	rm -f dist/*
