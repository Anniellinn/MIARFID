#!/bin/bash

export LC_ALL=C

rm -f nameStates nameLabels log

if [ $# -eq 0 ]
then
  echo "Usage: $0 model"
  echo "models is a file containing the information 
needed to construct the model. Its format is:
model_name1 

s11 w11 w12 ... 
s12 w21 w22 ...
...
s1n wn1 wn2

s21 w11 w12 ... 
s22 w21 w22 ...
...
s2m wm1 wm2

...
"
  exit
fi

RANDOM=5

cat $1 | grep -v "^@" | awk -v r=$RANDOM '
BEGIN {
  srand(r); numS = 0; numL = 0; vF[1000] = 0; nM=0; numI = 0;
  pS = -1;
}
{
  if (NF == 0) {
    if (pS != -1) {finalS[cS]++; cS = 0; pS=0;}
    pS = -1;
  }
  else {
    if ($1 in vS) {
      cS=vS[$1]; 
      if (pS == -1) { 
        vI[cS]++; 
        numI++;
      }
      else {
        saux = sprintf("%d-%d", pS, cS);  
        mtrans[saux]++;}
    }
    else {
      vS[$1] = numS; cS = numS; numS++;
      if (pS == -1) {vI[cS]++;numI++;}
      else { 
        saux = sprintf("%d-%d", pS, cS); 
        mtrans[saux]++;
      }
    }
    for (i=2; i<=NF; i++) {
      if ($i in vL) idL = vL[$i] ; 
      else {vL[$i] = numL; idL = numL; numL++;}
            saux = sprintf("%d-%d", cS, idL);
      vSvL[saux]++;
      saux = sprintf("%d-%d", cS, cS);
      mtrans[saux]++;
    }		
    pS=cS;    
  }
}
END {
  printf("HMM %d %d\n",numS+1,numL);
  for (n in mtrans) {split(n, a, "-"); outS[a[1]] += mtrans[n]; }
  for (i=0; i<numS; i++) outS[i] += finalS[i];
  for (i=0; i<numS; i++) printf(" %.4f",vI[i]/numI); printf("\n");
  for (i=0; i<numS; i++) {
    for (j=0; j<numS; j++) {
      saux = sprintf("%d-%d", i, j);
      if (saux in mtrans) printf( " %.4f", mtrans[saux] / outS[i]);
      else printf( " %.4f",0.0);
    }
    printf( " %.4f",  finalS[i] / outS[i]);
    printf("\n");
  }
  for (n in vSvL) {split(n, a, "-"); outSL[a[1]] += vSvL[n]; }
  for (e in vL) vnL[vL[e]] = e;
  for (i=0; i<numL; i++) {
    for (j=0; j<=numS; j++) {
      saux = sprintf("%d-%d", j, i);
      if (saux in vSvL) printf( " %.4f", vSvL[saux] / outSL[j]);
      else printf( " %.4f",0.0);
    }
    printf(" %s\n",vnL[i]);
  }
  printf("\n");
  for (e in vS) printf("%d %s\n",vS[e], e) >> "./nameStates";
  for (e in vL) printf("%d %s\n",vL[e], e) >> "./nameLabels";	
}'
    
