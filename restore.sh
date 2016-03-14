#!/bin/bash
mkdir /home/$USER/Backuprec
echo "hello this script is made to recover the data that you backed up with my backup script"
echo "before we start, was the backup folder start with a dot after the /, example:~ /.backup, y or no"
read -r cloaked
if test "$cloaked" = "y"
then
 cd ~/.backup
else
 cd ~/backup
fi
echo next what is the date or number marked on the name of the folder you want to restore
echo ,put EXACTLY how you see it on the name of the folder or it will not work
read -r date
md5=$(cat "sums_$date.txt")
md5c=$(md5sum "Backup_$date.tar.gz" | cut -c -32)
if test "$md5" = "$md5c"
then
 echo CHECKSUM OK
else
 echo CHECKSUM FAIL
 echo the checksum dont match, proceed anyway? y or n
 read -r md5e
 if test "md5e" = "y"
 then
  echo ok lets move on
 else
  exit 1
 fi
fi
echo did you used an olddit file to save the directory?y or n
read -r olding
if test "$olding" = "y"
then
path=$(cat olddir_$date.txt)
else
 echo input the next path
 read -r path
fi
if [ -d "$path" ]; then
 cd $path
 if [ -n "$(find . -prune -user "$(id -u)")" ]; then
  rm -rf $path
 else
  echo sry this folder is not yours, aborting
  exit 1
 fi
fi
if test "$cloaked" = "y"
then
 cp ~/.backup/Backup_$date.tar.gz /home/$USER/Backuprec
else
 cp ~/backup/Backup_$date.tar.gz /home/$USER/Backuprec
fi
cd /home/$USER/Backuprec
tar -xvzf Backup_$date.tar.gz
rm -rf Backup_$date.tar.gz
cp -r /home/$USER/Backuprec$path $path
rm -rf /home/$USER/Backuprec
echo restore succesful!
exit 0