#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

# No argument provided huh?
if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
  exit 0
fi

# Decide how to search what
if [[ $1 =~ ^[0-9]+$ ]]
then
  CONDITION="e.atomic_number = $1"
else
  CONDITION="e.symbol = '$1' OR e.name = '$1'"
fi

# Query database
RESULT=$($PSQL "
SELECT
e.atomic_number,
e.name,
e.symbol,
t.type,
p.atomic_mass,
p.melting_point_celsius,
p.boiling_point_celsius
FROM elements e
JOIN properties p USING(atomic_number)
JOIN types t USING(type_id)
WHERE $CONDITION
")

# Element not found
#say what
#askgfnvak
#test
if [[ -z $RESULT ]]
then
  echo "I could not find that element in the database."
  exit 0
fi

# Parse result
IFS="|" read ATOMIC_NUMBER NAME SYMBOL TYPE MASS MELT BOIL <<< "$RESULT"

# Output
echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELT celsius and a boiling point of $BOIL celsius."
