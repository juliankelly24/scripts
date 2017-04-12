#!/bin/bash

DOMAINS=$1
TMP_DIR=$2

cat domains.txt |  while read domains; do
    echo -e "----- Start scraping $domain - Please wait -----"
    wget \
      --quiet \
      --recursive \
      --page-requisites \
      --html-extension \
      --convert-links \
      --restrict-file-names=windows \
      --domains $domain, www.$domain \
      --no-parent \
      --directory-prefix=$TMP_DIR \
      --progress=bar \
      --tries=3 \
      $domain
done
wait

### Split scrap and grep to prepare multiprocess script (coming soon)
while read domain; do
    echo -e "----- Start email finding and filtering for $domain - Please wait -----"
    grep -R -E -oh "\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,6}\b" $TMP_DIR/$domain/* | sort |uniq > $TMP_DIR/$domain.emails.txt
    echo -e "----- Emails saved to $TMP_DIR/$domain.emails.txt -----"
done
wait

echo -e "----- Finished -----"
