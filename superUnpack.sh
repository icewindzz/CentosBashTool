#!/bin/bash

INPUTFILE=''
unpackZip()
{
    local zipFile=$1
    local dirName=${zipFile%.zip}
    unzip $zipFile -d $dirName
    unpackDir $dirName
    if [[ $zipFile != $INPUTFILE ]]
    then
	rm $zipFile
    fi
}

unpackTar()
{
  local dirName
  local tarFile=$1
  if [[ $1 =~ .*\.tar$ ]]
  then
      dirName=${tarFile%.tar}
      mkdir $dirName
      tar -xvf $tarFile -C $dirName
  fi
  if [[ $i =~ .*\.tgz$ ]]
  then
      dirName=${tarFile%.tgz}
      mkdir $dirName
      tar -zxvf $tarFile -C $dirName
  fi 
  if [[ $1 =~ .*\.tar\.gz$ ]]
  then
      dirName=${tarFile%.tar.gz}
      mkdir $dirName
      tar -zxvf $tarFile -C $dirName
  fi
  if [[ $1 =~ .*\.tar\.xz$ ]]
  then
      dirName=${tarFile%.tar.xz}
      mkdir $dirName
      tar -xJvf $tarFile -C $dirName
  fi
  if [[ $1 =~ .*\.tar\.bz2$ ]]
  then
      dirName=${tarFile%.tar.bz2}
      mkdir $dirName
      tar -xjvf $tarFile -C $dirName
  fi
  unpackDir $dirName
  if [[ -f $tarFile && $tarFile != $INPUTFILE ]]
  then
  rm $tarFile
  fi
        
}

unpackXZ()
{
  local xzFile=$1
  xz -d $xzFile
  maydir=${xzFile%.xz}
  if [[ -d $maydir ]]
  then
      unpackDir $dirName
      return
  fi
  
}

unpackGZ()
{ 
  local gzFile=$1
  gzip -d $gzFile
  maydir=${gzFile%.gz}
  if [[ -d $maydir ]]
  then
      unpackDir $dirName
      return
  fi
  
}

unpackBZ2()
{
    local bz2File=$1
    bzip2 -d $bz2File
    maydir=${bz2File%.bz2}
    if [[ -d $maydir ]]
    then
	unpackDir $dirName
	return
    fi
  
}
unpackZ()
{
    Local dirName
    local zFile=$1
    uncompress $zFile
    maydir=${zFile%.z}
    if [[ -d $maydir ]]
    then
	unpackDir $dirName
	return
    fi
  
}

unpackDir()
{
    if [[ ! -d $1 ]]
    then
	echo "$1 is not dir do nothing!"
	return 
    fi
    # change that windows file name that include blank to "_"
    for file in $1/*; 
    do
	dist=$(echo $file | tr ' ' '_')
	if [[ $file == $dist ]]
	then
	    continue
	fi
	mv "$file" $dist  
    done

    for i in $(ls $1)
    do
	if [[ -d $1/$i ]]
	then
	    unpackDir $1/$i &
	    continue
	fi
	if [[ $i =~ .*\.tar || $i =~ .*\.tgz$ ]]
	then
	    
	    unpackTar $1/$i & 
	    continue
	fi
	if [[ $i =~ .*\.xz$ ]]
	then
	    unpackXZ $1/$i &
	    continue
	fi
	if [[ $i =~ .*\.gz$ ]]
	then
	    unpackGZ $1/$i &
	    continue
	fi
	if [[ $i =~ .*\.bz2$ ]]
	then
	    unpackBZ2 $1/$i &
	    continue
	fi
	if [[ $i =~ .*\.zip$ ]]
	then
	    unpackZip $1/$i &
	    continue
	fi
	if [[ $i =~ .*\.z$ ]]
	then
	    unpackZ $1/$i &
	    continue
	fi
    done
    for job in `jobs -p`
    do
	wait $job
    done
}




if [[ ! -f $1 ]]
then
    echo "$1 is not existed!!"
    exit 0;
fi

curDir=$(pwd)
absPathFile=''
if [[ $1 =~ ^\/.+$ ]]
then
    absPathFile=$1
else
    absPathFile=$curDir/$1
fi

INPUTFILE=$absPathFile

if [[ $1 =~ .*\.zip ]]
then
    echo "start unpack snapShot file $absPathFile"
    unpackZip $absPathFile
    echo "done!"
    exit 0
fi

if [[ $1 =~ .*\.tar || $1 =~ .*\.tgz ]]
then
    echo "start unpack snapShot file $absPathFile"
    unpackTar $absPathFile
    exit 0
fi

echo "unsupported snapshot file type !!!"