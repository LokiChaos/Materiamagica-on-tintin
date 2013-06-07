/*
	Exit re-formatter for Materimagica & tintin++
	Takes in a string contianing up to 10 directions:
	N S E W Ne Nw Se Sw U D
	which may be marked with the following tags:
	[LPK] [NPK] [CPK] [Dk] [DkLPK] [DkNPK] [DkCPK]
	or enclosed in () to denote a closed door.

	It returns an string with the directions in the order
	of appearance of the original string, tagged with <###>
	tintin++ color tags based on the exit attibutes.  Extraneous
	color tags are omitted and the output string is padded to 23
	printable charaters wide (color tags do not count as printable).
*/

#include <stdio.h>
enum { NORMAL, DARK, DOOR, DIZZY, 
       LPK, NPK, CPK,
       LPK_DARK, NPK_DARK, CPK_DARK,
       CLEAR_BG,
       TAG_LAST};

enum { DIRECTION, TAG };

char colorstrings[TAG_LAST][6] = {
	"<139>", /* Normal - Yellow */
	"<039>", /* Dark - Dark-Yellow */
	"<159>", /* Door - Magenta */
	"<129>", /* Dizzy - Green */
	/* PKs */
	"<119>", /* LPK - Red */
	"<119>", /* NPK - Red */
	"<111>", /* CPK - Red on Red */
	/* Dark Pks*/
	"<019>", /* DkLPK - Dark-Red */
	"<019>", /* DkNPK - Dark-Red */
	"<001>", /* DkCPK - Black on Red */
	"<089>", /* Clear BG */
};

char end[] = "<099>";

int
appendcolor(char *base, int color) {
	int i;
	for (i = 0; i < 6; i++)
		base[i] = colorstrings[color][i];
	return 5;
}

int
appenddir(char *base, char *dir, int *printable) {
	int i;
	for(i = 0; i < 3 && dir[i]; i++)
		base[i] = dir[i];
	*printable = *printable + i;
	return i;
}


int
main (int argc, char *argv[]) {

	if (argc != 2)
		return 1;

	int n = 0, nc = 0, dn = 0, opidx = 0, printable = 0;
	int forcecolor = 1;
	int color[10] = {0};
	char dir[10][3] = {{0}};
	int mode = DIRECTION;

	char out[120] = {0};

	/* Special "None" case */
	if (argv[1][0] == 'N' && argv[1][1] == 'o') {
		printf("%sNone                   \n", colorstrings[DIZZY]);
		return 0;
	}

	while (argv[1][nc] && n < 10 && nc < 1000) {
		switch (argv[1][nc]) {
			case '(':
				color[n] = DOOR;	
			break;
			case '[':
				mode = TAG;
			break;
			case ']':
				mode = DIRECTION;
			break;
			case 'N':
				if(mode == TAG)
					color[n] = color[n] ? NPK_DARK : NPK;
				else
					dir[n][0] = argv[1][nc];
			break;
			case 'S':
			case 'E':
			case 'W':
			case 'U':
				dir[n][0] = argv[1][nc];
			break;
			case 'D':
				if(mode == TAG) 
					color[n] = DARK;
				else
					dir[n][0] = argv[1][nc];

			break;
			case 'e':
			case 'w':
				dir[n][1] = argv[1][nc];
			break;
			case 'L':
				if(mode == TAG)
					color[n] = color[n] ? LPK_DARK : LPK;
			break;
			case 'C':
				if(mode == TAG)
					color[n] = color[n] ? CPK_DARK : CPK;
			break;
			case '?':
				color[n] = DIZZY;
				dir[n][0] = argv[1][nc];
			break;
			case ' ':
				n++;
			break;
		}
		nc++;
	}

	/* Build output string from color values and direction strings */
	while (dn < 10 && dir[dn][0] && opidx < 120) {
		/* Only add the color tag when needed (ie: 
		   the first direction and when the color changes) */
		if (forcecolor || color[dn] != color[dn - 1])	
			opidx += appendcolor(&out[opidx], color[dn]);
		/* Append the direction string and move the working index to after that*/	
		opidx += appenddir(&out[opidx], dir[dn], &printable);

		/* Clear Background color (if needed), and force color on next dir */
		if (colorstrings[color[dn]][3] != '9') {
			for(n = 0; n < 6; n++)
				out[opidx + n] = colorstrings[CLEAR_BG][n];
			opidx += 5;
			forcecolor = 1;
		} else {
			forcecolor = 0;
		} 
		/* Add a space (if not the 10th direction) */
		if (dn != 9) {
			out[opidx] = ' ';
			opidx++;
		}
		printable++;
		/* Move to next direction */
		dn++;
	}
	/* Pad with spaces to get the printed char width to 22 */
	for (n = 0; n < (23  - printable); n++, opidx++)
		out[opidx] = ' ';
	/* postpend a clearing color tag and a null*/
	for (n = 0; n < 5; n++, opidx++)
		out[opidx] = end[n];
	/* output string to stdout*/
	puts(out);
	return 0;
}
