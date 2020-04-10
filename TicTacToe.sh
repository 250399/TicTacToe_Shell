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

randomPlay () {
	pos=$((RANDOM%9))
	if [ "${board[$pos]}" = "-" ] 
	then 
		board[$pos]=$comp 
		remMoves=$((remMoves-1))
	else
		randomPlay
	fi
	flag=player
	printBoard

}

checkTwo () {
	if [ "$flag" = "player" ]
	then
		return 
	fi
	index1=$1
	index2=$2
	index3=$3
	if [ "${board[$index1]}" = "${board[$index2]}" -a "${board[$index1]}" = "$letter" -a "${board[$index3]}" = "-" ] 
	then
		board[$index3]=$comp
	 	flag=player
		remMoves=$((remMoves-1))
		printBoard
	fi
}

checkCorner () {
	index=0
	declare -A corner
	if [ "$flag" = "player" ]  
	then 
		return 
	fi
	for cornerIndex in 0 2 6 8
	do
		if [ "${board[$cornerIndex]}" = "-" ] 
		then
			corner[$((index++))]=$cornerIndex 
		fi
	done
	length=${#corner[@]}
	echo ${corner[@]}
	if [ $length -eq 0 ]
	then
		return 0
	else
		board[${corner[$((RANDOM%length))]}]=$comp
		remMoves=$((remMoves-1))
		flag=player
		printBoard
	fi
	return 1
}

takeCenter () {
	[ "$flag" = "player" ] && return || :
	[ "${board[4]}" = "-" ] && board[5]=$comp || return
	remMoves=$((remMoves-1))
	flag=player
	printBoard
}

winOrBlock () {
	letter=$1
	checkTwo 0 1 2 $letter
	checkTwo 1 2 0 $letter
	checkTwo 0 2 1 $letter
	checkTwo 3 4 5 $letter
	checkTwo 3 5 4 $letter
	checkTwo 5 4 3 $letter
	checkTwo 6 7 8 $letter
	checkTwo 8 7 6 $letter
	checkTwo 6 8 7 $letter
	checkTwo 0 4 8 $letter
	checkTwo 0 8 4 $letter
	checkTwo 8 4 0 $letter
	checkTwo 2 4 6 $letter
	checkTwo 6 4 2 $letter
	checkTwo 2 6 4 $letter
	checkTwo 0 3 6 $letter
	checkTwo 0 6 3 $letter
	checkTwo 6 3 0 $letter
	checkTwo 1 4 7 $letter
	checkTwo 7 4 1 $letter
	checkTwo 1 7 4 $letter
	checkTwo 2 5 8 $letter
	checkTwo 5 8 2 $letter
	checkTwo 2 8 5 $letter
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
	 	echo "Please enter any another location"
		printBoard
		play
	fi
	flag=comp
	elif [ $difficulty -eq 2 -a "$flag" = "comp" ]
	then
		winOrBlock $comp
		winOrBlock $player
		if [ "$flag" = "comp" ]  
		then
			checkCorner 
		fi
		if [ $? -eq 0 ]
		then
			 takeCenter
		fi
		if [ "$flag" = "comp" ] 
		then
			randomPlay
		fi
	else
		randomPlay
	fi
}

read -p"Enter difficulty 1.Easy 2.Hard" difficulty 
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
	fi
	if [ $remMoves -eq 0 ]
	then
		echo Tie
		break
	fi
	play
done

