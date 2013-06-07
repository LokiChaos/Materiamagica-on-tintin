#!/usr/bin/perl
$string1 = $ARGV[0];
# Closed doors im magenta <158>
$string1 =~ s/\(([NSEWUDew]+)\)/<159>\1<139>/g;
# Dark rooms
$string1 =~ s/([NSEWUDew]+)\[Dk\]/<039>\1<139>/g;
# CPK Rooms
$string1 =~ s/([NSEWUDew]+)\[CPK\]/<111>\1<139>/g;
# Dark CPK Rooms
$string1 =~ s/([NSEWUDew]+)\[DkCPK\]/<001>\1<139>/g;
# L/NPK Rooms
$string1 =~ s/([NSEWUDew]+)\[[LN]PK\]/<119>\1<139>/g;
# Dark L/NPK Rooms
$string1 =~ s/([NSEWUDew]+)\[Dk[LN]PK\]/<019>\1<139>/g;
# Dizzy/Dark
$string1 =~ s/\?/<128>\?/g;
# None
$string1 =~ s/None./<128>None./g;

print "<138>$string1                     ";
