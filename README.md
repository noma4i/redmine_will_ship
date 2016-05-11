# Redmine WillShip Plugin

Plugin to give confidence to redmine users are tickets shipped to staging/production or not.

## Features

Plugin checks your staging/production and mark tickets shipped or not. It will try to find linked commits from issue in your git history stored as file at endpoint(harbor)

  * You can select different rules like 'All commits should present' or 'At least ONE commit is present'
  * Custom Field called 'Shipped' is updated to 'Yes/No' if at least ONE harbor is shipped.
  * Commits will be marked with Tick if they are present on any destination

## SHOW TIME
### Plugin
![Plugin](screenshots/list.png?raw=true)
### Setup Harbors to check
![Plugin](screenshots/harbors.png?raw=true)
### Additional block in issues
![Plugin](screenshots/issue.png?raw=true)
### Using Custom Field
![Plugin](screenshots/column.png?raw=true)
### Changes are marked as shipped
![Plugin](screenshots/changeset.png?raw=true)


## Compatibility
  - Tested with Redmine 2.4.x - 3.1.x

## Setup
### Installation
Clone it into under plugins folder:
````
  $ git clone https://github.com/noma4i/redmine_will_ship.git will_ship
````
Install missing gems:
````
  $ bundle install
````
Run bundle install:
````
  $ bundle install
````
Run migrations:
````
  $ rake redmine:plugins:migrate
````
### Configuration

First of all you will need to introduce special file, output of
````
  $ git log --format="%H"
````
as endpoint.

Example:
````
  http://example.com/will_ship.txt
````

containing
````
058fea8152237ade655b8363801bb32cdf888d30
df623f9452a2f644562d9dc830bd433cd423da24
c76ccda68c6ba16c744ec63161fe3d0f59431251
a08f2cbbb88cc3132b98e9542c07b92f67228acf
b0a61793bbb4e6762ef42f72aa9f6d6d59d36466
4547840ebabfee93628a1553123d5ed252f0825a
edd0fdb56469b1de3f2ba8961121ae252ac0accc
7aa141c077d64777fa8b2d71f1738f28b96ae0f6
20cc5cc5f58b341ae5397856240a535eaa7387dd
````
## Usage

Go to *Administration -> Will Ship* and create *harbors* to check

### Checking Harbors for ships

Plugin will try to check issue status on every issue update. You may want to setup cron job to run daily task

````
  $ rake redmine:will_ship:check_harbors
````

This rake task will fetch updates for every issue which was created/updated 1 week ago

## Author

[Alexander Tsirel @noma4i](https://github.com/noma4i)

## Contribution Guide

Open Issue or send PR ;)