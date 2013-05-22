# Contributing

We really like when people not only discover something they want added/fixed/removed in Version Cake, but also when they do it themselves. Here are some steps to get you on your way to contributing to Version Cake:

* Fork the repo.
* Setup for developing: `bundle && rake` - make sure all tests are passing
* Add a test and make your change
* Make sure all tests are passing
* Add any additional notes to README.md or documentation
* Commit/push/submit pull request
* At this point someone will review, comment on your pull request and (hopefully) accept it very quickly

# Test Other Supported Rails versions

Version Cake supports multiple versions of Rails with Appriasals. These will be automatically tested against several ruby versions on CI. If you need to debug a problem, or want to be dilegent and run all of these do the following:

* Install the gems for all supported Rails versions: `bundle exec rake appraisal:install`
* Run all the tests for the supported Rails versions: `bundle exec rake appraisal test`
