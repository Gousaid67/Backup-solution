#/bin/bash
now=$(date +"%m-%d-%y")
if [ -z "$now" ]; then
  echo "an error occured while trying to retrieve the date, do it without a date? y or n"
  read -r dateerr
  if test "$dateerr" = "y"
  then
   echo we will generate a random number for the file
   now= $RANDOM
   daterr= yes
  else
   echo we are sorry it didnt worked, you can go to the github page to report it
   exit
  fi
fi
echo "hello you wish to do a backup? y or n"
read -r awnser
if test "$awnser" = "y"
then
  echo which folder you want to backup,specify the full path!
  read -r path
  echo OK, would you like it hidden from the user?you will need to do ls -a to see it. y or n
  read -r cloak
  if test "$cloak" = "y"; then
    mkdir ~/.backup
    cd ~/.backup
    tar -zcvf Backup_$now.tar.gz $path
    touch sums_$now.txt
    md5sum Backup_$now.tar.gz > sums_$now.txt 
    touch olddir_$now.txt
    echo $path > olddir_$now.txt
  else
    mkdir ~/backup
    cd ~/backup
    tar -zcvf $now.tar.gz $path
    touch $now sums.txt
    md5sum Backup_$now.tar.gz | cut -c -32 >  sums_$now.txt 
    touch olddir_$now.txt
    echo $path > olddir_$now.txt
  fi
else
  echo k, come back later!
  exit 0
fi

if test "$daterr" = "yes"; then
 echo Backup Complete! the script didnt managed to get the date so the folder is now called Backup_$now.tar.gz
else
 echo Backup complete! you will find it as a tar.gz file with the date on it
fi
exit 0
