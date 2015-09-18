#!/bin/bash
#################################################
#						#
#    	Script to parse and format weather 	#
#	data for tajahem_sidebar conky theme	#
#	Author: Ta Jahem 			#
#	Version: 1.1				#
#						#
#################################################

output_string=			#output vairable
font_style=$1			#font style needed when changing font sizes
weather=$(weather -q $2)	#weather data to parse
declare -a details=() 		#weather details (lightning, hail, etc)

#search strings
f_search_string="(?<=Temperature: )\d{1,3}.\d F"
sky_search_string="(?<=Sky conditions: )([a-z]{1,} {0,1}){1,2}"
w_search_string="(?<=Weather: ).*(?= Sky conditions:)"

#send an arg to use secondary color
function tag_color() {
  if [ -z "$1" ] ; then
    output_string+="\${color}"
  else
    output_string+="\${color1}"
  fi
}

function tag_font() {
  output_string+="\${font $font_style:size=$1}"
}

#splits weather details at ';'
function split_details() {
  local field1="$(echo "$1" | cut -f1 -d';')"
  local field2="$(echo "$1" | cut -f2- -d';')"
  if [ "$field1" == "$field2" ]
    then
      details+=("$field1")
  else
    while [ -n "$field1" ] && [ "$field1" != "\n" ]
    do
      details+=("$field1")
      field1="$(echo "$field2" | cut -f1 -d';')"
      field2="$(echo "$field2" | cut -f2- -d';')"
      if [ "$field1" == "$field2" ]
	then
	  details+=("$field1")
	  field1="" #kill the while loop
      fi
    done
  fi
}

#parses temperature data
function append_temperature() {
  f_temp=$(echo $weather | grep -Po "$f_search_string")
  c_temp=$(echo $weather | grep -Po "(?<=Temperature: $f_temp )\(\d{1,3}.\d C\)")
  # this version required to prevent duplicates during heat advisories

  # add fahrenheit temperature
  tag_font 10
  tag_color "y"
  output_string+="\${alignc}$f_temp"
  
  # add celcius temperature
  tag_font 7
  tag_color
  output_string+=" $c_temp\n"
}

#parses sky conditions
function append_sky_cond() {
  sky_cond=$(echo $weather | grep -Po "$sky_search_string" )
  output_string+="\${alignc}$sky_cond"
}

#parses for weather details (fog, thunderstorms, etc)
function append_weather_details() {
  full_details=$(echo $weather | grep -Po "$w_search_string")
  split_details "$full_details"
  if [ "${#details[@]}" -gt 0 ] && [ -n "${details[0]}" ]
    then 
      get_color "y"
      for i in "${details[@]}"
      do
	output_string+="\n"
	#to lower case w/o leading whitespace
	output_string+=$(echo ${i,,} | xargs | fmt -35 )
      done
  fi
}

append_temperature
append_sky_cond
append_weather_details
echo -e $output_string
