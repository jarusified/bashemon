#!/bin/sh

file_name=$1
shift
command=$*
if [[ -z "$file_name" ]]; then
	echo >&2 "ParseError: File to be monitored is not specified as an argument"
	exit 1
fi
if [[ -z "$command" ]]; then
	echo >&2 "PareseError: Command not specified."
	exit 1
fi
temp_file="` mktemp /tmp/monitor.XXXXXX`"
cp "$file_name" "$temp_file"
trap "rm $temp_file; exit 1" 2
while : ; do
	if [ "$file_name" -nt "$temp_file" ]; then
		cp "$file_name" "$temp_file"
		$command
	fi
	sleep 2
done
