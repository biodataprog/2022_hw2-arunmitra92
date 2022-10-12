#!/bin/bash -l

# step to write
# download the CSV file
# curl -o calfire.csv ...

curl -o calfile.csv https://gis.data.cnra.ca.gov/datasets/CALFIRE-Forestry::recent-large-fire-perimeters-5000-acres.csv

# print out the range of years found -- you may need to go in and edit the file
# cut -d, ....
# Arun Mitra - i edited the file to remove quotes around the comments for rows 10 and 11. that fixed the issue of the weird numbers popping up in year.

MINYEAR=`awk -F, '{print $2}' calfile.csv | sort -n | sed '1d' | head -n 1`
MAXYEAR=`awk -F, '{print $2}' calfile.csv | sort -n | tail -n 1`
# write code to set these variables with the smallest and largest years
echo "This report has the years: $MINYEAR-$MAXYEAR"
# if you have problems the CSV file already part of this repository so you can use 'calfires_2021.csv'

# print out the total number of fires (remember to remove the header line)
TOTALFILECOUNT=`tail -n +2 calfile.csv | wc -l`
# put your code here to update this variable
echo "Total number of files: $TOTALFILECOUNT"

# print out the number of fire in each year
echo "Number of fires in each year follows:"
awk -F, '{print $2}' calfile.csv | tail -n +2 | sort -n | uniq -c

# print out the name of the largest file use the GIS_ACRES and report the number of acres
LARGEST=`awk -F, '{print $13, $6}' calfile.csv | sort -nr | awk '{print $2, $3}' | head -n 1`
LARGESTACRES=`awk -F, '{print $13}' calfile.csv | sort -nr | head -n 1`
YEAR=`awk -F, '{print $13, $6, $2}' calfile.csv | sort -nr | awk '{print $4}' | head -n 1`
echo "Largest fire was $LARGEST and burned $LARGESTACRES acres in $YEAR."

# print out the years - change the code in $(echo 1990) to print out the years (hint - how did you get MINYEAR and MAXYEAR?
for YEAR in `awk -F, '{print $2}' calfile.csv | sort -n | uniq | sed '1d'`
do
      TOTAL=`awk -F, '{print $2, $13}' calfile.csv | sort -n | grep $YEAR | awk '{sum+=$2;} END{print sum;}'`
      echo "In Year $YEAR, Total was $TOTAL"
done
#the for loop here does not give the correct sums. it seems there might be more errors in the file?
