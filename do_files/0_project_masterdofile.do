* ******************************************************************** *
   * ******************************************************************** *
   *                                                                      *
   *               Behavioral Crowding                                    *
   *               MASTER DO_FILE                                         *
   *                                                                      *
   * ******************************************************************** *
   * ******************************************************************** *

       /*
       ** PURPOSE:     

       ** OUTLINE:      PART 0: Standardize settings and install packages
                        PART 1: Set globals for dynamic file paths
                        PART 2: Set globals for constants and varlist
                               used across the project. Intall custom
                               commands needed.
                        PART 3: Call the task specific master do-files 
                               that call all do-files needed for that 
                               tas. Do not include Part 0-2 in a task
                               specific master do-file


       ** IDS VAR:      

       ** NOTES:

       ** WRITEN BY:    Varnitha Kurli
	   
	   

       ** Last date modified:  March 25  2024
       */

*iefolder*0*StandardSettings****************************************************
*iefolder will not work properly if the line above is edited

   * ******************************************************************** *
   *
   *       PART 0:  INSTALL PACKAGES AND STANDARDIZE SETTINGS
   *
   *           -Install packages needed to run all dofiles called
   *            by this master dofile.
   *           -Use ieboilstart to harmonize settings across users
   *
   * ******************************************************************** *

*iefolder*0*End_StandardSettings************************************************
*iefolder will not work properly if the line above is edited

   *Install all packages that this project requires:
   local user_commands ietoolkit       //Fill this list will all commands this project requires
   foreach command of local user_commands {
       cap which `command'
       if _rc == 111 {
           cap ssc install `command'
       }
   }

   *Standardize settings accross users
   ieboilstart, version(12.1)          //Set the version number to the oldest version used by anyone in the project team
   `r(version)'                        //This line is needed to actually set the version from the command above


   * ******************************************************************** *
   *
   *       PART 1:  PREPARING FOLDER PATH GLOBALS
   *
   *           -Set the global box to point to the project folder
   *            on each collaborators computer.
   *           -Set other locals that point to other folders of interest.
   *
   * ******************************************************************** *

   * Users
   * -----------

   *User Number:
   * You                     1    //Replace "You" with your name
   * Next User               2    //Assign a user number to each additional collaborator of this code

   *Set this value to the user currently using this file
   global user  1

   * Root folder globals
   * ---------------------

  *User 1 is Varnitha, User 2 Ashwini, and User 3 is Arun. 
   
   
   if $user == 1 {
       global projectfolder  "/Users/varnithakurli/Library/CloudStorage/Dropbox/Ashwini-Varnitha/Behavioral Crowding"
   }

   if $user == 2 {
       global projectfolder ""
   }
   
   if $user == 3 {
	global projectfolder ""
	}


   * Project folder globals
   * ---------------------

   global dataWorkFolder         "$projectfolder/1_data"

   global rawData               "$dataWorkFolder/0_raw" 

   global processData               "$dataWorkFolder/1_processed" 
   global script            "$projectfolder/2_scripts" 
   global logs               "$projectfolder/3_log" 
   global results           "$projectfolder/4_results" 

         





