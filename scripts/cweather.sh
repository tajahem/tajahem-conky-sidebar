#!/bin/bash

#########################################################
#							#
#    	Script to parse and format weather data for	#
#    	tajahem_sidebar conky theme. 						#
#	Author: Ta Jahem 				#
#	Version: 1.0					#
#	Sat September 12 2015				#
#							#
#########################################################


output_string=
font_style=$1
weather=$(weather -q $2)
declare -a details=()

#search strings
f_search_string="(?<=Temperature: )\d{1,3}.\d F"
sky_search_string="(?<=Sky conditions: )([a-z]{1,} {0,1}){1,2}"
w_search_string="(?<=Weather: ).*(?= Sky conditions:)"

#arg use secondary color
function get_color() {
  if [ -z "$1" ] ; then
      output_string+="\${color}"
  else
    output_string+="\${color1}"
  fi
}

#arg - font size
function style_font() {
  output_string+="\${font $font_style:size=$1}"
}

#splits weather details at ';' so that each can be on a separate line
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
function get_temp() {
  f_temp=$(echo $weather | grep -Po "$f_search_string")
  # this version required to prevent duplicates during heat advisories
  c_temp=$(echo $weather | grep -Po "(?<=Temperature: $f_temp )\(\d{1,3}.\d C\)")

  style_font 10
  get_color "y"
  output_string+="\${alignc}$f_temp"
  style_font 7
  get_color
  output_string+=" $c_temp\n"
}

#parses sky conditions
function get_sky() {
  sky_cond=$(echo $weather | grep -Po "$sky_search_string" )
  output_string+="\${alignc}$sky_cond"
}

#parses for weather details (fog, thunderstorms, etc)
function get_details() {
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

get_temp
get_sky
get_details

echo -e $output_string
