#!/usr/bin/env bash

function run {
	if ! pgrep $1 ;
	then
		$@&
	fi
}

run picom &
run cbatticon &
run gvolicon &
run nm-tray &
