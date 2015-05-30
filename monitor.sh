#!/bin/sh

abort(){
	echo $@
	exit 1
}

monitor(){
	temp_file="` mktemp /tmp/monitor.XXXXXX`"
	cp "$1" "$temp_file"
	trap "rm $temp_file; exit 1" 2
	while : ; do
		if [ "$1" -nt "$temp_file" ]; then
			cp "$1" "$temp_file"
			$2
		fi
		sleep 2
	done
}

file_name=$1
shift
command=$*
if [[ -z "$file_name" ]]; then
	abort "ParseError: File to be monitored is not specified as an argument"

fi

if [[ -z "$command" ]]; then
	abort "PareseError: Command not specified."
fi

if [ ${file_name:-4} == "*.sw[px]" ];then
	abort ""
else
	monitor $file_name $command
fi
