#!/bin/sh

# print commands
# set -x

# if [ ! -f conf ]; then
#     echo "\n😕 \033[92mConfiguration file not found. Stopping.\033[39m"
#     exit
# fi

# Load config from .env
echo "📖 \033[92mLoading configuration...\033[39m\n"
if [ -f conf ]; then
    export $(cat conf | sed 's/#.*//g' | xargs)
else
    echo "😕 \"./conf\" file not found.\n"
    echo "   \033[91mLoading configuration...KO\033[39m\n"
    exit
fi

if [ -z ${APP_KEY+x} ]; then
    export APP_KEY=`head -c24 < /dev/random | base64`
fi

if [ -z ${TMP_SETUP_AUTH_KEY+x} ]; then
    export TMP_SETUP_AUTH_KEY=`head -c24 < /dev/random | base64`
fi

export POLR_GENERATED_AT=`date '+%Y-%m-%d %H:%M:%S'`
export POLR_DB_FILE="$PWD/$INSTALLATION_FOLDER/$POLR_DATABASE_NAME"

echo "🛰  \033[92mGetting polr...\033[39m\n"
git clone https://github.com/cydrobolt/polr.git $INSTALLATION_FOLDER || exit

echo "💽 \033[92mInstalling polr...\033[39m\n"
cd $INSTALLATION_FOLDER && composer install

if [ ! -f $POLR_DB_FILE ] ; then
    # Create database file
    sqlite3 $POLR_DB_FILE ".databases" || exit

    # Create env file
    envsubst <../polr_env > ./.env

    # Create migration
    cp ../create_link_table.patch ./
    patch -p0 <create_link_table.patch
    rm create_link_table.patch
    echo "yes" | php artisan migrate
    CRYPTPcD=`php -r "echo password_hash('$POLR_ADMIN_PASSWORD', PASSWORD_BCRYPT, ['cost' => 8]) . PHP_EOL;"`
    RECOVERY_KEY=`head -c100 < /dev/random | base64`
    DATE=`date '+%Y-%m-%d %H:%M:%S'`
    sqlite3 $POLR_DB_FILE "INSERT INTO users VALUES(1,'$POLR_ADMIN_USERNAME','$CRYPTPWD','$POLR_ADMIN_EMAIL','127.0.0.1','$RECOVERY_KEY','admin','1',NULL,0,'60','$DATE','$DATE',NULL);"
fi

echo "\n✅  \033[92mFinished!\033[39m\n"
