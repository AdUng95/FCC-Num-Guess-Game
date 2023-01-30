#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=<database_name> -t --no-align -c"

echo "Enter your username:"
read USERNAME

AVAIL_USERNAME=$($PSQL "SELECT username FROM users WHERE username='$USERNAME'")

if [[ -z $AVAIL_USERNAME ]]
then
  INSERT_USER=$($PSQL "INSERT INTO users(username) VALUES('$USERNAME')")
  echo "Welcome, $USERNAME! It looks like this is your first time here."
fi