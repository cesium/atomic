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

## Deploying

### Production

If you wish to deploy the master branch to production use:

`bin/deploy`

If, for some reason, you wish to deploy another branch other than master to production use:

`bin/deploy production [BRANCH]`

### Staging

To deploy master to staging use:

`bin/deploy staging`

To deploy any other branch to staging use:

`bin/deploy staging [BRANCH]`
