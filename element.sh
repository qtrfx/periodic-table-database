#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

RESPONSE () {
  RESULT_FROM_QUERY=$($PSQL "SELECT type, atomic_mass, name, melting_point_celsius, boiling_point_celsius FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE atomic_number=$ATOMIC_NUMBER_CHOSEN;")
  echo "$RESULT_FROM_QUERY" | while IFS='|' read TYPE ATOMIC_MASS NAME MELTING_POINT_CELSIUS BOILING_POINT_CELSIUS
  do
    echo "The element with atomic number $ATOMIC_NUMBER_CHOSEN is $NAME ($SYMBOL_CHOSEN). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT_CELSIUS celsius and a boiling point of $BOILING_POINT_CELSIUS celsius."
  done
}


if [[ -z $1 ]]
then
echo "Please provide an element as an argument."
else
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    ATOMIC_NUMBER_CHOSEN=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number=$1;")
    SYMBOL_CHOSEN=$($PSQL "SELECT symbol from elements WHERE atomic_number=$1;")
    NAME_CHOSEN=$($PSQL "SELECT name from elements WHERE atomic_number=$1;")
  elif [[ $1 =~ ^[A-Z][a-z]?$ ]]
  then
    SYMBOL_CHOSEN=$($PSQL "SELECT symbol from elements WHERE symbol='$1';")
    NAME_CHOSEN=$($PSQL "SELECT name from elements WHERE symbol='$1';")
    ATOMIC_NUMBER_CHOSEN=$($PSQL "SELECT atomic_number FROM elements WHERE symbol='$1';")
  else
    NAME_CHOSEN=$($PSQL "SELECT name from elements WHERE name='$1';")
    SYMBOL_CHOSEN=$($PSQL "SELECT symbol from elements WHERE name='$1';")
    ATOMIC_NUMBER_CHOSEN=$($PSQL "SELECT atomic_number FROM elements WHERE name='$1';")
  fi
  if [[ -z $ATOMIC_NUMBER_CHOSEN ]] && [[ -z $NAME_CHOSEN ]] && [[ -z $SYMBOL_CHOSEN ]]
  then
    echo "I could not find that element in the database."
  else
  RESPONSE
  fi
fi


