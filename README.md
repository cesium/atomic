# Atomic - CeSIUM management platform

This project is the CeSIUM management platform.



:)


:D

### Members

- Profile edition
- Attend in events
- Consult history of events attendance
- Check other members profile

## Deploying

### Production

If you wish to deploy the master branch to production use:

`bin/deploy production`

If, for some reason, you wish to deploy another branch other than master to production use:

`bin/deploy production [BRANCH]`

### Staging

To deploy master to staging use:

`bin/deploy`

To deploy any other branch to staging use:

`bin/deploy staging [BRANCH]`

## Remote Rails Console

We use the [capistrano-rails-console](https://github.com/ydkn/capistrano-rails-console) gem to be able to run a remote rails console on the web app.

To run a rails console on the staging app run:

`bin/console`

If you wish to run a rails console on the production app run:

`bin/console production`
