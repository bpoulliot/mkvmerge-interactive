#!/bin/bash

# PURPOSE: Removing excess tracks from individual or batch media files.
# USAGE: Run the script in the directory with file(s) to modify. Follow the prompts.
#        May be copied/pasted into shell as well.
# DEPENDENCIES: Requires both mediainfo and mkvmerge
#
# NOTES:
#   * Do not use spaces for comma-separated lists (i.e., "1,2" is correct while "1, 2" is not)
#   * Script defaults to safest options for discard and deletion (explicit confirmation)
#   * Future plans include: codec info, attachment selection, strict confirmation cases,
#                           command line options (e.g., specify files, force to streamline),
#                           ffmpeg integration, additional mkvmerge opts, tagging
# 

SUFX="EN" # suffix for avoiding overwriting, can be very simple

############################################ CHANGE AT OWN RISK ############################################

#!/bin/bash
for i in *.mkv; do \
echo && echo "${i%.mkv}" && echo && \
mediainfo --Inform="Audio;Audio ID %StreamOrder%: %Language/String%\n" "${i}" && \
mediainfo --Inform="Text;Subs ID %StreamOrder%: %Language/String%\n" "${i}" && \
read -p 'Comma-separated AUDIO track number(s): ' ATRK && \
read -p 'Comma-separated SUBTITLE track number(s), "all" to preserve, "none" to discard all subs: ' STRK && \
read -p 'Discard attachments? (yes/no): ' NOAT && \
read -p 'Delete original file? (yes/no): ' RMOG && echo && \
case "${ATRK}" in
  [1-9]*) AUDIO=" -a ${ATRK}";;
  *) AUDIO="";;
esac && \
case "${STRK}" in
  [Aa]ll) SUBS="";;
  [Nn]|[Nn]one) SUBS=" -S";;
  *) SUBS=" -s ${STRK}";;
esac && \
case "${NOAT}" in
  true|True|TRUE|t|yes|Yes|YES|y|Y) ATCH="-M";;
  *) ATCH="";;
esac && \
OPTS="${ATCH}${AUDIO}${SUBS}" && \
FILE="${i%mkv}EN.mkv" && \
echo "Confirm selections:" && echo && \
  echo "    Audio tracks:         ${ATRK}" && \
  echo "    Subtitle tracks:      ${STRK}" && \
  echo "    Discard attachments:  ${NOAT}" && \
  echo "    DELETE original file: ${RMOG}" && echo && \
read -p 'Is this correct (yes/no)?' SGO && echo && \
case "${SGO}" in
  [Yy]|[Yy]es) echo "Initiating mkvmerge..." && echo && mkvmerge -o "${FILE}" ${OPTS} "${i}";;
  *) echo "User canceled." && break;;
esac && \
case "${RMOG}" in
  [Yy]|[Yy]es) echo "Deleting original file..." && rm "${i}";;
  *) echo 'Preserving original file...';;
esac && \
echo "Operation complete."; done
