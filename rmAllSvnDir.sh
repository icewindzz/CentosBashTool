#!/bin/bash
# this is a script for remove all svn dir 
red=`tput setaf 1`
green=`tput setaf 2`
reset=`tput sgr0`
USAGE="Usage: $0 dir1 dir2 dir3 ... dirN"
if [ "$#" == "0" ];then
    echo "$USAGE"
    exit 1
fi

RmSvnDir()
{
    local myDir=$1
    if [[ $(svn list $(pwd)'/'$myDir 2>&1) =~ ^svn:.*'is not a working copy' ]];then
	echo "${green}$(pwd)/$myDir is not svn dir,ignore${reset}"
	return 0
    fi
    echo "${red}-------------del svn dir $(pwd)/$myDir${NC}${reset}"
    rm -rf $(pwd)'/'$myDir
    return 0
}


while (( "$#" ));do
   if [ -d $1 ];then
       for i in $(ls -lrt|grep -P ^d|awk '{print $9}')
       do
       RmSvnDir $i
       done
   else
       echo $1'is not a valid dir'
   fi
   shift
done





