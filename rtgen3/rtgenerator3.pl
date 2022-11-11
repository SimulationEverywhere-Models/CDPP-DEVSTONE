#!/usr/bin/perl

#
# Ezequiel Glinsky
# version 3
# October 2001
#

use strict;

#my $total = 10;
#my $file = "test_new.txt";


my $total = $ARGV[1];			# get from command line
my $file = $ARGV[0];			# get from command line
my $intdelay = $ARGV[2];		# get from command line
my $extdelay = $ARGV[3];		# get from command line
my $width = $ARGV[4];			# get from command line

if ($total eq "") { print "\n------------------\nAutomatic Model Creator using RTAtomic\nEzequiel Glinsky (eglinsky\@dc.uba.ar)\nOctober 2001\n------------------\n\n\nUsage: rtgenerator FILENAME LEVEL INTDELAY EXTDELAY MODELS_LEVEL\nError! Missing parameters!\n\n"; die }
if ($file eq "")  { print "Usage: rtgenerator FILENAME LEVEL\n"; die }

open(FILE,">$file");

#####################################
####### START - HEADER
#####################################

my $ant = 0;
my $i = 0;
my $aux = 0;
my $filetxt = <<texto;
[top]
texto

########
## Width of top level
#######
my $components = "components : rtc0";

my $iwidth;
for ($iwidth = 1 ; $iwidth < $width; $iwidth++)
{
	$components .= " rtc0$iwidth\@RTAtomic";
}

$filetxt .= $components;

#######
## Links at top level ($ant=0)
#######
$filetxt .= <<texto;

out : out
in : in
link : in in\@rtc0
link : in inaux\@rtc0
texto

for ($iwidth = 1 ; $iwidth < $width; $iwidth++)
{
$filetxt .= <<texto;
link : in in\@rtc$ant$iwidth
texto
}

#######
## New links for version 2 and 3 - Connects out of atomic 1 to in of atomic 2, out of atomic 2 to in of atomic 3 and so on
#######
for ($iwidth = 1 ; $iwidth < ($width-1); $iwidth++)
{
$aux = $iwidth + 1;
$filetxt .= <<texto;
link : out\@rtc$ant$iwidth in\@rtc$ant$aux
texto
}

#######
## Final link, to the real world
#######
$filetxt .= <<texto;
link : out\@rtc0 out
texto

$filetxt .= <<texto;

[rtc0]
texto

$components = "components : rtc1";

my $iwidth;
for ($iwidth = 1 ; $iwidth < $width; $iwidth++)
{
	$components .= " rtc1$iwidth\@RTAtomic";
}

$filetxt .= $components;

$filetxt .= <<texto;

out : out
out : outaux
in : in
in : inaux
link : in in\@rtc1
link : in inaux\@rtc1
texto
for ($iwidth = 1 ; $iwidth < $width; $iwidth++)
{
$filetxt .= <<texto;
link : inaux in\@rtc1$iwidth
texto
}

#######
## New links for version 2 - Connects out of atomic 1 to in of atomic 2, out of atomic 2 to in of atomic 3 and so on
## New links for version 3 - Connects out of atomic 1 to outaux of coupled model
#######
for ($iwidth = 1 ; $iwidth < ($width-1); $iwidth++)
{
$aux = $iwidth + 1;
$filetxt .= <<texto;
link : out\@rtc1$iwidth in\@rtc1$aux
link : out\@rtc1$iwidth outaux
texto
}

$filetxt .= <<texto;
link : out\@rtc1$iwidth outaux
link : out\@rtc1 out
texto

#for ($iwidth = 1 ; $iwidth < $width; $iwidth++)
#{
#$filetxt .= <<texto;
#link : out\@rtc1$iwidth out
#texto
#}

$filetxt .="\n";
######
## Atomic models at top level
######

my $atmodels = "";

for ($iwidth = 1 ; $iwidth < $width; $iwidth++)
{
	$atmodels .= <<texto;
[rtc0$iwidth]
preparation : 00:00:00:000
intDelay : $intdelay
extDelay : $extdelay

texto
}

$filetxt .= $atmodels;


#####################################
####### END - HEADER
#####################################


###########################
## Main loop starts here
###########################
for ($i=2; $i<$total-1; $i++)
{
	$ant = $i-1;
	$filetxt .= <<texto;

[rtc$ant]
texto

#######
## Atomic components at each level (description/declaration)
#######

$components = "components : rtc$i";

$iwidth;
for ($iwidth = 1 ; $iwidth < $width; $iwidth++)
{
	$components .= " rtc$i$iwidth\@RTAtomic";
}

#######
## Coupled definition at each level
#######
$filetxt .= $components;
$filetxt .= <<texto;

out : out
out : outaux
in : in
in : inaux
link : in in\@rtc$i
link : in inaux\@rtc$i
texto
for ($iwidth = 1 ; $iwidth < $width; $iwidth++)
{
$filetxt .= <<texto;
link : inaux in\@rtc$i$iwidth
texto
}

#######
## New links for version 2 - Connects out of atomic 1 to in of atomic 2, out of atomic 2 to in of atomic 3 and so on
#######
for ($iwidth = 1 ; $iwidth < ($width-1); $iwidth++)
{
$aux = $iwidth + 1;
$filetxt .= <<texto;
link : out\@rtc$i$iwidth in\@rtc$i$aux
link : out\@rtc$i$iwidth outaux
texto
}

$filetxt .= <<texto;
link : out\@rtc$i$iwidth outaux
link : out\@rtc$i out
texto
#for ($iwidth = 1 ; $iwidth < $width; $iwidth++)
#{
#$filetxt .= <<texto;
#link : out\@rtc$i$iwidth out
#texto
#}

#########
## Atomic components at each level (the ones declared 
## in the previous step in the loop! -> use ant instead of i)
#########
for ($iwidth = 1 ; $iwidth < $width; $iwidth++)
{
	$filetxt .= <<texto;

[rtc$ant$iwidth]
preparation : 00:00:00:000
intDelay : $intdelay
extDelay : $extdelay
texto
}

}
# end FOR i  (level)
###########################
## Main loop ENDs here
###########################

$ant++;

#####################################
####### START - FOOTER
#####################################

$filetxt .= <<texto;

[rtc$ant]
components : rtc$i\@RTAtomic
out : out
in : in
in : inaux
link : in in\@rtc$i
link : out\@rtc$i out
texto

#########
## Atomic components at the lowest level
#########
for ($iwidth = 1 ; $iwidth < $width; $iwidth++)
{
	$filetxt .= <<texto;

[rtc$ant$iwidth]
preparation : 00:00:00:000
intDelay : $intdelay
extDelay : $extdelay
texto
}

$filetxt .= <<texto;

[rtc$i]
preparation : 00:00:00:000
intDelay : $intdelay
extDelay : $extdelay

[comments]
# --------
# Ezequiel Glinsky      eglinsky\@dc.uba.ar
# version 3
# October 2001
# --------
# This MA file is used to test the RealTime approach in DEVS
# Level used: $total
# The int and ext delays are used in the Internal and External transitions
texto

#####################################
####### END - FOOTER
#####################################

print FILE $filetxt;

close (FILE);

print "Saved file: $file (level=$total)\n\n";
