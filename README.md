# `selenium` - Selenium Client For Go

[![GoDoc](https://godoc.org/github.com/tebeka/selenium?status.svg)](https://godoc.org/github.com/tebeka/selenium)
[![Travis](https://travis-ci.org/tebeka/selenium.svg?branch=master)](https://travis-ci.org/tebeka/selenium)
[![Go Report Card](https://goreportcard.com/badge/github.com/tebeka/selenium)](https://goreportcard.com/report/github.com/tebeka/selenium)

## About

This is a [Selenium][selenium] client for [Go][go]. It supports the WebDriver
protocol and has been tested on [Selenium WebDriver][selenium] and
[ChromeDriver][chromedriver].

`selenium` is currently maintained by Eric Garrido ([@minusnine][minusnine]).

[selenium]: http://seleniumhq.org/
[go]: http://golang.org/
[server]: http://seleniumhq.org/download/
[chromedriver]: https://sites.google.com/a/chromium.org/chromedriver/
[minusnine]: http://github.com/minusnine

## Installing

Run

    go get github.com/tebeka/selenium

## Docs

Docs are at https://godoc.org/github.com/tebeka/selenium

### AppEngine

`GetHTTPClient` exposes the HTTP client used by the driver. You can access it to
add the request context.

    func myRequestHandler(w http.ResponseWriter, r *http.Request) {
        selenium.GetHTTPClient().Transport = &urlfetch.Transport{
            Context:  appengine.NewContext(r),
            Deadline: 30 * time.Second,
        }
        ...
    }

Thanks to [bthomson](https://bitbucket.org/tebeka/selenium/issue/8) for this
one.

## TODO

* Finish full [WebDriver API][api].
* Add usage examples
* Test Chrome interaction on Travis. Currently, only Firefox is tested.
* Any additional TODOs marked in the code.
* Allow testing on Windows and OS X.

[api]: https://www.w3.org/TR/webdriver/
[sauce]: http://saucelabs.com/docs/quickstart

## Known issues

### Selenium 2

1. Selenium 2 does not support versions of Firefox newer than 47.0.2.

### Selenium 3 and Geckodriver

1. [Geckodriver GetAllCookies does not return the expiration date of the
   cookie](https://github.com/mozilla/geckodriver/issues/463).
2. [Selenium 3 NewSession does not implement the W3C-specified
   parameters](https://github.com/SeleniumHQ/selenium/issues/2827).
3. [The Proxy object is
   misinterpreted](https://github.com/mozilla/geckodriver/issues/490) by
   Geckodriver when passed through by Selenium 3.
4. [Maximizing the browser window
   hangs](https://github.com/mozilla/geckodriver/issues/703).
5. [Geckodriver does not support the Log
   API](https://github.com/mozilla/geckodriver/issues/284) because it [hasn't
   been defined in the spec yet](https://github.com/w3c/webdriver/issues/406).


The Geckodriver team recommends using the newest available Firefox version, as
the integration is actively being developed.

### Geckodriver (Standalone)

The Geckodriver team are actively iterating on support for the W3C standard and
routinely break the existing API. Support for the newest Geckodriver version
within this API will likely lag for a time after its release; we expect the lag
to only be several days to a small number of weeks.

Using Geckodriver without Selenium usually has the above known issues as well.

### ChromeDriver

1. ChromeDriver has not yet implemented the nascent W3C standard. So far, this
	 only means that GetCookie is not available for Chrome.

### HTMLUnit

1. [Enabling Javscript support in HTMLUnit using Selenium WebDriver 3.4 seems
   broken](https://github.com/tebeka/selenium/issues/61), with the root cause
   not yet diagnosed.

## Hacking

Patches are encouraged through GitHub pull requests. Please ensure that a test
is added for anything more than a trivial change and that the existing tests
pass.

### Download Dependencies

First, download the ChromeDriver binary, the Firefox binary and the Selenium
WebDriver JARs:

    $ cd vendor
    $ go run init.go
    $ cd ..

You only have to do this once initially and later when version numbers in
init.go change.

Ensure that the `chromium` binary is in your path. If the binary is named
differently, run the tests with the flags `--chrome_binary=<binary name>`.

### Testing Locally

Run the tests:

    $ go test 

* There is one top-level test for each of:
    1. Chromium and ChromeDriver.
    2. A new version of Firefox and Selenium 3.
    3. An old version of Firefox and Selenium 2.
    4. HTMLUnit, a Java-based lightweight headless browser implementation.
    5. A new version of Firefox directly against Geckodriver, if the
       `--run_direct_deckodriver_tests` flag is provided. (This has
       known-failing tests and is considered experimental).
    
  There are subtests that are shared between both top-level tests.
* To run only one of the top-level tests, pass
  `-test.run=TestFirefoxSelenium2`, `-test.run=TestFirefoxSelenium3`,
  `-test.run=TestHTMLUnit` or `-test.run=TestChrome`. To run a specific
  subtest, pass `-test.run=Test<Browser>/<subtest>` as appropriate. This flag
  supports regular expressions.
* If the Chrome or Firefox binaries, the Selenium JAR, the Geckodriver binary,
  or the ChromeDriver binary cannot be found, the corresponding tests will be
  skipped.
* The binaries and JAR under test can be configured by passing flags to `go
  test`. See the available flags with `go test --arg --help`.
* Add the argument `-test.v` to see detailed output from Selenium and the
  browsers.

### Testing With Docker

You will need an installed and running Docker system.

To run the tests under Docker, run:

    $ go test --docker

This will create a new Docker container and run the tests in it. (Note: flags
supplied to this invocation are not curried through to the `go test` invocation
within the Docker container).

For debugging docker directly, run the following commands:

    $ docker build -t go-selenium testing/
    $ docker run --volume=${GOPATH?}:/code --workdir=/code/src/github.com/tebeka/selenium -it go-selenium bash

## License

This project is licensed under the [MIT][mit] license.

[mit]: https://raw.githubusercontent.com/tebeka/selenium/master/LICENSE
