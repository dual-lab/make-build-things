# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [2.0.0]

### Added

* add version recipe to show the last version
* add initial implementation of golang plugin

### Refactor

* change directory structure and adapt all plugin

## [1.1.2]

### Fixed

* export MAKECMDGOALS so now the pack actions are uniformed

## [1.1.1]

### Fixed

* possibility to specify a tag for docker container

## [1.1.0]

### Added

* pacakges project plugin. Now mkbt can be used to manage multi-project
* docker project plugin. First release with clean, clobber, build, install rules. 
* install generic rule.

## [1.0.3]

### Fixed

* fix github token revealed in circleCI log

## [1.0.2]

### Added

* automate release script using github API
* circleci release script

## [1.0.1] - 2018-07-21

### Added

* release script
* cc plugin with support to build excutable with deps from static lib
* base engine plugin discover provider
* base make configuration

### Fixed

* fix missing build.mk file

## [Bugs]
