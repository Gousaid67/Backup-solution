#/bin/bash
now=$(date +"%m-%d-%y")
if [ -z "$now" ]; then
  echo "an error occured while trying to retrieve the date, do it without a date? y or n"
  read -r dateerr
  while [ -z "$dateerr" ]; do
    echo ------ Please give an input ------
    read -r dateerr
  done
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
while [ -z "$awnser" ]; do
  echo ------ Please give an awnser ------
  read -r awnser
done
if test "$awnser" = "y"
then
  echo which folder you want to backup,specify the full path!
  read -r path
  while [ -z "$path" ]; do
    echo ------ Please give a path ------
    read -r path
  done
  if [ -n "$(find . -prune -user "$(id -u)")" ]; then
   echo you are the owner of the selected folder folder
  else
   echo you are backing up a folder that you dont own, you may proceed but my restore script WILL refuse to restore due to security reason
   notown=1
  fi
  echo OK, would you like it hidden from the user?you will need to do ls -a to see it. y or n
  read -r cloak
  while [ -z "$cloak" ]; do
    echo ------ Please give a awnser ------
    read -r cloak
  done
  if test "$cloak" = "y"; then
    mkdir ~/.backup
    cd ~/.backup
    tar -cvzf Backup_$now.tar.gz $path
    touch sums_$now.txt
    md5sum Backup_$now.tar.gz  | cut -c -32 > sums_$now.txt
    echo would you like to save the old dir of the backup saved? y or n
    read -r oldy
    while [ -z "$oldy" ]; do
     echo ------ Please put an input ------
     read -r oldy
    done
    if test "$oldy" = "y"
    then
      touch olddir_$now.txt
      echo $path > olddir_$now.txt
      echo old directory saved
    fi
  else
    mkdir ~/backup
    cd ~/backup
    tar -cvzf Backup_$now.tar.gz $path
    touch sums_$now.txt
    md5sum Backup_$now.tar.gz | cut -c -32 >  sums_$now.txt
    echo would you like to save the old dir the backup saved? y or n
    read -r oldy
    while [ -z "$oldy" ]; do
     echo ------ Please put an input ------
     read -r oldy
    done
    if test "$oldy" = "y"
    then
      touch olddir_$now.txt
      echo $path > olddir_$now.txt
      echo old directory saved
    fi
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
