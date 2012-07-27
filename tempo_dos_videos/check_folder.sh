#!/bin/bash
workdir=`dirname $(readlink -f $0)`
tmp="${workdir}/tmp"
html="${workdir}/result.html"

if [ ! -z "$1" ]; then

	tmp="movies.tmp"
	find "$1" -name \* |sort > $tmp

	if [ -s "$tmp" ]; then

		arquivos="0"

		cat <<-eof > $html
		<html><head><title>Result for `basename "$1"`</title><meta charset="utf-8"></head>
		<body><table border="1" align="center">
		eof

		while read video; do
			videos="${videos}${video}"
			if [ -f "$video" ]; then
				let arquivos++
				
				size=`du -sh "$video" |cut -f1`
				LEN=`mplayer -vo /dev/null -ao /dev/null -identify "$video" 2> /dev/null |grep ^ID_LENGTH| sed -e 's/ID_LENGTH=//g'`
				HR=`echo "$LEN/3600" |bc`
				MIN=`echo "($LEN-$HR*3600)/60" |bc`
				SEC=`echo "$LEN%60" |bc |cut -d'.' -f1`
				
				if [ "$SEC" -lt "10" ]; then
					SEC="0${SEC}"
				fi
				time="${HR}:${MIN}:${SEC}"

				echo "<tr><td> $size </td><td> $time </td><td> `basename \"${video}\"` </td></tr>" >> $html
			else
				echo "<tr><th colspan=\"3\"> `basename \"${video}\"` </th></tr>" >> $html
			fi
		done < $tmp

		echo "</table>" >> $html
		cat <<-eof >> $html
		<p align=center><font face="georgia">Generated at `date`</font></p>
		</body></html>
		eof
	fi
	
else
	echo \# use $0 "<pasta>"
fi