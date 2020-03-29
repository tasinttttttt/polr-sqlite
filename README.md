# Polr sqlite, php

Based on [https://github.com/realPy/polr-sqlite](https://github.com/realPy/polr-sqlite).

### 1. Requirements

Uses `git`, `envsubst`, `sqlite3`.

```
# envsubsts for osx users:
brew install gettext
brew link --force gettext
```

### 2. Configuration

Create a `conf` file

```sh
cp .conf conf
```

Edit the conf file with your configuration

```sh
POLR_ADMIN_USERNAME="admin"
POLR_ADMIN_PASSWORD="pass"
POLR_ADMIN_EMAIL="email@tld"
POLR_DATABASE_NAME="polr.db"
POLR_SETTING_PSEUDORANDOM_ENDING="true"

INSTALLATION_FOLDER="www"

APP_ADDRESS="localhost"
APP_PROTOCOL="http://"
APP_NAME="Polr"

```

### 3. Installation

```sh
sh ./run.sh
```

### 4. Running
```sh
# localhost, in ./www/
php artisan serve

# remote
upload the contents of ./www/
```