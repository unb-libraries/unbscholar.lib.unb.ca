#!/usr/bin/env sh
cat /build/config/postfix/main.cf >> /etc/postfix/main.cf
postfix start
