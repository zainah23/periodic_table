#!/bin/bash
# Periodic Table element lookup program
# Query the periodic_table database

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
  exit 0
fi

ELEMENT_INFO=$($PSQL "
SELECT e.atomic_number, e.name, e.symbol, p.atomic_mass,
       p.melting_point_celsius, p.boiling_point_celsius, t.type
FROM elements e
JOIN properties p ON e.atomic_number = p.atomic_number
JOIN types t ON p.type_id = t.type_id
WHERE e.atomic_number::text = '$1'
   OR e.symbol = '$1'
   OR e.name = '$1';
")

if [[ -z $ELEMENT_INFO ]]
then
  echo "I could not find that element in the database."
  exit 0
fi

IFS='|' read ATOMIC_NUMBER NAME SYMBOL MASS MELTING_POINT BOILING_POINT TYPE <<< "$ELEMENT_INFO"

echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."


