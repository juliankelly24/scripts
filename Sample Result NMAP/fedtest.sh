#!/bin/bash
date

wget https://md.test.aaf.edu.au/aaf-test-metadata.xml -O dl
sed '/idp/d' ./dl >> dl2
grep 'entityID' dl2 | sed 's!.*\/\([^\/]*\.[^\/]*\)/.*!\1!' >> metadata
rm dl
rm dl2


for LINE in `cat metadata`
do
  dig $LINE | grep NOERROR 1>/dev/null && echo $LINE SUCCESS >> success || echo $LINE FAILURE >> fail
done

for LINE2 in `cat fail`
do
  host $LINE2 | grep NOERROR 1>/dev/null && echo $LINE2 SUCCESS >> recheck || echo $LINE2 FAILURE
done

for LINE3 in `cat fail`
do
  ping $LINE3 | grep NOERROR 1>/dev/null && echo $LINE3 SUCCESS >> recheck || echo $LINE3 FAILURE
done

for LINE4 in `cat fail`
do
  nmap $LINE4 | grep NOERROR 1>/dev/null && echo $LINE4 SUCCESS >> recheck || echo $LINE4 FAILURE
done
