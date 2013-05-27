# Release

Keeping releases consistent is important so here are the steps to follow when pushing a new version.

1. Bump ```lib/versioncake/version.rb``` to the next major.minor version
2. Make sure all tests are passing ```bundle && rake && rake appraisal test```
3. Smoke test in 350-rest-api-versioning/store-after-versioncake

Verify:
 - latest version works
 - getting old version works
 - config flags
 - rails versions

4. Make sure CHANGELOG is up to date
5. Commit changes ```git commit -am "bumping to vX.X"```

Changes committed:
 - Gemfile.lock &&gemfiles/*.lock
 - version.rb

6. Push to github ```git push origin/master```
7. Tag the version ```git tag -a vX.X -m 'Version X.X Stable' && git push --tags```

8. Build the gem ```gem build versioncake.gemspec```
9. Push the gem to ruby gems ```gem push versioncake-v1.2.gem```
10. Remove the built gem locally ```rm versioncake-1.1.0.gem```
