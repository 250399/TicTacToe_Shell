#!/bin/bash


reset () {
	echo Welcome to TicTacToe Program!
	board=(- - - - - - - - -)
}

firstPlay () {
	read -p"Enter 1 or 0 for a toss " toss
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
		fi
	else
		echo You lost the toss
		[ $((RANDOM%2)) -eq 1 ] && comp=X  || comp=O
		if [ "$comp" = "X" ]
		then
			player=O 
			flag=comp
		else
			player=X
			flag=player
		fi
	fi
	echo "The comp has choosen "$comp
	echo "You are "$player
}

checkWinner () {
	if [ "${board[$1]}" = "${board[$2]}" -a "${board[$2]}" = "${board[$3]}" -a "${board[$1]}" != "-" ] 
	then
		winner=${board[$1]} 
	fi
}

printBoard () {
	for i in {0..8}
	do
		[ $i -eq 2 -o $i -eq 5 ] && echo ${board[$i]} || echo -n ${board[$i]}
	done
	echo
}

play () {
	if [ "$flag" =  "player" ]
	then
	read -p"Enter position" position
	if [ "${board[$((position-1))]}" = "-" ] 
	then
	 	board[$((position-1))]=$player
		remMoves=$((remMoves-1))
		printBoard
	else
	 	echo "Please enter any another locaation"
		printBoard
		play
	fi
	flag=comp
	else
	pos=$((RANDOM%9))
	if [ "${board[$pos]}" = "-" ] 
	then 
		board[$pos]=$comp 
		remMoves=$((remMoves-1))
	else
		play
		remMoves=$((remMoves-1))
	fi 
	flag=player
	fi
	printBoard
}
flag=player
remMoves=9
reset
firstPlay
printBoard
while true
do
	if [ $remMoves -lt 5 ]
	then
		checkWinner 0 1 2
		checkWinner 3 4 5
		checkWinner 6 7 8
		checkWinner 0 4 8
		checkWinner 2 4 6
		checkWinner 0 3 6
		checkWinner 1 4 7
		checkWinner 2 5 8
		if [ "$winner" = "X" -o "$winner" = "O" ]
		then
			echo $winner won
			break
		fi
	elif [ $remMoves -eq 0 ]
	then
		echo Tie
		break
	fi
	play
done

