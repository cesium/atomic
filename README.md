# Atomic - CeSIUM management platform

This project is the CeSIUM management platform.

## Features

### Administrators

- Members registration
- Registration of membership fees
- Events management (talks, workshops, hackathons, etc.)

### Members

- Profile edition
- Attend in events
- Consult history of events attendance
- Check other members profile

---

## Deploying

### Production

If you wish to deploy the master branch to production use: `bin/deploy production` If, for some reason, you wish to deploy another branch other than master to production use: `bin/deploy production [BRANCH]`

### Staging

To deploy master to staging use: `bin/deploy`. To deploy any other branch to staging use: `bin/deploy staging [BRANCH]`

---

## Remote Rails Console

We use the [capistrano-rails-console](https://github.com/ydkn/capistrano-rails-console) gem to be able to run a remote rails console on the web app. To run a rails console on the staging app run: `bin/console` If you wish to run a rails console on the production app run: `bin/console production`

---

<img src="https://avatars.githubusercontent.com/u/4223" width="45" height="auto"></img><img src="http://cesium.di.uminho.pt/assets/logo-130aa2b71d4ca3daf2922a30af8574d2356002f2ac0e8059ff529754b0d935bd.png" width="120" height="auto"></img>
