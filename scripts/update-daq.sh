#! /bin/sh 


name=`mktemp` 

cat > $name << EOL 

#! /bin/sh
#THIS SCRIPT WAS GENERATED AS PART OF A REMOTE DAQ UPDATE
#IT MIGHT BE OVERWRITTEN WITHOUT WARNING

# get sudo priviliges at the beginning
cat /STATION_ID
sudo hostname
cd $HOME/librno-g
git checkout master
git pull 
make daq
sudo make install-daq

cd $HOME/rno-g-ice-software
git checkout master
git pull
make
sudo make install
# make cfg-install #in some cases 
EOL

scp $name $1:/.remote-daq-update.sh 
ssh -t $1 ./.remote-daq-update.sh

rm $name

