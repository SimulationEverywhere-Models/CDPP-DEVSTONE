#!/usr/bin/perl

#
# Ezequiel Glinsky
# October 2001
#

use strict;

#my $total = 10;
#my $file = "test_new.txt";


my $file = $ARGV[0];			# get from command line
my $quantity = $ARGV[1];		# get from command line
my $interval = $ARGV[2];		# get from command line
my $basetime = $ARGV[3];		# get from command line
my $inport = $ARGV[4];			# get from command line
my $outport = $ARGV[5];			# get from command line
my $valuein = $ARGV[6];			# get from command line
my $deadline_ms = $ARGV[7];		# get from command line

if ($deadline_ms eq "") { print "\n---------------------------------------------\nAutomatic Event File Creator using RTAtomic\nEzequiel Glinsky (eglinsky\@dc.uba.ar)\nOctober 2001\n---------------------------------------------\n\n\nUsage:\nevgenerator FILENAME quantity interval_msec base_msec in_port out_port value deadline_time_milisec\nError! Missing parameters!\n\n"; die }
if ($file eq "")  { print "Usage:\nevgenerator FILENAME quantity interval_msec base_msec in_port out_port value deadline_time_milisec\n"; die }

open(FILE,">$file");

#####################################
####### START
#####################################

my $time = 0;
#my $line = "in out 1";
my $line = $inport . " " . $valuein ;
my $filetxt = "";
my $hours = 0.0;
my $mins = 0.0;
my $sec = 0.0;
my $msec = 0.0;
my $interval_new = 0.0;
my $ev_time = "";

my $hours_dl = 0.0;
my $mins_dl = 0.0;
my $sec_dl = 0.0;
my $msec_dl = 0.0;
my $interval_new_dl = 0.0;
my $dl_time = "";


my $i;
for ($i = 0 ; $i < $quantity; $i++)
{
	$interval_new = $basetime + ($interval * $i);

	$msec = sprintf("%03d",$interval_new%1000);
#	print "Interval: ".$interval_new."\n";
#	print "msec: ".$msec."\n";
	$sec = sprintf("%02d",$interval_new/1000);	# integer part of seconds in the mseconds
#	print "sec: ".$sec."\n";
	$mins = sprintf("%02d",$sec/60) ;		# integer part of minutes in the seconds
#	print "mins: ".$mins."\n";
	$sec = sprintf("%02d",$sec-($mins*60));		# extract from seconds the minutes * 60
#	print "sec: ".$sec."\n";
	$hours = sprintf("%02d",$mins/60); 		# integer part of hours in the minutes
#	print "hours: ".$hours."\n";
	$mins = sprintf("%02d",$mins-($hours*60));	# extract from seconds the hours * 60
#	print "mins: ".$mins."\n";

	$interval_new_dl = $basetime + ($interval * $i) + $deadline_ms;
	$msec_dl = sprintf("%03d",$interval_new_dl%1000);
	$sec_dl = sprintf("%02d",$interval_new_dl/1000);	# integer part of seconds in the mseconds
	$mins_dl = sprintf("%02d",$sec_dl/60) ;		# integer part of minutes in the seconds
	$sec_dl = sprintf("%02d",$sec_dl-($mins_dl*60));		# extract from seconds the minutes * 60
	$hours_dl = sprintf("%02d",$mins_dl/60); 		# integer part of hours in the minutes
	$mins_dl = sprintf("%02d",$mins_dl-($hours_dl*60));	# extract from seconds the hours * 60

	$ev_time = $hours. ":" . $mins . ":" . $sec . ":" . $msec ;
	$dl_time = $hours_dl. ":" . $mins_dl . ":" . $sec_dl . ":" . $msec_dl ;
	$filetxt .= $ev_time . " " . " " . $line . "\n";
}

#####################################
####### END
#####################################

print FILE $filetxt;

close (FILE);

print "Saved file: $file (quantity: $quantity, interval in ms: $interval)\n\n";
