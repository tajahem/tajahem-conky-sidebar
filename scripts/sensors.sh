#!/bin/bash
#################################################
#						#
#    	Script to parse, and format lmsensor 	#
#	temperature data for conky.		#
#	Author: Ta Jahem  			#
#    	Version: 1.1				#
#						#
#################################################

output_string=        		#output variable
sensor_data=$(sensors) 		#sensor data to parse
core=0				#current core

function get_search_string() {
	echo "(?<=Core $1:\s\Q+\E)\d{1,3}"
}

core_temp=$(echo $sensor_data | grep -Po "$(get_search_string $core)")

while [ -n "$core_temp" ] ; do
	#add newlines between cores
	if [ $core -ne "0" ] ; then
		output_string+="\n"
	fi
	output_string+="\${color}Core $core Temp: \${alignr}\${color1} $core_temp°C"
	(( core+=1 ))
	core_temp=$(echo $sensor_data | grep -Po "$(get_search_string $core)")
done

echo -e "$output_string"
