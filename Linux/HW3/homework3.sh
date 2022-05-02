#!/bin/bash

# ---------------------------------------------------------------------------
# Script to build Roulette Loss Directories and Files for 
# Securtiy Bootcamp Homework 3
# --------------------------------------------------------------------------

echo "Warning - This will Remove all Lucky Duck Directories and Files INCLUDING Notes Files"
read -p "Do you wish to continue (Y/N): " response

if [[ "$reponse" == "N" || "$response" == "n" ]]
then
   echo "OK - Exiting"
   exit 0
elif [[ "$reponse" == "Y" || "$response" == "y" ]]
then
   echo "OK - You have been warned"
else
   echo "Invalid Response - Exiting"
   exit 1
fi

rm -rf Lucky_Duck_Investigations

mkdir -p Lucky_Duck_Investigations/Roulette_Loss_Investigation

cd Lucky_Duck_Investigations/Roulette_Loss_Investigation

mkdir Player_Analysis Dealer_Analysis Player_Dealer_Correlation

touch Player_Analysis/Notes_Player_Analysis
touch Dealer_Analysis/Notes_Dealer_Analysis
touch Player_Dealer_Correlation/Notes_Player_Dealer_Correlation 

cd ..

wget "https://tinyurl.com/3-HW-setup-evidence" 1>/dev/null 2>&1 && chmod +x ./3-HW-setup-evidence && ./3-HW-setup-evidence

for File in $(find Dealer_Schedules_0310 -type f -iname '0310*' -o -iname '0312*' -o -iname '0315*')
do
    mv ${File} Roulette_Loss_Investigation/Dealer_Analysis
done

for File in $(find Roulette_Player_WinLoss_0310 -type f -iname '0310*' -o -iname '0312*' -o -iname '0315*')
do
   mv ${File} Roulette_Loss_Investigation/Player_Analysis
done

# Combine all loss files into one file and cleanup file name using sed so only date from file name is left
# also any line with 6 spaces to a tab to make awk work for all lines
grep '\-\$' ./Roulette_Loss_Investigation/Player_Analysis/* | sed -e 's/.\/Roulette_Loss_Investigation\/Player_Analysis\///' -e 's/_win_loss_player_data/ /' -e 's/      /\t/g' -e 's/ :/\t/' > ./Roulette_Loss_Investigation/Roulette_Losses

# Now flatten out file to include a separate line for day, time, and player
IFS=$'\t'

cp /dev/null ./Roulette_Loss_Investigation/Roulette_Losses_by_Player

while read loss_date loss_time loss_amount loss_players
do
    players_count=$(echo $loss_players | awk -F, '{print NF}')
    players_count=$(($players_count + 0))
    for ((i=1; i<=$players_count; i++))
    do
       player_name="$(echo $loss_players | cut -d "," -f $i | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')"
       echo -e "$loss_date\t$loss_time\t$player_name" >> ./Roulette_Loss_Investigation/Roulette_Losses_by_Player
    done
done < ./Roulette_Loss_Investigation/Roulette_Losses

# Get the total number of times that losses occured
loss_count=$(awk -F'\t' '{print $1,$2}' ./Roulette_Loss_Investigation/Roulette_Losses | wc -l)
echo "Times of Losses = ${loss_count}"

# Get list of Players and count of when they were present and there was a loss
# and print any where the count is > 1
echo
echo "Players Present more than one time when a loss was logged"
echo
awk -F'\t' '{print $3}' ./Roulette_Loss_Investigation/Roulette_Losses_by_Player | sort | uniq -c | awk '$1 > 1 {print $0}'

IFS=$' '

touch ./Roulette_Loss_Investigation/Dealer_Analysis/Dealers_working_during_losses

# Run roulette_dealer_finder_by_time.sh for each Day and Time of losses
while read params
do
    ../roulette_dealer_finder_by_time.sh $params >> ./Roulette_Loss_Investigation/Dealer_Analysis/Dealers_working_during_losses
done < <(awk -F'\t' '{print $1" "$2}' ./Roulette_Loss_Investigation/Roulette_Losses_by_Player | sort | uniq)

echo
echo "Dealers working the Roulette Table During the Loss Times"
echo 

sort ./Roulette_Loss_Investigation/Dealer_Analysis/Dealers_working_during_losses | uniq

echo
echo
echo "Copying Files to Player_Dealer_Correlation directory"
echo

# Copy files that I stuffed a couple directories up to preserve when this script runs
cp ../Notes_Dealer_Analysis ./Roulette_Loss_Investigation/Player_Dealer_Correlation
cp ../Notes_Player_Analysis ./Roulette_Loss_Investigation/Player_Dealer_Correlation
cp ../Notes_Player_Dealer_Correlation ./Roulette_Loss_Investigation/Player_Dealer_Correlation

mv ./Roulette_Loss_Investigation/Roulette_Losses_by_Player ./Roulette_Loss_Investigation/Player_Dealer_Correlation
mv ./Roulette_Loss_Investigation/Roulette_Losses ./Roulette_Loss_Investigation/Player_Dealer_Correlation
mv ./Roulette_Loss_Investigation/Dealer_Analysis/Dealers_working_during_losses ./Roulette_Loss_Investigation/Player_Dealer_Correlation

cp ../homework3.sh ./Roulette_Loss_Investigation/Player_Dealer_Correlation
cp ../roulette_dealer_finder_by_time_and_game.sh ./Roulette_Loss_Investigation/Player_Dealer_Correlation
cp ../roulette_dealer_finder_by_time.sh ./Roulette_Loss_Investigation/Player_Dealer_Correlation

# zip up Player_Dealer_Correlation directory
echo "Creating ZIP file"
zip -r ../Player_Dealer_Correlation.zip ./Roulette_Loss_Investigation/Player_Dealer_Correlation 1>/dev/null 2>&1

exit 0
