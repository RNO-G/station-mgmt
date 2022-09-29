#! /bin/bash

dest=`mktemp`-$1
dest_check=`mktemp`

if [ -z $1 ] ; 
then 
  echo "Usage: ./acq_edit.sh host"
  exit 1 
fi 

scp $1:/rno-g/cfg/acq.cfg $dest 

#make a copy so we can see if changed
cp $dest $dest_check 

#default to everyone's preferred editor if EDITOR is not dfined
edit=${EDITOR:-vim} 


$edit $dest 
diff $dest $dest_check  
changed=$? 


if [ $changed  -ne 0 ] ; then 
  echo "Are you sure you want to upload your config to $1? (y/N) "
  read -p "(y/N) " -r
  echo 
  if [[ $REPLY =~ ^[Yy]$ ]] 
  then
    echo "If you want this to be a persistent config, type the word 'persistent'"
    echo "Otherwise this will be treated as a one-time config, for which you may enter an identifiying tag (e.g. calib_092922) or have one generated for you if left blank."
    read -r
    echo 
    if [[ "$REPLY" == "persistent" ]] 
    then 
      echo "Copying persistent config" 
      scp $dest $1:/rno-g/cfg/acq.cfg
    elif [ -z $REPLY ] 
    then 
      outname=`date -Is`.cfg 
      echo "Using name $outname"
      scp $dest $1:/rno-g/cfg/acq.cfg.once/$outname 
    else 
      outname="$REPLY.cfg"
      echo "Using name $outname"
      scp $dest $1:/rno-g/cfg/acq.cfg.once/$outname
    fi 
  fi
else 
  echo "no change!" 
fi 

rm -f $dest $dest_check 

 

