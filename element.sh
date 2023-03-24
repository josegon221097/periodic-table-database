#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

#the user runs the script without input
if [[ -z $1 ]]
then
    echo -e "Please provide an element as an argument."
else
    
    if [[ $1 =~ ^[0-9]+$ ]]
    then

        FIND_ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number=$1")

        if [[ -z $FIND_ATOMIC_NUMBER ]]
        then
            echo "I could not find that element in the database."
        else
            SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number=$FIND_ATOMIC_NUMBER")
            NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number=$FIND_ATOMIC_NUMBER")
            TYPE=$($PSQL "SELECT DISTINCT types.type FROM properties LEFT JOIN types ON properties.type_id=types.type_id WHERE properties.atomic_number=$FIND_ATOMIC_NUMBER")
            ATOMIC_MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number=$FIND_ATOMIC_NUMBER")
            MELTING_POINT=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number=$FIND_ATOMIC_NUMBER")
            BOILING_POINT=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number=$FIND_ATOMIC_NUMBER")
            echo "The element with atomic number $FIND_ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
        fi
    else
        FIND_SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE symbol='$1'")
        FIND_NAME=$($PSQL "SELECT name FROM elements WHERE name='$1'")

        if [[ -z $FIND_SYMBOL ]] && [[ -z $FIND_NAME ]]
        then
            echo "I could not find that element in the database."
        
        elif [[ -z $FIND_SYMBOL ]]
        then
            
            SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE name='$FIND_NAME'")
            ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE name='$FIND_NAME'")
            TYPE=$($PSQL "SELECT DISTINCT types.type FROM properties LEFT JOIN types ON properties.type_id=types.type_id WHERE properties.atomic_number='$ATOMIC_NUMBER'")
            ATOMIC_MASS=$($PSQL "SELECT DISTINCT properties.atomic_mass FROM properties LEFT JOIN elements ON properties.atomic_number=elements.atomic_number WHERE name='$FIND_NAME'")
            MELTING_POINT=$($PSQL "SELECT DISTINCT properties.melting_point_celsius FROM properties LEFT JOIN elements ON properties.atomic_number=elements.atomic_number WHERE name='$FIND_NAME'")
            BOILING_POINT=$($PSQL "SELECT DISTINCT properties.boiling_point_celsius FROM properties LEFT JOIN elements ON properties.atomic_number=elements.atomic_number WHERE name='$FIND_NAME'")
            echo "The element with atomic number $ATOMIC_NUMBER is $FIND_NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $FIND_NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
        
        else
            
            NAME=$($PSQL "SELECT name FROM elements WHERE symbol='$FIND_SYMBOL'")
            ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE symbol='$FIND_SYMBOL'")
            TYPE=$($PSQL "SELECT DISTINCT types.type FROM properties LEFT JOIN types ON properties.type_id=types.type_id WHERE properties.atomic_number=$ATOMIC_NUMBER")
            ATOMIC_MASS=$($PSQL "SELECT DISTINCT properties.atomic_mass FROM properties LEFT JOIN elements ON properties.atomic_number=elements.atomic_number WHERE symbol='$FIND_SYMBOL'")
            MELTING_POINT=$($PSQL "SELECT DISTINCT properties.melting_point_celsius FROM properties LEFT JOIN elements ON properties.atomic_number=elements.atomic_number WHERE symbol='$FIND_SYMBOL'")
            BOILING_POINT=$($PSQL "SELECT DISTINCT properties.boiling_point_celsius FROM properties LEFT JOIN elements ON properties.atomic_number=elements.atomic_number WHERE symbol='$FIND_SYMBOL'")
            echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($FIND_SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."

        fi

    fi
    
fi