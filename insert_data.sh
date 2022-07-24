#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

#truncate the database
echo "$($PSQL "
  TRUNCATE TABLE games, teams
")"

cat games.csv | while IFS=',' read YEAR ROUND WINNER OPPONENT W_GOALS O_GOALS
do
  #Inserting data into DBs. Ignoring first line
  if [[ $WINNER != "winner" ]]
    then
      echo "$($PSQL "
        INSERT INTO 
          teams(name)
        VALUES
          ('$WINNER')
      ")"
      echo "$($PSQL "
        INSERT INTO 
          teams(name)
        VALUES
          ('$OPPONENT')
      ")"
      # Assigning winner/opponent ids
      W_ID="$($PSQL "
        SELECT team_id
        FROM teams
        WHERE name = '$WINNER'
      ")"

      O_ID="$($PSQL "
        SELECT team_id
        FROM teams
        WHERE name = '$OPPONENT'
      ")"
    #Scanning whether the winner or opponent team is already in the teams db.
        echo "$($PSQL " 
        INSERT INTO 
          games(year, round, winner_id, opponent_id, winner_goals, opponent_goals)
        VALUES
          ($YEAR, '$ROUND', $W_ID, $O_ID, $W_GOALS, $O_GOALS)
        ")"
  fi
done