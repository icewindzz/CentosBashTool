#!/bin/bash
# this is a script for remove all svn dir 
red=`tput setaf 1`
green=`tput setaf 2`
reset=`tput sgr0`
USAGE="Usage: $0 projName FileNameInProjRootDir"
if [ $# -lt 2 ];then
    echo ${red}"$USAGE"${reset}
    exit 1
fi
if [ ! -f $2 ];then
    echo ${red}"$2 is not exist!!please give the any exist file in root dir of this project!"${reset}
    exit 1
fi
if [[ $2 =~ \.sh$ ]];then
    echo ${red}"$0: please choose other none shell file for root file" ${reset}
    exit
fi
edeProj="ede-cpp-root-project \"$1\" :"
rootFile="file \"$2\""
rootDir=""
createIncludePath()
{   
    dir="$1"
    if [ ! -d $dir ];then
	echo ${red}"$0 : $dir is not dir exit"${reset} 1>$2
	exit 1
    fi
    for i in  $(ls -lrt "$dir"|grep -P ^d|awk '{print $9}')
    do
	includeDir=$(echo $1/$i|sed 's:'$rootDir'::g')
	printf "\n                     \"$includeDir\"\n"
	createIncludePath $1/$i
    done	
}
getFileDir()
{
    local fileName=""
    if [[ $1 =~ ^/ ]];then
	fileName=$(echo $1|awk -F'/' '{print $NF}')
	myDir=$(echo $1|sed 's:/'$fileName'$::g') 
	echo $myDir
	exit 0
    fi
    if [[ $1 =~ ^~ ]];then
	fileName=$(echo $1|awk -F'/' '{print $NF}')
	myDir=$(echo $1|sed 's:/'$fileName'$::g') 
	echo  $myDir
	exit 0
    fi
    myDir=$(pwd)
    echo $myDir
    exit 0
	
}
myDir=$(getFileDir $2)
rootDir=$myDir
myPath=$(createIncludePath $myDir)
includePath="    :include-path '($myPath)"

echo "($edeProj$rootFile"
echo "$includePath)"
