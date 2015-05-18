#!/usr/bin/env perl


sub ferryColorize {
my $string1 = $_[0];
$string1 =~ s/ at /<149> at <099>/g;
$string1 =~ s/ to /<149> to <099>/g;
$string1 =~ s/ from /<149> from <099>/g;
$string1 =~ s/ in /<149> in <099>/g;
$string1 =~ s/\, leaving for /<149>, leaving for <099>/g;
$string1 =~ s/ minutes./<149> minutes.<099>/g;
$string1 =~ s/]\./]<149>./g;
return $string1;
}


$data_file="tmp/sysinfo.txt";
open(DAT, $data_file) || die("Could not open file!");
@raw_data=<DAT>;
close(DAT);
my $wgn = 0;

foreach (@raw_data) {

	if (/^Sun Phase\: (.*)/)
	{
		print "#var gtime[Sun] {$1};\n";
	}	
	elsif (/^Trigael\: (.*)/)
	{
		print "#var gtime[Trigael] {$1};\n";
	}	
	elsif (/^Marabah\: (.*)/) 
	{
		print "#var gtime[Marabah] {$1};\n";
	}	
#	elsif (/^Alyrian Time\: (\d+)\:(\d+) (am|pm) on (\w+), (\w+) the (\d+)\w\w, year (\d+)/)
#	{
#		print "#var gtime[Min]  {$2};\n";
#		print "#var gtime[m]    {$3};\n";
#		print "#var gtime[Year] {$7};\n";
#		print "#var gtime[Month] {$5};\n";
		# Month Number?
#		print "#var gtime[Day]  {$6};\n";
#		print "#var gtime[DoW]  {$4};\n";
		# Convert hour to 24h time
#		$hour = $1;
#		if ($3 =~ /am/)
#		{
#			if ($hour == 12) {$hour = 0};
#		} else {
#			$hour = $hour + 12;
#		}
#		print "#var gtime[Hour]  {$hour};\n";
#	}
	elsif (/^The airship Inconvenience is flying over (.+),(.+)\. \((.+)\) \[(.+)\]/)
	{
		print "#var navigation[airship][X]       {$1};\n";
		print "#var navigation[airship][Y]       {$2};\n";
		print "#var navigation[airship][Terrain] {$3};\n";
		print "#var navigation[airship][Time]    {$4};\n";
	}
	elsif (/^(.+) Ferry Status: (.+)\. \[(.+)\]/)
	{
		print "#var navigation[ferry][$1][Loc]     {$2};\n";
		print "#var navigation[ferry][$1][Time]    {$3};\n";
		my $fColor = ferryColorize($2);
		print "#var navigation[ferry][$1][LocColor] {$fColor};\n";

	}
	elsif (/^Merdraco Status: (.+)\. \[(.+)\]/)
	{
		print "#var navigation[ferry][Merdraco][Loc]     {$1};\n";
		print "#var navigation[ferry][Merdraco][Time]    {$2};\n";
		my $fColor = ferryColorize($1);
		print "#var navigation[ferry][Merdraco][LocColor] {$fColor};\n";
	}
	elsif (/^A worldgate has appeared in (.+), coordinates \[(.+)\,(.+)\]/)
	{
		print "#var gtime[wg][$wgn][Plane] {$1};\n";
		print "#var gtime[wg][$wgn][X] {$2};\n";
		print "#var gtime[wg][$wgn][Y] {$3};\n";
		$wgn = $wgn + 1;
	}
	elsif (/^System Time\: (.+) (.+) (.+) (.+)\:(.+)\:(.+) (.+)$/)
	{
		print "#var stime[Min]  {$5};\n";
		print "#var stime[Sec]  {$6};\n";
		print "#var stime[Year] {$7};\n";
		print "#var stime[Month] {$2};\n";
		# Month Number?
		print "#var stime[Day]  {$3};\n";
		print "#var stime[DoW]  {$1};\n";
		print "#var stime[Hour]  {$4};\n";
	}
}
