#!/bin/bash


reset () {
	echo Welcome to TicTacToe Program!
	arr=(- - - - - - - - -)
	firstPlay
}

firstPlay () {
	read -p"Enter 1 or 0 for a toss " toss
	[ $toss -eq 1 -o $toss -eq 0 ] && : || reset
	if [ $((RANDOM%2)) -eq $toss ]
	then
		echo You won the toss
		read -p"Please choose X or O" player
		player=${player^^}
		if [ "$player" = "X" ]
		then
			comp=O
			flag=player 
		elif [ "$player" = "O" ]
		then
			comp=X
			flag=comp
		else
			echo invalid choice
			reset
			return
		fi
	else
		echo You lost the toss
		if [ $((RANDOM%2)) -eq 1 ]
		then
			comp=X
			player=O
			flag=com
		else
			comp=O
			player=X
			flag=player
		fi
	fi
	echo "The comp is "$comp
	echo "You are "$player
}

printBoard () {
	for tempIndex in {0..8}
	do
		[ $tempIndex -eq 2 -o $tempIndex -eq 5 ] && echo ${arr[$tempIndex]} || echo -n ${arr[$tempIndex]}
	done
	echo
}


reset
printBoard
