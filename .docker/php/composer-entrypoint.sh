#!/bin/sh

useradd --key UID_MIN=1 --uid $TARGET_UID --shell /bin/sh --home-dir $COMPOSER_HOME composer >/dev/null 2>&1
runuser --preserve-environment --pty --user composer -- /usr/bin/composer "$@"
