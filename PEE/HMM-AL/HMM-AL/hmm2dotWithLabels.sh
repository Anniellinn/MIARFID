#!/bin/bash

if [ $# -eq 0 ]
then
  echo ""
  echo "Usage: $0 hmm tTh [statesLabels]"
  echo ""
  echo "Plot only transitions which probability is larger than tTh (0.0 by default)."
  exit
fi

tTH=$2
sL=""
if [ $# -eq 3 ]
then
  sL=$3
fi

awk -v tH=$tTH -v sLab=$sL '
BEGIN {
  printf("digraph hmm {\n");
  printf("  rankdir=LR;\n");
  if (sLab != "") {
    f=1;
    while (f!=0) {
      f = getline reg < sLab;
      nC = split(reg,a)
      stateLab[a[1]] = a[2];
    }
  }
}
{
  if (NR == 1) {
    nC = split($0,a);
    nState = a[2];
  }
  else if (NR == 2) {
    nC = split($0,a);
    printf("  node [shape=doublecircle];")

    for (i=1; i<=nC; i++)
      if (a[i] > 0.0) {
        if (sLab == "")
          printf(" %d",i-1);
        else
          printf(" \"%s\"",stateLab[i-1]);
      }
    printf("\n  node [shape=circle];\n");     
  } else if (NR > 2 && NR <= nState+2) {
    nC = split($0,a);
    for (i=1; i<=nC; i++)
      if (a[i] > tH) {
        if (sLab == "")
          printf("  %d -> %d [ label = %1.3f ];\n",NR-4,i-1,a[i]);
        else
          printf("  \"%s\" -> \"%s\" [ label = %1.3f ];\n",
                 stateLab[NR-4],stateLab[i-1],a[i]);
        fflush(stdout);
      }
  }
}
END {
  for (i=1; i<=nState; i++)
    if (sLab == "")
      printf("  \"%d\" [ label = \"%d\\n%s [%1.3f]\\n%s [%1.3f]\" ];\n",
              i-1,i-1,et1[i],pr1[i],et2[i],pr2[i]);
    else
      printf("  \"%s\" [ label = \"%s\" ];\n",stateLab[i-1],stateLab[i-1]);
  printf("}\n");
}' $1
