#!/bin/bash

if [ $# -ne 3 ] 
then
   echo "Usage: roulette_dealer_finder_by_time.sh date time (in format MMDD and HH:MM:SS AM/PM)"
   exit 1
fi

p_date=$1
p_time="$2 $3"

grep "${p_time}" ./Roulette_Loss_Investigation/Dealer_Analysis/"${p_date}"_Dealer_schedule | awk -F'\t' '{print $3}'
