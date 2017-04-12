#!/bin/bash
date

# TRS: Need a better way to extract the relevant domain names used
# by each entity. The active enpoints rather than the entityIDs.
wget https://md.test.aaf.edu.au/aaf-test-metadata.xml -O dl
sed '/idp/d' ./dl >> dl2
grep 'entityID' dl2 >> dl3
sed -n 's#.*\(https*://[^"]*\).*#\1#;p' dl3 >> dl4
sed -e 's/^http:\/\///g' -e 's/^https:\/\///g' dl4 >> dl5
sed 's:/.*::' dl5 >> metadata
rm dl
rm dl2
rm dl3
rm dl4
rm dl5


#TRS Find entries that do not have a DNS record for their domain name.
for LINE in `cat metadata`
do
  dig $LINE | grep NOERROR 1>/dev/null && echo $LINE >> success || echo $LINE >> fail
done

#TRS This will never provide any results and all entries do not have a DNS record.
#TRS Could use host instead of dig in the processing above and use $? to check for 
#TRS SUCCESS or FAIL
for LINE2 in `cat fail`
do
  host $LINE2 >/dev/null
  if [ "$LINE2" = 0 ]
  then
  echo "Host Check $LINE2 UP" >> recheck
  else
  echo "Host Check $LINE2 FAIL"
  fi
done

#TRS Will never find any for retrying.
for LINE3 in `cat fail`
do
  ping $LINE3 >/dev/null
  if [ "$LINE3" = 0 ]
  then
  echo "Ping Check $LINE3 UP" >> recheck
  else
  echo "Ping Check $LINE3 FAIL"
  fi
done

#TRS Same as above.
for LINE4 in `cat fail`
do
  curl $LINE4 >/dev/null
  if [ "$LINE4" = 0 ]
  then
  echo "Curl Check $LINE4 UP" >> recheck
  else
  echo "Curl Check $LINE4 FAIL"
  fi
done

#TRS Same as above
for LINE5 in `cat fail`
do
  nmap -Pn $LINE5 >/dev/null
  if [ "$LINE5" = 0 ]
  then
  echo "Previous check FAIL - NMAP Check $LINE5 SUCCESS" >> recheck
  else
  echo "NMAP Check $LINE5 FAIL"
  fi
done
#Need to fix return result for success >> recheck



for LINE6 in `cat success`
do
  nmap -Pn $LINE6 >/dev/null
  if [ "$LINE6" = 1 ]
  then
  echo "Previous check SUCCESS - NMAP Check $LINE6 FAIL" >> recheck
  else
  echo "NMAP Check $LINE6 SUCCESS"
  fi
done
