#!/bin/bash
date

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

nmap -iL metadata -sV -A -O --osscan-guess --version-all -T4 -oA results224

#??
#nc idp.example.com 80 (OR Open port)

# nmap -sV -A -O --osscan-guess --version-all -T4
