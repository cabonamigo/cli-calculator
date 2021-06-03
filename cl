#! /bin/bash

bc="/usr/bin/bc"
ec="/usr/bin/echo"
sd="/usr/bin/sed"

liner=$(echo "$@" | \
   $sd -E "s/\,/\./g" | \
   $sd -E "s/\×/\*/g" | \
   $sd -E "s/\¹/ \^ 1/g" | \
   $sd -E "s/\²/ \^ 2/g" | \
   $sd -E "s/\³/ \^ 3/g" | \
   $sd -E "s/(\-r|\-\-result)//g" | \
   $sd -E "s/(\-s|\-\-sameline)//g" | \
   $sd -E "s/^\s//g" | \
   $sd -E "s/(R|rem|remider|mod|modulo)/\%/g"| \
   $sd -E "s/(E|exp|exponen|exponetiation)/\^/g"| \
   $sd -E "s/(A|add|sum|sums|plus|mais|moar)/\+/g"| \
   $sd -E "s/(S|sub|subtract|min|minus|menos|menas)/\-/g" | \
   $sd -E "s/(M|mul|mult|multi|times|vezes|multiply|multiplys|multiplies)/\*/g" | \
   $sd -E "s/(D|div|divs|divide|divides|divided|divided by|dividido|dividido por)/\//g"
)

function result(){
  $ec "$liner" | $bc -q -i | tr '\n' "=" | $sd -En "s/.*\=(.*)\=.*/\1\n/p"
}

function sameline(){
  $ec "$liner" | $bc -q -i | tr '\n' "=" | $sd -E "s/\=$/\n/g" | $sd -E "s/\=/ \= /g"
}

function normal(){
  $ec "$liner" | $bc -q -i
}

case $1 in

"")
  echo -e 'We need a basic equation to process, it can be either:\n\n
    - subtraction\n
    - adiction\n
    - multiplication\n
    - division\n
  '
  exit
;;

-h|--help)
  help='This is just a wrapper around bc calculator to make it\n
     easier to use for small time calculations .\n\n
     You can use the following mnemonics for: \n
     \n
      - reminder (R,rem,reminder,mod,modulo)
      - exponentiation (E,exp,expo,exponen...)
      - addition (A,sum,sums,plus,mais...) \n
      - subtraction (S,min,minus,menos...) \n
      - multiplication (M,mul,mult,multiply,multiplyes,multiplies...) \n
      - division (D,div,divs,divide,didvides,divided,divided by,dividido...) \n
     \n
     eg. 1 mais 2; 3 menas 1; 24 vezes 2;13 mul 5; 15 div 4; 3²; 5 mod 3
     \n
     You can also use the following flags:
     \n
     -r or --result		it shows just the result in a new line \n
     -s or --sameline		it shows equation and result in the same line \n
     \n
     The default behavior is to show equation in a new line and result in another new line.
     \n
     This wrapper was done to prevent shell interpretation of '*' as a glob/wildcard.
     \n
     Other characters still get interpreted and or evaluated by bash first.
     \n
     Fin ...\n\n
  '
  echo "$help"
  exit
;;

-r|--result) # shows just the result in a new line
  result
  exit
;;

-s|--sameline) # shows equation and result in same line
  sameline
  exit
;;

*) #shows equation in one line and result in a new line
  normal
  exit
esac
