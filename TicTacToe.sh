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

checkTwo () {
	if [ "$flag" = "player" ]
	then
		return 
	fi
	index1=$1
	index2=$2
	index3=$3
	checkCompWin=$4
	if [ "${board[$index1]}" = "${board[$index2]}" -a "${board[$index1]}" != "-" -a "${board[$index3]}" = "-" -a "${board[$index1]}" = "$checkCompWin" ] 
	then
		board[$index3]=$comp
	 	flag=player
		remMoves=$((remMoves-1))
		printBoard
	fi
	if [ "${board[$index1]}" = "${board[$index3]}" -a "${board[$index1]}" != "-" -a "${board[$index2]}" = "-"  -a "${board[$index1]}" = "$checkCompWin" ]
	then
	 	board[$index2]=$comp
		remMoves=$((remMoves-1))
	 	flag=player
		printBoard
	fi
	if [ "${board[$index3]}" = "${board[$index2]}" -a "${board[$index3]}" != "-" -a "${board[$index1]}" = "-"  -a "${board[$index2]}" = "$checkCompWin" ]
	then
		board[$index1]=$comp
		flag=player
		printBoard
		remMoves=$((remMoves-1))
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

winOrBlock () {
	if [ "$flag" = "player" ]
	then
		return 
	fi
	index1=$1
	index2=$2
	index3=$3
	if [ "${board[$index1]}" = "${board[$index2]}" -a "${board[$index1]}" != "-" -a "${board[$index3]}" = "-" ] 
	then
		board[$index3]=$comp
	 	flag=player
		remMoves=$((remMoves-1))
		printBoard
	fi
	if [ "${board[$index1]}" = "${board[$index3]}" -a "${board[$index1]}" != "-" -a "${board[$index2]}" = "-" ]
	then
	 	board[$index2]=$comp
		remMoves=$((remMoves-1))
	 	flag=player
		printBoard
	fi
	if [ "${board[$index3]}" = "${board[$index2]}" -a "${board[$index3]}" != "-" -a "${board[$index1]}" = "-" ]
	then
		board[$index1]=$comp
		flag=player
		printBoard
		remMoves=$((remMoves-1))
	fi

}

winOrBlock () {
	letter=$1
	checkTwo 0 1 2 $letter
	checkTwo 3 4 5 $letter
	checkTwo 6 7 8 $letter
	checkTwo 0 4 8 $letter
	checkTwo 2 4 6 $letter
	checkTwo 0 3 6 $letter
	checkTwo 1 4 7 $letter
	checkTwo 2 5 8 $letter
	[ "$flag" = "comp" ] && randomPlay || :
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
	elif [ $remMoves -eq 0 ]
	then
		echo Tie
		break
	fi
	play
done

