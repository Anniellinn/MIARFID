#!/bin/bash

export LC_ALL=C

if [ $# -eq 0 ]
then
  echo "Usage: $0 bib-file map-file"
  exit
fi

RANDOM=5

cat $1 | grep -v "^@" | awk -v r=$RANDOM -v sLab=$2 '
BEGIN {
  if (sLab != "") {
    f=1;
    while (f!=0) {
      f = getline reg < sLab;
      nC = split(reg,a)
      nameLab[a[2]] = a[1];
    }
  }
}
{
  if (NF != 0)
    for (i=2; i<=NF; i++) 
      if ($i in nameLab) printf("%s ",$i);
      else printf("UNK ");
  else
    printf("\n");
}
'
