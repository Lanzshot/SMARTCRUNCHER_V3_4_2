#!/usr/bin/perl

#########################################################################################################################
#Program:       SMARTCRUNCHER_V3_4_2.pl                                                                  (Dtd: 25/06/07)#
#Created by:    CS Lam                                                                                                  #
#Function:      Will Crunch the given LOT number and copy both the original Tprogs, Thermal and Crunch                  #
#               data to your specific folder. 																                                          #
#Setup:         Need Ohayo_v3_4 to be copied under your sgpsltlab server DIR  and run the script from Server DIR.       #
#               If not the program will not work!                                                                       # 
#########################################################################################################################

$NO_OUTPUT = "&> /dev/null";
$SOURCEDIR = "/data/log";               #Host dir storing tprogs.
$TPROGSDIR = "/home/";          				#Tprogs files will be backup here.
#$CRUNCHDIR = "/hst_programs";          #Crunch CSV Data stored under here.

###Check if Ohayo V3 is copied to cell host root DIR.###
#if ( -e "/ohayo_v3_4/")
#{

###Get Lotnumber, tprog and CSV save location.###
print("\nPlease enter 1 Lot number to be crunch. <Note:Must be the same as Test Setup. eg. \"530MAIN\" ...etc>\n");
$LOTINFO = <STDIN>;
chomp($LOTINFO);
$LOTNUM = "tprog_ENG$LOTINFO";
print("\nThe affected Tprogs lot is  $LOTNUM\n\n");
$THERMALLOGS = "thermal_ENG$LOTINFO";
print("\nThe affected Thermal Logs is  $THERMALLOGS\n\n");


###SCP all relevant DIR over to sgpsltlab server.###
print("\nPlease enter your user ID. > eg.cslam\@sgpsltlab:home/ \"cslam\"/ \n");
$HSTID = <STDIN>;
chomp($HSTID);

print("\nPlease enter the CELL no:<eg.KSLT cell 72 as  \"072\" .>\n");
$CELLNO = <STDIN>;
chomp($CELLNO);

###User define Tprogs & Thermal logs DIR.###
print("\nPlease state/create your path to stored the Tprogs & Thermal Logs files: <eg.home/cslam/ \"1.13_New\" >\n");
$PATH1 = <STDIN>;
chomp($PATH1);
print("Tprog data will be stored here $TPROGSDIR$HSTID/$PATH1\n\n");
print("Tprog data will be stored here $TPROGSDIR$HSTID/$PATH1/ThermalLogs\n\n");

###User define CSV DIR.###
print("Please state/create your path to stored the Crunched CSV files: <eg.home/cslam/1.13_Crunch OR state \"same\" if same as above>\n");
$PATH2 = <STDIN>;
chomp($PATH2);
if($PATH2 == "same")
{  $PATH2 = $PATH1;
   print("Crunched data will be stored here $TPROGSDIR$HSTID/$PATH2\n\n");
}

###User define system type. HST or KSLT ###
print("\nPlease select the type of system you are using. <<(1) for HST, press (Enter) for KSLT>>\n");
$SYSTEMTYPE = <STDIN>;
chomp($SYSTEMTYPE);
      if($SYSTEMTYPE == 1)
        {print("You have choose ((HST)).\n\n");
        $SYS = "hst";
	}
      else
        {print("You have choose ((KSLT)).\n\n");
	$SYS = "kslt";
	}

###Create subfolder and scp Tprogs to sgpsltlab server.###
print("\nCopying Tprogs to here $TPROGSDIR$HSTID/$PATH1/\n");
`mkdir $TPROGSDIR$HSTID/$PATH1/`;
$cmd = "scp root\@sgpamd$SYS$CELLNO:$SOURCEDIR/$LOTNUM*.log $TPROGSDIR$HSTID/$PATH1/";
print ("\n$cmd\n");
`$cmd`;
$SCP = $?;
if($SCP == 0)
  {print("\n### Tprogs Transfer Done! ###\n\n\n");

###Create subfolder and scp Thermal Logs to sgpsltlab server.###
print("\nCopying Thermal Logs to here $TPROGSDIR$HSTID/$PATH1/ThermalLogs\n");
`mkdir $TPROGSDIR$HSTID/$PATH1/ThermalLogs`;
$cmd = "scp root\@sgpamd$SYS$CELLNO:$SOURCEDIR/$THERMALLOGS*.log $TPROGSDIR$HSTID/$PATH1/ThermalLogs";
print ("\n$cmd\n");
`$cmd`;
$SCPThermal = $?;
if($SCPThermal == 0)
  {print("\n### Thermal Logs Transfer Done! ###\n\n\n");



###Data crunching and moving crunched data to folders.###
print("Will begin to crunch data... take a break!!!.\n\n");
$cmd = "./ohayo.sh -l $LOTNUM -p $TPROGSDIR$HSTID/$PATH1/";
print("\n$cmd\n");
system($cmd);
      print("\n### Crunching Done! ###\n\n");

print("Moving Crunched/CSV files to here $TPROGSDIR$HSTID/$PATH2\n");
`mkdir $TPROGSDIR$HSTID/$PATH2/`;
`mv $TPROGSDIR$HSTID/ohayo_v3_4_report/result/M_$LOTNUM*.csv $TPROGSDIR$HSTID/$PATH2`;
$CrunchDATA = $?;
      if($CrunchDATA == 0)
        {print("\n###Crunched data copy done. ###\n\n");}
      else
        {print("### Fail to copy CSV! ###\n\n");}
     
  }
  else
    {print("\n### SCP Failed! ###\n\n");}
}












