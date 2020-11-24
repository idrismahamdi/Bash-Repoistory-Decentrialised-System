#!/bin/bash

readIn=`cat log.txt`
RED='\033[0;31m'
NC='\033[0m'
BLUE='\033[0;34m'
YELLOW='\033[0;93m'
PURPLE='\033[0;95m'




header () {

echo "Name: Idris Mahamdi"
echo "Student Number: 2425092"
echo "Module Code: AC21009"
echo ""


}

repoLocationNotFound () {
if [ ! -d "$fileLocation" ]; then
   echo "$fileLocation not found. Returning to main menu"
   countDown
 fi
}

fileLocationNotFound () {
if [ ! -f "$fileLocation" ]; then
   echo "$fileLocation not found. Returning to main menu"
   countDown
 fi
}





backupRepo () {
 back
 read -p "Please type in the name of the repository which the file you want to backup is in:  " fileLocation
 if [ "$fileLocation" == "back" ]
 then
     main
 fi

 repoLocationNotFound

 cd $fileLocation/..

 mkdir -p $fileLocation.backupsRepo
 
 cd $fileLocation.backupsRepo


 cd ..

 cp -R $fileLocation $fileLocation.backupsRepo
 cd $fileLocation.backupsRepo
 mv $fileLocation "$(date +%Y%m%d_%H%M%S)"
 
 cd ..


 
 echo "Backup complete, please check the backupRepo directory which would have just been created a directory above"

 countDown


}


back () {

   clear
   
   echo -e "${RED}Enter 'back' if you wish to return to the previous menu${NC}"

   echo ""
   echo ""


}


restoreRepo () {

 back
 read -p "Please type in the name of the repository which the file you want to restore is in:  " fileLocation
 repoLocationNotFound


 read -p "Please specify what backup within backupRepo folder. Name only: " backupRepo


 read -p "Please specify what you wish the backed up directory to be called: " newName


 cd $fileLocation
 cd ..

 chmod -R 755 $fileLocation


 rm -r $fileLocation

 mv "$fileLocation.backupsRepo/$backupRepo" $newName

 echo ""


 read -p "Would you like to initialise the git repository now? (y/n): " yn

 if [ "$yn" == "y" ]
 then
  createRepo
 fi

 countDown
 
 #mv $backupRepo $fileLocation
 






}


restoreFile () {

 back
 read -p "Please type in the name of the repository which the file you want to restore is in:  " fileLocation

 if [ "$fileLocation" == "back" ]
 then
     restore
 fi

 repoLocationNotFound
 
 read -p "Please enter the file you wish to restore: " currentFile
 read -p "Please enter the backup NAME (not location) - find the name in the backup folder in the repo (automatically backed up after every checkout): " restoreName
 
 cd $fileLocation
 git init
 cd backups
 mv $restoreName ..
 cd ..
 chmod 777 $currentFile
 rm $currentFile
 mv $restoreName $currentFile
 cd ..

 read -p "Would you like to update this to the git repository? (y/n): " yn

 if [ "$yn" == "y" ]
 then
  oneFile
 fi
 countDown

 

}

restore () {
  
back
echo "1. Restore a single file"
echo ""
echo "2. Restore a git repository"
echo ""

read -p "Please enter a number based on the corresponding number on the options: " num


if [ "$num" == "back" ]
then
     main
fi

  case $num in 
1 ) echo "You entered one."
    restoreFile
;;
2 ) echo "You entered two."
    restoreRepo
;;
* ) echo "You entered a number not between 1 and 2. Returning to menu..."
    sleep 2
    restore
;;
esac 




}


enter () {
  
  read -p "Press [Enter] to contiune: "
  clear


}


tutorial () {

  clear

  echo "This program is a bash script which allows users to make a git repository"
  echo "A git repository allows users keep track of changes which they or other users have made"
  echo "It also allows a user to checkout files allowing them to work on it and noone else"
  echo "The user can then check the file back in to update date the changes they have made"
  echo ""

  enter

  echo "The first step of making a git repository is to make the actual folder where it will be held"
  echo "You can do this yourself by making a directory on your computer or you can use the create repository function of this script"
  echo "This will make the folder but then also will then make it a git repository"
  echo ""

  enter

  echo "The next step is to move the files you want in the repository, to the repository"
  echo "You can do this but simply moving it on your computer or you can do this by using the move function on our program"

  enter

  echo "Once this has been completed you can either add indviudally the files you want in the git folder"
  echo "or you can choose to select all of them, this will allow these files to then be tracked thru git"

  enter

  echo "Once this is complete you can allow users to checkout a file which means the have exclusive permisson to edit it"
  echo "until its been checked back in. The user can edit it from the terminal if they wish"

  enter

  echo "Once it has been edited by the user they can check it in which allows the other users to view and allow them to check it out"

  enter

  echo "Backup of a file are automatically made when a user checks out a file"
  echo "Manual backups are required for backing up a whole repository"

  enter

  echo "To restore a file that has been backed up follow the restore menu"
  echo "either restoring a single file or a whole repository once restored you will need to reinitlise the repository/file"

  enter

  echo "You're able to zip a repository by using the zip option, this compresses it and keeps the files together so you can send the"
  echo "files easier, and also to secure the files"

  enter

  echo " JUST SOME TIPS:"
  echo ""
  echo "1. You can type 'back' at anytime to go back to the previous menu"
  echo ""
  echo "2. Recommend to put the program in the same directory as your git repository file is in"
  echo ""
  echo "3. If your git repo is the folder below just type the folder name without the slash"
  echo ""
  echo "4. Remember to include the file format. example: .txt"
  
  enter

}


countDown () {

 local down=5

 echo ""
 echo ""

 while [ "$down" -ne 0 ]
 do

   echo -ne "Returning to main menu in $down. \033[0K\r"
   sleep 0.33
   echo -ne "Returning to main menu in $down.. \033[0K\r"
   sleep 0.33
   echo -ne "Returning to main menu in $down... \033[0K\r"
   sleep 0.33
   ((down=down-1))
  

 done
 main
}


Exit () { 

 echo ""
 echo -e "${BLUE}Thank you for using this BASH repository script.${NC}"



 
 return 0

}




#Checking out a function

checkOut () {




   
   back

   read -p "Please type in the name of the repository you want to check out the file:  " fileLocation

   cd $fileLocation/..

   if [ "$fileLocation" == "back" ]
   then
     checkRepo
   fi

   read -p  "Please enter file name which you wish to check out of the repository: " newFilename

   cd $fileLocation

   if [ -f "$newFilename" ]; then
       echo ""
   else
       read -p "This file doesn't exist within the repo. Please enter 'fix' to re-enter the repo and file name or type 'main' to return to the main menu: " newFilename
       read -p  "Please enter file name which you wish to check out of the repository: " newFilename
       
       if [ $newFilename == "main" ] 
       then
        cd..
        main
       else
        cd ..
        checkOut
       fi

   fi

  local exit=0
  
   mkdir -p logfiles
   cd logfiles
   


   input="$newFilename.log"
   touch input
  
   

   while IFS= read -r line
   do
      if [ "$line" == "checkedOut $newFilename.log" ] 
      then
        echo "Sorry this file is currently in use by another user"
        exit=1
        cd ..
        cd ..
        break
      fi
  
   done < "$newFilename.log"
   
   if [ "$exit" -eq 1 ]
   then
    
    countDown 
   fi


   git init
   logfile="myscript.$newFilename.log"
   echo "checkedOut $newFilename.log" > $newFilename.log
   echo "Successfuly checked out the file"
   cd ..
  


   read -p "Would you like the edit this file within the terminal? (y/n): " yn
   if [ "$yn" == "y" ] 
   then
      vi "$newFilename"
      
   fi
   
   mkdir -p backups
   local dt=`date "+%d/%m/%Y %H:%M:%S"`

   cp $newFilename backups
   cd backups
   mv $newFilename "$newFilename.$(date +%Y%m%d_%H%M%S)"



   cd ..
   cd ..

   countDown
   
}





#Checking in a file function


 checkIn () {

  back


  read -p "Please type in the name of the repository you want to check in the file:  " fileLocation
 
  if [ "$fileLocation" == "back" ]
  then
     checkRepo
  fi

  read -p  "Please enter file name which you wish to check back in to the repository: " newFilename
  
  cd $fileLocation

   if [ -f "$newFilename" ]; then
       echo ""
   else
       echo "This file doesn't exist within the repo"
       cd ..
       countDown
   fi



  if [ ! -d "logfiles" ] 
   then
       echo -e "This file has never been checkedOut. Please ${RED}checkout first.${NC}"
       cd ..
   else
       cd logfiles
   fi

   input="$newFilename.log"
   local exit=0

   while IFS= read -r line
   do

      echo "$line"
      if [ "$line" = "checkedIn $newFilename.log" ]
      then
        echo -e "This file has already been checked back in. Please ${RED}checkout the file first.${NC}"
      
        exit=1
      elif [ "$line" = NULL ]
        then
        echo "This files log file is empty, this may be due to it not being checked out before."
        echo "Please checkout the file before checking the file in."
        exit=1
      fi
   done < "$newFilename.log"

   if [ "$exit" -eq 1 ]
   then
    cd ..
    countDown 
   fi
  

   cd ..
   git init
   git add $newFilename
   git commit

   cd logfiles
  
   logfile="myscript.$newFilename.log"
   echo "checkedIn $newFilename.log" > $newFilename.log
   echo "Successfuly checked the file back in"
   cd ..
   cd ..
   countDown
   

 }




#Menu for user to check in or out a file

checkRepo () {

   back

   echo '1. Checkout a file'
   echo ""
   echo '2. Check in a file'
   echo ""

   read -p "Please enter a number based on the corresponding number on the options: " num
  
   if [ "$num" == "back" ]
   then
     main
   fi

   case $num in 
   1 ) echo "You entered one."
        checkOut
   ;;
   2 ) echo "You entered two."
        checkIn
   ;;
   * ) echo  "You entered a number not between 1 and 2. Returning to the menu..."
       sleep 2
       checkRepo
   ;;
   esac

}

moveFile () {
  back

  read -p "Please enter in the location of the file which you want to move to the repository folder: " fileLocation
  
  if [ "$fileLocation" == "back" ]
  then
     addToRepo
  fi
  
  read -p "Please enter in the location of the repository folder: " repoLocation
  
  if [ "$repoLocation" == "back" ]
  then
     addToRepo
  fi


  mv $fileLocation $repoLocation

  countDown



}

allFiles () {

  back

  read -p "Please type in the location of the repository you want to add/update all the files to:  " fileLocation
   

  if [ "$fileLocation" == "back" ]
  then
     addToRepo
  fi
   

   cd $fileLocation
   git init
   git add .

  read -p "Do you wish to leave a custom commit: " com
   if [ "$com" == "y" ]
   then
     git commit
   else
     git commit -m "File added"
   fi
   cd ..

   countDown 



}


#Adding a single file to a repo

oneFile () {

   back


  
   
   read -p "Please type in the name of the repository you want to add the file to:  " fileLocation
   
   if [ "$fileLocation" == "back" ]
   then
     addToRepo
   fi
   
   read -p  "Please enter file name which you wish to move to the repository: " newFilename
   

   cd $fileLocation
   git init
   git add $newFilename

  
   read -p "Do you wish to leave a custom commit (y/n): " com
   if [ "$com" == "y" ]
   then
     git commit
   else
     git commit -m "File added"
   fi
   cd ..

   countDown 
   

   
}


#Add all or one file to a Repo menu

addToRepo () {
  
   back
   echo '1. Add/Update one file to the repository'
   echo ""
   echo '2. Add/Update all files to the repository'
   echo ""
   echo "3. Move file to repository folder *(Must be in the folder before adding it to the repository)*"
   echo ""
   read -p "Please enter a number based on the corresponding number on the options: " num


   if [ "$num" == "back" ]
   then
     main
   fi


   case $num in 
   1 ) echo "You entered one."
       oneFile

   ;;
   2 ) echo "You entered two."
       allFiles
   ;;

   3 ) echo "You entered three."
       moveFile
     
   ;;  

   * ) echo "You entered a number not between 1 and 3. Returning to the menu..."
       sleep 2
       addToRepo
   ;;
   esac

   countDown
   


}




#Create a new repo

createRepo () {

   back
   echo "*** If the folder is in the current directory just write the name of the new folder ***"  
   echo ""
   read -p "Please enter the file location of where the the file is located that you wish to convert to a new repository: " newFilename
   
   if [ "$newFilename" == "back" ]
   then
     main
   fi




   mkdir -p $newFilename
   cd $newFilename
   git init
   git commit 
   cd ..
   countDown

   
   

}


zip () {
 back
 read -p "Please type in the name of the repository which you want to compress:  " fileLocation
 if [ "$fileLocation" == "back" ]
 then
     main
 fi

 read -p "What would you want the zip to be called (without .zip): " zippedFile


 tar -zcvf $zippedFile.zip $fileLocation

 countDown



}


#Main menu

main () {



clear
echo "# This is a program that allows you to create and manage repository's #"
echo "# Computer Systems 2A - Assingment 1 #"

echo""
echo""


echo "1. Create a new reposistory"
echo ""
echo "2. Add/Update files to the repository"
echo ""
echo "3. Check a file in/out of the repository"
echo ""
echo "4. Restore Files"
echo ""
echo "5. Backup repository"
echo ""
echo "6. Zip a directory"
echo ""
echo "7. Exit"
echo ""
read -p "Please enter a number based on the corresponding number on the options: " num


case $num in 
1 ) echo "You entered one."
    createRepo
;;
2 ) echo "You entered two."
    addToRepo
;;
3 ) echo "You entered three."
    checkRepo
;;
4 ) echo "You entered four"
    restore

;;

5 ) echo "You entered five."
    backupRepo

;;

6 ) echo "You entered six."
    zip


;;

    
7 ) echo "You entered seven."
    echo ""
    read -p "$(echo -e ${RED}"Are you sure you want to exit (y/n): "${NC})" ext
    if [ "$ext" == "y" ] 
    then
      Exit
    else
      main
    fi
;;
* ) echo "You entered a number not between 1 and 8. Returning to main menu..."
    sleep 2
    main
;;
esac
}




clear
header
echo "Best run on same location as you wish to have your repository." 
read -p "If so please do not write '/' infront of the repository name. [Enter] " enter
echo ""
clear
header
read -p "Do you wish to see a tutorial? (y/n) " tut
if [ "$tut" == "y" ]
then
  tutorial

fi

clear
header
echo "Computer Systems 2A - BASH repository program."
sleep 0.5
clear
header
echo "Computer Systems 2A - BASH repository program.."
sleep 0.5
clear
header
echo "Computer Systems 2A - BASH repository program..."
sleep 0.5






main


















   
 








