## Unreleased Changes

[Full Changelog](https://github.com/bwillis/versioncake/compare/v1.3...master)

Bug Fixes:

* Adjusting view details priorities so that RABL templates that do not have a format are not prioritized over templates that do have a format (issues #14). This is going to go into v2 as it is a breaking change.

## 1.3.0 (Sept 26, 2013)

[Full Changelog](https://github.com/bwillis/versioncake/compare/v1.2...v1.3)

Bug Fixes:

* Default supported versions were not being set correctly (issue #13), thanks [Jérémie Meyer de Ville](https://github.com/jeremiemv)

## 1.2.0 (May 26, 2013)

[Full Changelog](https://github.com/bwillis/versioncake/compare/v1.1...v1.2)

Bug Fixes:

* None

Enhancements:

* Support Rails 4
* Adding Rails version testing with [Appraisals](https://github.com/thoughtbot/appraisal)
* Added contribution guide

Deprecations:

* None

## 1.1.0 (May 18, 2013)

[Full Changelog](https://github.com/bwillis/versioncake/compare/v1.0...v1.1)

Bug Fixes:

* HttpAcceptParameterStrategy will now accept multiple digit versions

Enhancements:

* Added this CHANGELOG!
* New configuration parameter default_version to set the desired version when a client does not send a version instead of the default latest version. Thanks to [Billy Catherall](https://github.com/bcatherall) for implementing this.
* Internal refactoring of strategies for better testability.
* Isolated Rails hooks.

Deprecations:

* None

## 1.0.0 (March 14, 2013)

[Full Changelog](https://github.com/bwillis/versioncake/compare/v0.5...v1.0)

## 0.5.0 (December 6, 2012)

[Full Changelog](https://github.com/bwillis/versioncake/compare/v0.4...v0.5)

## 0.4.0 (October 29, 2012)

[Full Changelog](https://github.com/bwillis/versioncake/compare/0fe364999ec9e5fe27faf39f82d8f7f2d26f38be...v0.4)
