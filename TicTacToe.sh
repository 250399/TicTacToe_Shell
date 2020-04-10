#!/bin/bash


flag=player
remMoves=9
tossFlag=0
invalidCharacterFlag=0


reset () {
	echo Welcome to TicTacToe Program!
	board=(- - - - - - - - -)
}

checkToss () {
	if [ $tossFlag -eq 1 ]
	then
		read -p"Invalid choice! Please enter between 0 and 1:  " toss
	else
		read -p"Enter 1 or 0 for a toss:  " toss
		tossFlag=1
	fi
	if (($toss != 1 && $toss != 0 ))
	then
		checkToss
	else
		if [ $((RANDOM%2)) -eq $toss ]
		then
			turn=player
			echo You won the toss

		else
			turn=comp
			echo You lost the toss

		fi

	fi
}

firstPlay () {
	if [ "$turn" = "player" ]
	then
		if [ $invalidCharacterFlag -eq 1 ]
		then
			read -p"Invalid Choice! Please choose between X and O:  " player
		else
			read -p"Please choose X or O:  " player
		fi
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
			invalidCharacterFlag=1

			firstPlay
			return
		fi
	else
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
	echo "The comp is "$comp
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
	if [ "${board[$index3]}" = "${board[$index2]}" -a "${board[$index3]}" = "$letter" -a "${board[$index1]}" = "-" ] 
	then
		board[$index1]=$comp
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


swap () {
	temp=${permuteArray[$1]}
	permuteArray[$1]=${permuteArray[$2]}
	permuteArray[$2]=$temp
}

permute () {
	if [ $pflag -eq 0 ]
	then
	 	permuteArray=( $1 $2 $3 )
		pflag=1
	fi
	local low=$4
	local length=$5
	if [ $low -eq $length ] 
	then
		checkTwo ${permuteArray[@]} $letter
		return
	else
		for ((i=0;i<=$length;i++))
		do
			swap $i $low
			permute ${p[@]} $((low+1)) $length
			swap $i $low
		done
	fi
}


winOrBlock () {
	letter=$1
	for ((checkRowColumn=0;checkRowColumn<3;checkRowColumn++))
	do
		pflag=0
		permute $((0+3*checkRowColumn)) $((1+3*checkRowColumn)) $((2+3*checkRowColumn)) 0 2
		pflag=0
		permute $((0+checkRowColumn)) $((3+checkRowColumn)) $((6+checkRowColumn)) 0 2
	done
	pflag=0
	permute 0 4 8 0 2
	pflag=0
	permute 6 4 2 0 2
}

printBoard () {
	for i in {0..8}
	do
		[ $i -eq 2 -o $i -eq 5 ] && echo ${board[$i]} || echo -n ${board[$i]}
	done
	echo
}

playMove () {
	if [ "$flag" =  "player" ]
	then
	read -p"Enter position" position
	if [[ "${board[$((position-1))]}" == "-" && $position =~ ^[1-9]$ ]] 
	then
	 	board[$((position-1))]=$player
		remMoves=$((remMoves-1))
		printBoard
	else
	 	echo "Please enter valid location"
		printBoard
		playMove
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
	elif [ $difficulty -eq 1 ]
	then
		randomPlay
	else
		echo Invalid option
	fi
}

returnWinner () {
	while true
	do
		if [ $remMoves -lt 5 ]
		then
			for((positions=0;positions<3;positions++))
			do
				checkWinner $((0+3*positions)) $((1+3*positions)) $((2+3*positions))
				checkWinner $((0+positions)) $((3+positions)) $((6+positions))
			done
		checkWinner 2 4 6
		checkWinner 0 4 8
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
		playMove
	done


}

read -p"Enter difficulty 1.Easy 2.Hard" difficulty
if [ $difficulty -eq 1 -o $difficulty -eq 2 ]
then
	:
else
	echo Invalid Choice
	exit

fi

reset
checkToss
firstPlay
printBoard
returnWinner

