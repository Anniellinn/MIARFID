#!/bin/bash

export LC_ALL=es_ES.UTF-8

if [ $# -eq 0 ]; then
  echo $0 bibfile
  exit
fi

cat $1 | grep -v "Bdsk" | grep -v Date-Add | grep -v Date-Modi | grep -v unpublished | \
    grep -v Timestam | grep -v http | grep -i -v "crossref" |  \
    grep -i -v Reprint | grep -v Rating |  grep -v Citeulike | grep -v Owner | \
    grep -v Edyear | \
    awk '
BEGIN{
  st["abstract"]=1;    st["address"]=1;   st["adsurl"]=1;      st["annote"]=1; 
  st["annotation"]=1;  st["author"]=1;    st["bibsource"]=1;   st["biburl"]=1; 
  st["book"]=1;        st["booktitle"]=1; st["chapter"]=1;
  st["doi"]=1;         st["date"]=1; 
  st["documenturl"]=1; st["edition"]=1;   st["ee"]=1;          st["howpublished"]=1;
  st["isbn"]=1;        st["issue"]=1;     st["issue_date"]=1;  st["edition"]=1; 
  st["editor"]=1;      st["editors"]=1;   st["institution"]=1; st["issn"]=1;
  st["journal"]=1;     st["key"]=1;       st["keyword"]=1;     st["keywords"]=1;  
  st["language"]=1;    st["library"]=1;   st["location"]=1;    st["month"]=1;
  st["note"]=1;        st["number"]=1;    st["numpages"]=1;    st["organization"]=1; 
  st["pages"]=1;       st["pdf"]=1;       st["publisher"]=1;   st["school"]=1;
  st["series"]=1;      st["title"]=1;     st["topic"]=1;       st["translator"]=1;
  st["type"]=1;      
  st["url"]=1;         st["vol"]=1;       st["volume"]=1;      st["volumen"]=1;   
  st["year"]=1;
  cl["@article"];       cl["@book"]; cl["@incollection"];
  cl["@inproceedings"]; cl["@misc"]; cl["@phdthesis"];
  cl["@techreport"]; cl["@manual"];
  currentField = ""; currentEntry="";
}
{
  s1 = gensub("[{]+"," ", 1, $0);
  split(s1, a, " "); a1=tolower(a[1]); 
  if (a1 in cl) {
    currentEntry = a1;
    printf("\n\n%s",currentEntry); 
  }
  else if ((tolower($1) in st) && ($2 == "=")){
    printf("\n%s ",tolower($1));
    if (split($0, a, "=") > 1) 
    s1 = gensub("[{]+"," ", 1, a[2]); else printf("Unexpected error: 1\n");
    s1 = gensub("[,;~]+"," ", "g", s1);
    s1 = gensub("[}]+[ ]*$"," ", 1, s1);
    s1 = gensub("[ \t]+"," ", "g", s1);
    printf("%s ",s1);
  } else {
    s1 = gensub("[,;~]+"," ", "g", $0);
    s1 = gensub("[}]+[ ]*$"," ", 1, s1);
    s1 = gensub("[ ]+"," ", "g", s1);
    printf("%s ",s1);
  }
}' | grep -v "^keyword" | grep -v "^numpage" | grep -v "^abstract" | \
    grep -v "^howpublished" | grep -v "^library" | grep -v "%" |  \
    grep -v "^adsurl" | grep -v "^annotation" | \
    sed 's/ \+/ /g' |  sed 's/ "/ /g;s/" / /g' | \
    sed "s/\\\'a/á/g;s/\\\'e/é/g;s/\\\'i/í/g;s/\\\'o/ó/g;s/\\\'ú/ú/g" | \
    sed "s/\([[:digit:]]\+\)\([-]\+\)\([[:digit:]]\+\)/ \1 \3 /g" | \
    sed 's/{//g' | sed 's/}//g' | sed 's/ \+/ /g'




