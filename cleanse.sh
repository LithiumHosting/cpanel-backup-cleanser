#!/usr/bin/env bash

BASEPATH=$(cd `dirname $0` && pwd)
CPBACKUP=$1
CPBACKUP_DIR=$(tar -tzf "$CPBACKUP" | head -1 | cut -f1 -d"/")
tar -xzf "$CPBACKUP" -C /tmp/

## Remove unnecessary files
rm -f /tmp/"$CPBACKUP_DIR"/homedir/cache/*
rm -rf /tmp/"$CPBACKUP_DIR"/homedir/logs/*
rm -rf /tmp/"$CPBACKUP_DIR"/homedir/tmp/*
rm -f /tmp/"$CPBACKUP_DIR"/homedir/*.zip
rm -f /tmp/"$CPBACKUP_DIR"/homedir/*.gz

## Truncate mail files
find /tmp/"$CPBACKUP_DIR"/homedir/mail/ -type f -exec truncate -s0 '{}' \;

## Parse Domain Paths
PATHS=($("$BASEPATH"/parser.php -f /tmp/"$CPBACKUP_DIR"))
for i in "${PATHS[@]}"
do
  find "$i" -type f -exec truncate -s0 '{}' \;
done;
## Truncate all website files to maintain structure
find /tmp/"$CPBACKUP_DIR"/homedir/public_html/ -type f -exec truncate -s0 '{}' \;

## Truncate MySQL
for db in /tmp/"$CPBACKUP_DIR"/mysql/*.sql
do
  sed -i '/INSERT INTO /d' "$db"
done

## gzip
cd /tmp
tar -czf /var/www/html/"$CPBACKUP_DIR"_sanitized.tar.gz "$CPBACKUP_DIR"
chmod 644 /var/www/html/"$CPBACKUP_DIR"_sanitized.tar.gz

## cleanup
rm -rf /tmp/"$CPBACKUP_DIR"

echo The backup file has been placed in var/www/html/"$CPBACKUP_DIR"_sanitized.tar.gz
echo It\'s accessible via https://"$(hostname)"/"$CPBACKUP_DIR"_sanitized.tar.gz
echo Be sure to delete the file once it has been received by ApisCP Support