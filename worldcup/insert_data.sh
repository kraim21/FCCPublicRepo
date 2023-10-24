#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE teams,games")
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS 

do
  if [[ $YEAR != year ]]
    then
    # get winner team_id
    W_TEAMS_ID=$($PSQL "SELECT team_id from teams where name='$WINNER'")

    # if not found
    if [[  -z $W_TEAMS_ID ]]
      then
      # insert winner teams
      INSERT_WINNER_RESULT=$($PSQL "INSERT INTO teams(name) values ('$WINNER')")
      if [[ $INSERT_WINNER_RESULT == "INSERT 0 1" ]]
        then
          echo "Inserted into winning teams, $WINNER"
      fi

      # get new winner_ID
      W_TEAMS_ID=$($PSQL "SELECT team_id from teams where name='$WINNER'")
    fi

    # get opponent team_id
    O_TEAMS_ID=$($PSQL "SELECT team_id from teams where name='$OPPONENT'")

    # if not found
    if [[  -z $O_TEAMS_ID ]]
      then
      # insert opponent teams
      INSERT_OPPONENT_RES=$($PSQL "INSERT INTO teams(name) values ('$OPPONENT')")
      if [[ $INSERT_WINNER_RESULT == "INSERT 0 1" ]]
        then
          echo "Inserted into opponent teams, $OPPONENT $YEAR"
      fi

      # get new opponent team_ID
      O_TEAMS_ID=$($PSQL "SELECT team_id from teams where name='$OPPONENT'")

    fi

    # insert games
    INSERT_GAMES_RES=$($PSQL "INSERT INTO games(year,round,winner_goals,opponent_goals,winner_id,opponent_id) values ('$YEAR','$ROUND',$WINNER_GOALS,$OPPONENT_GOALS,'$W_TEAMS_ID','$O_TEAMS_ID')")
      if [[ $INSERT_WINNER_RESULT == "INSERT 0 1" ]]
        then
          echo "Inserted into games, $YEAR $ROUND $WINNER $OPPONENT $WINNER_GOALS $OPPONENT_GOALS"
      fi
  fi

done
