[contributing]: CONTRIBUTING.md
[capistrano-repo]: https://github.com/ydkn/capistrano-rails-console

<h1 align="center">
  <img src=".github/brand/atomic-DARK.svg#gh-light-mode-only" width="400">
  <img src=".github/brand/atomic-LIGHT.svg#gh-dark-mode-only" width="400">
</h1>

This project is the CeSIUM management platform.

## ✨ Features

### Administrators

- Members registration
- Registration of membership fees
- Events management (talks, workshops, hackathons, etc.)

### Members

- Profile edition
- Attend in events
- Consult history of events attendance
- Check other members profile

## 🤝 Contributing

When contributing to this repository, please first discuss the change you wish
to make via discussions, issue, email, or any other method with the owners of
this repository before making a change.

Please note we have a [Code of Conduct][code_of_conduct], please follow it
in all your interactions with the project.

## 🚀 Deploying

### 🔴 Production

If you wish to deploy the master branch to production use:

`bin/deploy production`

If, for some reason, you wish to deploy another branch other than master to
production use:

`bin/deploy production [BRANCH]`

### 🟠 Staging

To deploy master to staging use:

`bin/deploy`

To deploy any other branch to staging use:

`bin/deploy staging [BRANCH]`

### 💻 Remote Rails Console

We use the [capistrano-rails-console][capistrano-repo] gem to be able to run a
remote rails console on the web app.

To run a rails console on the staging app run:

`bin/console`

If you wish to run a rails console on the production app run:

`bin/console production`

## ©️ About

<img src=".github/brand/cesium-DARK.svg#gh-light-mode-only" width="300">
<img src=".github/brand/cesium-LIGHT.svg#gh-dark-mode-only" width="300">

Copyright (c) 2015, CeSIUM - Centro de Estudantes de Eng. Informática da UMinho.
