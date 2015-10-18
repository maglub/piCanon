BEGIN {
  FS=": ";
  parameterCount=0;
  attributeCount=0;
  choiceCount=0; 
  printf "{";
  
}

/^\//{
  if (choiceCount > 0 ) { printf "}"; choiceCount = 0;}
  if ( parameterCount > 0 ) { printf "},"; }
  printf "\"%s\":{", $1
  parameterCount++;
  attributeCount=0;
  next;
}


/^Choice/ {
  if (choiceCount == 0 && attributeCount > 0) { printf ","; }
  if (choiceCount == 0) { printf "\"choice\":{"; }
  if (choiceCount > 0 ) {printf ",";}
  printf "\"%s\":\"%s\"", $1, $2;
  choiceCount++; 
  next;
}

! /^\// {
  if (attributeCount > 0) { printf ","; }
   printf "\"%s\":\"%s\"", $1, $2
  attributeCount++;
}

END {
  printf "}}\n";
}
