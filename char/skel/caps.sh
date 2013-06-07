#!/bin/bash
# Store Args in meaningful names
# caps.sh TmuxServer TmuxSession TmuxWindow TintinSession
TSERVER="${1}"
TSESSION="${2}"
TWINDOW="${3}"
SESSION="${4}"

TMUXSPLIT="tmux -L ${TSERVER} split-window -t ${TSESSION}:${TWINDOW}"
TMUXRESPAWN="tmux -L ${TSERVER} respawn-pane -k -t ${TSESSION}:${TWINDOW}"

# Customize Below for different capture layouts.
${TMUXRESPAWN}          "captureTail ${SESSION} clantalk"
${TMUXSPLIT}.1 -v -l 19 "captureTail ${SESSION} activities"
${TMUXSPLIT}.2 -h -l 67 "mapTail ~/.tt/tmp/map.${SESSION}"
${TMUXSPLIT}.2 -v -l 5  "captureTail ${SESSION} transfers"
${TMUXSPLIT}.2 -v -l 6  "captureTail ${SESSION} noteworthy"
${TMUXSPLIT}.1 -v -l 12 "captureTail ${SESSION} tells"
${TMUXSPLIT}.1 -v -l 6  "captureTail ${SESSION} pktalk"
${TMUXSPLIT}.1 -v -l 6  "captureTail ${SESSION} relay_troll"
${TMUXSPLIT}.1 -v -l 7  "captureTail ${SESSION} allytalk"
