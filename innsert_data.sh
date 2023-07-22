#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

echo $($PSQL "TRUNCATE games, teams")
# Do not change code above this line. Use the PSQL variable above to query your database.
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
if [[ $YEAR != "year" ]]
then
  #insert winner team
  GET_WINNER_TEAM=$($PSQL "SELECT name FROM teams WHERE name = '$WINNER'")
  if [[ -z $GET_WINNER_TEAM ]]
  then
    INSERT_WINNER_TEAM=$($PSQL "INSERT INTO teams(name) VALUES ( '$WINNER' )")
    if [[ $INSERT_WINNER_TEAM == "INSERT 0 1" ]]
		then
			echo Inserted into winner, $WINNER
		fi
  fi

  #insert opponent team
  GET_OPPONENT_TEAM=$($PSQL "SELECT name FROM teams WHERE name = '$OPPONENT'")
  if [[ -z $GET_OPPONENT_TEAM ]]
  then
    INSERT_OPPONENT_TEAM=$($PSQL "INSERT INTO teams(name) VALUES ('$OPPONENT')")
    if [[ $INSERT_OPPONENT_TEAM == "INSERT 0 1" ]]
    then
      echo Inserted into opponent, $OPPONENT
    fi
  fi

  #insert games
  GET_WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER' ")
  GET_OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT' ")

  INSERT_INTO_GAMES=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES ($YEAR, '$ROUND', $GET_WINNER_ID, $GET_OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
  if [[ $INSERT_INTO_GAMES == "INSERT 0 1" ]]
  then
    echo Inserted into game, $YEAR
  fi
fi
done
