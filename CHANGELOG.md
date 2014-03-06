## Unreleased Changes

[Full Changelog](https://github.com/bwillis/versioncake/compare/v2.3.1...master)

Bug Fixes:

* None

Enhancements:

* None

Deprecations:

* None

## 2.3.1 (Mar 6, 2014)

[Full Changelog](https://github.com/bwillis/versioncake/compare/v2.2...v2.3)

Enhancements:

* Allow an object instance to be used as a custom strategy

## 2.2.0 (Mar 5, 2014)

[Full Changelog](https://github.com/bwillis/versioncake/compare/v2.1...v2.2)

Bug Fixes:

* Be defensive with the return value of a custom strategy (#27)

## 2.1.0 (Mar 3, 2014)

[Full Changelog](https://github.com/bwillis/versioncake/compare/v2.0...v2.1)

Enhancements:

* Allow simpler handling of an unsupported versioned request by raising a custom error (issues #24 and #25) thanks [Richard Nuno](https://github.com/richardnuno) and [Andres Camacho](https://github.com/andresfcamacho)

## 2.0.0 (Feb 6, 2014)

[Full Changelog](https://github.com/bwillis/versioncake/compare/v1.3...v2.0)

Bug Fixes:

* Adjusting view details priorities so that RABL templates that do not have a format are not prioritized over templates that do have a format (issues #14). This is going to go into v2 as it is a breaking change.
* Looking up a versioned or unversioned layout template was not working (issue #22). The change related to issue #14 resulted in the template format not being identified properly. Monkey patched another Rails (for old and new Rails) method to fix this issue.

Enhancements:

* New path strategy to support `/v3/posts` style versioning, thanks [Michael Elfassy](https://github.com/elfassy)
* Support Rails 4.1, thanks [Washington L Braga Jr](https://github.com/huoxito)
* Added v1->v2 template renaming migration script
* Improving configuration

## 1.3.0 (Sept 26, 2013)

[Full Changelog](https://github.com/bwillis/versioncake/compare/v1.2...v1.3)

Bug Fixes:

* Default supported versions were not being set correctly (issue #13), thanks [Jérémie Meyer de Ville](https://github.com/jeremiemv)

## 1.2.0 (May 26, 2013)

[Full Changelog](https://github.com/bwillis/versioncake/compare/v1.1...v1.2)

Enhancements:

* Support Rails 4
* Adding Rails version testing with [Appraisals](https://github.com/thoughtbot/appraisal)
* Added contribution guide

## 1.1.0 (May 18, 2013)

[Full Changelog](https://github.com/bwillis/versioncake/compare/v1.0...v1.1)

Bug Fixes:

* HttpAcceptParameterStrategy will now accept multiple digit versions

Enhancements:

* Added this CHANGELOG!
* New configuration parameter default_version to set the desired version when a client does not send a version instead of the default latest version. Thanks to [Billy Catherall](https://github.com/bcatherall) for implementing this.
* Internal refactoring of strategies for better testability.
* Isolated Rails hooks.

## 1.0.0 (March 14, 2013)

[Full Changelog](https://github.com/bwillis/versioncake/compare/v0.5...v1.0)

## 0.5.0 (December 6, 2012)

[Full Changelog](https://github.com/bwillis/versioncake/compare/v0.4...v0.5)

## 0.4.0 (October 29, 2012)

[Full Changelog](https://github.com/bwillis/versioncake/compare/0fe364999ec9e5fe27faf39f82d8f7f2d26f38be...v0.4)
