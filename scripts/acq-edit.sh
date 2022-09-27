#! /bin/sh

dest=`mktemp`-$1
dest_check=`mktemp`
scp $1:/rno-g/cfg/acq.cfg $dest 

#make a copy so we can see if changed
cp $dest $dest_check 

#default to everyone's preferred editor if EDITOR is not dfined
edit=${EDITOR:-vim} 


$edit $dest 
diff $dest $dest_check  
changed=$? 


if [ $changed  -ne 0 ] ; then 
  read -p "Are you sure you want to upload your config to $1? (y/N) " -n1 -r
  echo 
  if [[ $REPLY =~ ^[Yy]$ ]] 
  then
    scp $dest $1:/rno-g/cfg/acq.cfg
  fi
else 
  echo "no change!" 
fi 

rm -f $dest $dest_check 

 

