#! /bin/sh 


name=`mktemp` 
update_cfg=${2-0} 

cat > $name << EOL 

#! /bin/sh
#THIS SCRIPT WAS GENERATED AS PART OF A REMOTE DAQ UPDATE
#IT MIGHT BE OVERWRITTEN WITHOUT WARNING

# get sudo privileges at the beginning
cat /STATION_ID
#sudo hostname

#echo "Updating rno-g-BBB scripts"
#cd /home/rno-g/rno-g-BBB-scripts
#git pull
#sudo make install

cd /home/rno-g/librno-g
git checkout master
git pull origin master
make daq
make install-daq

#cd /home/rno-g/rno-g-ice-software
#git checkout master
#git pull
#make
#sudo make install
EOL

if [[ $update_cfg == "1" ]]  
then 
  echo "make cfg-install" >> $name 
fi 

chmod +x $name 

scp -p $name $1:.remote-daq-update.sh 
ssh -t $1 ./.remote-daq-update.sh

rm $name

