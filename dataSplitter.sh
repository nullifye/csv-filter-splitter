#!/bin/bash
RED='\033[0;31m'
CYAN='\033[0;92m'
BBLUE='\033[0;5;34m'
LBLUE='\033[1;34m'
YLW='\033[1;33m'
BGRED='\033[1;41m'
NC='\033[0m'

PM[0]="AA"
PM[1]="BB"
PM[2]="CC"
PM[3]="DD"
PM[4]="EE"

echo
echo -e "  ${RED}Data Splitter${NC}"
echo -e "  Version 3"
echo -e "  ${LBLUE}t.me/mohdrafhan${NC}"
echo

if [[ -z "$1" || -z "$2" ]]; then
	echo -e "Usage: $0 ${BGRED}SOURCE${NC} ${BGRED}FILTERS${NC} [${BGRED}-d${NC}]"
	exit 1
fi
if [ ! -r $1 ]; then
	echo -e " ${RED}Source file not found!${NC}"
	echo " Please check your file path."
	exit 1
fi
if [ ! -r $2 ]; then
	echo -e " ${RED}Filters file not found!${NC}"
	echo " Please check your file path."
	exit 1
fi

DTL="progressbar"
case "$3" in
	-d) DTL="list"
	;;
esac

read -p "Output folder name: " OUTD

if [[ -z "$OUTD" ]]; then
  OUTD="data_splitter_result"
fi
mkdir -p "$OUTD"
echo -e "Files will be saved at ${YLW}$PWD/$OUTD${NC}"
echo

CTR=0
LOC=$(( $(wc -l < $2) - 1 ))

function ProgressBar {
	let _progress=(${1}*100/${2}*100)/100
	let _done=(${_progress}*4)/10
	let _left=40-$_done
	_done=$(printf "%${_done}s")
	_left=$(printf "%${_left}s")

	printf "\r Progress: [${_done// /#}${_left// /-}] ${_progress}%%"
}

function CreateFolder {
	DTC="$OUTD"
	if [ "$#" -lt 2 ]; then
		_oneandonly=$1
		echo "$DTC/${_oneandonly//\"}.csv"
	else
		for k in ${@:1:$(($#-1))}; do
			DTC="$DTC/${k//\"}"
			mkdir -p $DTC
		done
		_last=${!#}
		_secondlast=${@: -2:1}
		echo "$DTC/${_secondlast//\"}_${_last//\"}.csv"
	fi
}

echo -e "-- ${BBLUE}PROCESSING${NC} --"
IFS=$'\n'; for i in $(cat $2); do
	IFS="," read -ra FLTR <<< "$i"

	#read column indexes
	if [ $CTR -eq 0 ]; then
		for j in ${!FLTR[@]}; do
			AWKCMD="$AWKCMD(${FLTR[j]}~${PM[j]}) && "
		done
		AWKCMD=${AWKCMD%???}
		AWKCMD="$AWKCMD{print}"
	else
		#add new filter(s) here if applicable
		F_1=${FLTR[0]}
		F_2=${FLTR[1]}
		F_3=${FLTR[2]}
		F_4=${FLTR[3]}
		F_5=${FLTR[4]}

		#add new folder(s) here if applicable
		OUT=$(CreateFolder $F_1 $F_2 $F_3 $F_4 $F_5)

		#change filter(s) below if applicable
		awk -F"," -v AA="$F_1" -v BB="$F_2" -v CC="$F_3" -v DD="$F_4" -v EE="$F_5" $AWKCMD $1 > "$OUT"

		#insert header
    sed -i "1i$(head -n 1 $1)" $OUT

		if [ $DTL == "list" ]; then
			let PRS=(${CTR}*100/${LOC}*100)/100
			printf "${RED}%4s${NC}/%s  %3s%%  $i\n" $CTR $LOC $PRS
		else
			ProgressBar ${CTR} ${LOC}
		fi
	fi

	CTR=$((CTR+1))
done

if [ $DTL != "list" ]; then
	echo
fi
echo "-- FINISH --"
