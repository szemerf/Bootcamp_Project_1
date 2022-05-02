#!/bin/bash

if [ $# -ne 4 ] 
then
   echo "Usage: roulette_dealer_finder_by_time.sh game date time (in format MMDD and HH:MM:SS AM/PM)"
   echo "       game = 'R' (Roulette), 'B' (BlackJack), 'T' (Texas Hold Em)"
   exit 1
fi

p_game=$1
p_date=$2
p_time="$3 $4"

case $p_game in
   B)
     column_num=2
     ;;
   R)
     column_num=3
     ;;
   T)
     column_num=4
     ;;
   *)
     echo "Invalid Game - Exiting"
     exit 1
     ;;
esac

grep "${p_time}" ./Roulette_Loss_Investigation/Dealer_Analysis/"${p_date}"_Dealer_schedule | awk -v col=$column_num -F'\t' '{print $col}'
