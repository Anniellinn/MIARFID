#!/bin/bash

export LC_ALL=es_ES.UTF-8

if [ $# -eq 0 ]; then
  echo $0 bibfile
  exit
fi

[ -f $2 ] || echo "" >> nameLabels

cat $1 | grep -v "^@" | awk -v sLab=$2 '
BEGIN {
  if (sLab != "") {
    f=1; nL = 0;
    while (f!=0) {
      f = getline reg < sLab;
      nC = split(reg,a)
      nameLab[a[2]] = a[1];
      if (a[1] > nL) nL = a[1];
    }
  }
}
{
  for (i=2; i<=NF; i++) 
    if (!($i in nameLab)) 
      nameLab[$i] = ++nL;  
}
END {
  for (i in nameLab)
    printf("%d %s\n",nameLab[i],i)
}'
