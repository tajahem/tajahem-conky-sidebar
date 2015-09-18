#tajahem_sidebar conky theme
---
<img style="float: right" src="tajahem_sidebar.jpg">

##Description

A simple conky theme with custom scripts to parse and display weather and cpu temperature data. Note: weather data is checked every 15 minutes by default. 

Requires:

* [conky](conky.sourceforge.net)
* [weather-util](fungi.yuggoth.org/weather/)
* lm-sensors

##Installation

If you do not already have them you will need conky, weather-util, and lm-sensors. Links are above or if you're on Ubuntu:

`sudo apt-get install conky weather-util lm-sensors`

Next download the tajahem_sidebar files from the repository and unzip them into the conky directory (typically _"HOME/.conky"_). Unless you are using [Conky Theme Manager](teejeetech.in/p/conky-manager.html); the hidden file **.conkyrc** and the **scripts** folder should be in the root of the .conky directory (you may have to overwrite the default .conkyrc file). 

##Customization

If you are on a system that has sed you can run the commands in the examples; otherwise use whatever find and replace utility you prefer. _Note: the example commands assume your current working directory is the directory containing tajahem_sidebar's .conkyrc file._

###Weather
Check the weather FAQ or the weather-util man page for information on finding your weather station. Once you've got it replace KOGA in .conkyrc with your station id (US zipcodes work sometimes)

example: `sed -i "s/KOGA/69138/g" .conkyrc`

###Name
Replace |Ta Jahem| with your desired static header information

example: `sed -i "s/|Ta Jahem|/Bob the Terrible/g" .conkyrc`

###Fonts 
Replace DejaVu Sans with your prefered font. While the weather, name and colors are simple to edit manualy, I definately recommend using a find and replace tool for this one as you have to change the xftfont option and every occurance of the font in the TEXT section.

example: `sed -i "s/DejaVu Sans/Ubuntu Mono/g" .conkyrc`

###Colors
Open up the .conkyrc file in your favorite text editor and scroll down to the #colors section. Replace the default colors with either a hexidecimal color code or any [color name recognized by x11](wikipedia.org/wiki/X11_color_names#Color_name_chart) The default background color is supposed to be transparent by default (own_window_transparent yes), but you can change it by setting this to no (line 22).