#!/bin/bash
red=`tput setaf 1`
green=`tput setaf 2`
yellow=`tput setaf 3`
blue=`tput setaf 4`
reset=`tput sgr0`
dirNo=0
USAGE="$0 <dir> <file to save info>"

addDirToCedet()
{
    if [ $# -lt 2 ];then
	echo ${red}$USAGE${reset}
    fi
    for i in $(ls $1); do
	if [ -d $1'/'$i ];then
	    if [[ $1/$i =~ ^/ ]];then
		echo "absolute Dir $1/$i"
		myNewDir=$(echo $1/$i|sed "s@$HOME@~@")
	    else
		myDir=$(echo  $(pwd)/$1/$i)
		myNewDir=$(echo $myDir|sed "s@$HOME@~@")
	    fi
	    printf ${blue}.${reset}
	    echo "(semantic-add-system-include " '"'$myNewDir'"' "'c++-mode)">>$2
	    dirNo=$(($dirNo+1))
	    addDirToCedet $1'/'$i $2
	fi
    done
}

addDirToCedet $1 $2
echo ""
echo ${yellow}"total $dirNo dir info added in $2"${reset}
