#!/bin/sh

echo -e "\033[01;34mNew Session Name?\033[00m"
SESNAME=""
while [ -z "$SESNAME" ]
do
	read -e SESNAME
done

echo -e "\033[01;34mEnter character name for new session '$SESNAME'\n (leave blank if you wish the session name to be used as the login name:\033[00m"
read -e ACNAME

if [ -z "$ACNAME" ]
then
	CNAME="$SESNAME"
else
	CNAME="$ACNAME"
fi

portmenu() {
	echo -e "\033[01;34mWhat port do you wish to use?\033[00m"
	echo -e "     23 (default)\n     4000\n     6666\n     8000\n     9000"
	echo -en "\033[01;34mPort?\033[00m "
	read -e PORT

	case "$PORT" in
		"" )
			P="23";;
		"23" )
			P="23";;
		"4000" )
			P="4000";;
		"6666" )
			P="6666";;
		"8000" )
			P="8000";;
		"9000" )
			P="9000";;
		* )
			echo -e "\033[01;31mInvalid port number!"
			portmenu;;
	esac
}

portmenu

echo -e "\033[01;34mAdding new session '$SESNAME' to table.\033[00m"
echo -e "#list charList add {{{name}{$SESNAME}{cname}{$CNAME}{menu}{1}{server}{materiamagica.com}{port}{$P}}}" >> etc/chars.tt

echo -e "\033[01;34mMaking char/$SESNAME/ dir and copying default configuration."
echo -e "\033[01;31mIt is recommended you edit the settings before logging in.\033[00m"

cp -r etc/skel char/$SESNAME

echo -e "\n\n\n\n\n"
exit 0
