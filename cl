#! /bin/bash

bc="/usr/bin/bc"
ec="/usr/bin/echo"
ed="/usr/bin/sed"

liner=$(echo "$@" | \
   $ed -E "s/\,/\./g" | \
   $ed -E "s/\×/\*/g" | \
   $ed -E "s/\²\⁰/ \^ 20 /g" | \
   $ed -E "s/\¹\⁹/ \^ 19 /g" | \
   $ed -E "s/\¹\⁸/ \^ 18 /g" | \
   $ed -E "s/\¹\⁷/ \^ 17 /g" | \
   $ed -E "s/\¹\⁶/ \^ 16 /g" | \
   $ed -E "s/\¹\⁵/ \^ 15 /g" | \
   $ed -E "s/\¹\⁴/ \^ 14 /g" | \
   $ed -E "s/\¹\³/ \^ 13 /g" | \
   $ed -E "s/\¹\²/ \^ 12 /g" | \
   $ed -E "s/\¹\¹/ \^ 11 /g" | \
   $ed -E "s/\¹\⁰/ \^ 10 /g" | \
   $ed -E "s/\⁹/ \^ 9 /g" | \
   $ed -E "s/\⁸/ \^ 8 /g" | \
   $ed -E "s/\⁷/ \^ 7 /g" | \
   $ed -E "s/\⁶/ \^ 6 /g" | \
   $ed -E "s/\⁵/ \^ 5 /g" | \
   $ed -E "s/\⁴/ \^ 4 /g" | \
   $ed -E "s/\³/ \^ 3 /g" | \
   $ed -E "s/\²/ \^ 2 /g" | \
   $ed -E "s/\¹/ \^ 1 /g" | \
   $ed -E "s/(R|rem|remider|mod|modulo)/\%/g"| \
   $ed -E "s/(E|exp|exponen|exponetiation)/\^/g"| \
   $ed -E "s/(A|add|sum|sums|plus|mais|moar)/\+/g"| \
   $ed -E "s/(S|sub|subtract|min|minus|menos|menas)/\-/g" | \
   $ed -E "s/(M|mul|mult|multi|times|vezes|multiply|multiplys|multiplies)/\*/g" | \
   $ed -E "s/(D|div|divs|divide|divides|divided|divided by|dividido|dividido por)/\//g" | \
   $ed -E "s/(r|result|\-r|\-\-result)//g" | \
   $ed -E "s/(s|sameline|\-s|\-\-sameline)//g" | \
   $ed -E "s/^\s//g" 

)

function result(){
  $ec "$liner" | $bc -q
}

function sameline(){
  $ec "$liner" | $bc -q -i | tr '\n' "=" | $ed -E "s/\=$/\n/g" | $ed -E "s/\=/ \= /g"
}

function normal(){
  $ec "$liner" | $bc -q -i
}

case $1 in

"")
  echo -e '
  cl - A simple cli calculator script around bc

  We need a basic equation to process, it can be either:\n
    - addition (A,sum,sums,plus,mais...)
    - subtraction (S,min,minus,menos...)
    - multiplication (M,mul,mult,multiply,multiplyes,multiplies...)
    - division (D,div,divs,divide,didvides,divided,divided by,dividido...)
    - reminder / modulo (R,rem,reminder,modulo)
    - exponetiation (E,exp,exponen,exponentiation)
  '
  exit
;;

h|help|-h|-help|--help)
  help='
  cl -  A simple cli calculator script around bc

  This is just a wrapper around bc calculator to make it
     easier to use for small time calculations .

     You can use the following mnemonics for:

      - addition (A,sum,sums,plus,mais...)
      - subtraction (S,min,minus,menos...)
      - multiplication (M,mul,mult,multiply,multiplyes,multiplies...)
      - division (D,div,divs,divide,didvides,divided,divided by,dividido...)
      - reminder / modulo (R,rem,reminder,modulo)
      - exponetiation (E,exp,exponen,exponentiation)

     You can also use the following flags:

     r, -r or --result		it shows just the result in a new line
     s, -s or --sameline		it shows equation and result in the same line

     The default behavior is to show equation in a new line and result in another new line.
     This wrapper was done to prevent shell interpretation of '*' as a glob/wildcard.
     Other characters still get interpreted and or evaluated by bash first.

  '
  echo "$help"
  exit
;;

r|result|-r|--result) # shows just the result in a new line
  result
  exit
;;

s|sameline|-s|--sameline) # shows equation and result in same line
  sameline
  exit
;;

*) #shows equation in one line and result in another new line
  normal
  exit
esac
