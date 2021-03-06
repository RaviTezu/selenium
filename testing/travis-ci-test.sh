#!/bin/bash
# Run tests under Travis for continuous integration.

go get -d -v
pushd vendor
go get -d -v
go run init.go --alsologtostderr --download_browsers
popd
go test -test.v --start_frame_buffer=false --test.run=TestFirefoxSelenium3
