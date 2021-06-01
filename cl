#! /bin/bash -f

#set -f

bc="/usr/bin/bc"
ec="/usr/bin/echo"

liner=$(echo "$@" | \
   sed -E "s/\,/\./g" | \
   sed -E "s/\×/\*/g" | \
   sed -E "s/\-r//g" | \
   sed -E "s/(A|add|sum|sums|plus|mais)/\+/g"| \
   sed -E "s/(S|sub|subtract|min|minus|menos)/\-/g" | \
   sed -E "s/(M|mul|mult|multi|times|vezes|multiply|multiplys|multiplies)/\*/g" | \
   sed -E "s/(D|div|divs|divide|divides|divided|divided by|dividido|dividido por)/\//g"
)

function result(){
  $ec "$liner" | $bc -q -i | tr '\n' "=" | sed -En "s/.*\=(.*)\=.*/\1\n/p"
}

function main(){
  $ec "$liner" | $bc -q -i | tr '\n' "=" | sed -E "s/\=$/\n/g" | sed -E "s/\=/ \= /g"
}

case $1 in
"")
  echo -e 'We need a basic equation to process, it can be either:\n\n
    - subtraction\n
    - addition\n
    - multiplication\n
    - division\n
  '
  exit
;;
-h|--help)
  help='This is just a wrapper around bc calculator to make it\n
     easier to use for small time calculations \n\n
     you can use the following mnemonics for:\n\n
      - addition (A,sum,sums,plus,mais ...)\n
      - subtraction (S,min,minus,menos ...)\n
      - multiplication (M,mul,mult,multiply,multiplyes,multiplies ...)\n
      - division (D,div,divs,divide,didvides,divided,divided bydividido ...)\n
     \n
     This wrapper script was done to prevent shell interpretation of asterisk character as a glob/wildcard.
     \n
     Other characters still get interpreted and or evalueted by bash 
     \n\n
  '
  echo -e "$help"
  exit
;;
-r|--result)
#echo "case RESULT"
  result $@
  exit
;;
*)
  #echo "case MAIN"
  if [ "$1" != " " ];then main;fi
  exit
esac
