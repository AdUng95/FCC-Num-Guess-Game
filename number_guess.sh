#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=<database_name> -t --no-align -c"

echo "Enter your username:"
read USERNAME

AVAIL_USERNAME=$($PSQL "SELECT username FROM users WHERE username='$USERNAME'")
GAMES_PLAYED=$($PSQL "SELECT COUNT(*) FROM users INNER JOIN games USING(user_id) WHERE username='$USERNAME'")
BEST_GAMES=$($PSQL "SELECT MIN(number_guesses) FROM users INNER JOIN games USING(user_id) WHERE username='$USERNAME'")

if [[ -z $AVAIL_USERNAME ]]
  then
  INSERT_USER=$($PSQL "INSERT INTO users(username) VALUES('$USERNAME')")
  U_ID=$($PSQL "SELECT user_id FROM users WHERE name='$USERNAME'")
  echo "Welcome, $USERNAME! It looks like this is your first time here."
  else
  echo "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAMES guesses."
fi

SECRET_NUMBER=$((1 + $RANDOM % 1000))
TRIES=0
GUESSED=0
echo "Guess the secret number between 1 and 1000:"

while [[ $GUESSED = 0 ]] 
do
  read GUESS
  if [[ ! $GUESS =~ ^[0-9]+$ ]]
  then
    echo "That is not an integer, guess again:"
  else
    if [[ $GUESS -gt $SECRET_NUMBER ]]
      then
        TRIES=$(($TRIES + 1))
        echo -n "It's lower than that, guess again:"
      elif [[ $GUESS -lt $SECRET_NUMBER ]]
        then
        TRIES=$(($TRIES + 1))
        echo -n "It's higher than that, guess again:"
      elif [[ $GUESS -eq $SECRET_NUMBER ]]
        then
        TRIES=$(($TRIES + 1))
        echo "You guessed it in $TRIES tries. The secret number was $SECRET_NUMBER. Nice job!"
        INSERT_GAMES=$($PSQL "INSERT INTO games(user_id, number_guesses) VALUES($U_ID, $TRIES)")
        GUESSED=1
        exit
    fi
  fi
done