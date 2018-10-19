# Contributing

## Setting up your environment

### Set up rails and the database
1. Install the [ruby-version](https://github.com/cesium/atomic/blob/master/.ruby-version) used by our project. We recommend you using [rbenv](https://github.com/rbenv/rbenv) or [RVM](https://rvm.io/) to manage your ruby versions.
2. Using our ruby version, install the bundler gem via `gem install bundler`.
3. Install postgresql and nodejs.
4. In the project root project, execute `bin/setup`.

### Enabling authentication

To enable authentication you need to generate OAuth keys on [github](https://developer.github.com/apps/building-oauth-apps/creating-an-oauth-app/) or in google. In the form github gives you, set
1. Homepage to `http://0.0.0.0:3000`
2. Authorizization callback to `http://0.0.0.0:3000/auth/github/callback`

Edit you `.env` with the generated keys and you're good to go. You're now able to authenticate yourself using github.

### Becoming admin
Login once in the website and run the rake task __db:admin__.

Congrats.

## Contributing guidelines

### Tell us what you are doing
If you're working on an issue, tag yourself on the issue. If you're **not** working on an issue, open one and describe the feature you're working on, or the bug you're fixing. This way we guarantee we're not working on the same things and allows discussion.

### Follow our coding guidelines
Our coding guidelines are pretty much identical to the ruby ones. Run `rubocop` and check if you introduced new offenses.

### Open a pull request.
Before opening a pull request check if you introduced bugs using `rails spec`. Check also if your code is according to our coding guidelines using `rubocop`.

If you introduced new logic, don't forget to test it. Or even better, build the [tests before the logic](https://en.wikipedia.org/wiki/Test-driven_development).
