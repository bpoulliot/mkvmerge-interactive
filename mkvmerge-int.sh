#!/bin/bash

# PURPOSE: Removing excess tracks from individual or batch media files.
# USAGE: Run the script in the directory with file(s) to modify. Follow the prompts.
#        May be copied/pasted into shell as well.
# DEPENDENCIES: Requires both mediainfo and mkvmerge
#
# NOTES:
#   * Do not use spaces for comma-separated lists (i.e., "1,2" is correct while "1, 2" is not)
#   * Script defaults to safest options for discard and deletion (explicit confirmation)
#   * Future plans include: attachment selection, strict confirmation cases,
#                           command line options (e.g., specify files, force to streamline),
#                           ffmpeg integration, additional mkvmerge opts, tagging
# 

SUFX="EN" # suffix for avoiding overwriting, can be very simple

############################################ CHANGE AT OWN RISK ############################################

#!/bin/bash
for i in *.mkv; do \
echo && echo "FILE INPUT: ${i%.mkv}" && echo && \
AINF=$(mediainfo --Inform="Audio;Audio ID %StreamOrder%: %Language/String% (%CodecID%)\n" "${i}");
SINF=$(mediainfo --Inform="Text;Subs ID %StreamOrder%: %Language/String% (%CodecID%)\n" "${i}");
echo "${AINF}";
echo;
echo "${SINF}";
echo;
while true; do
  read -p 'Comma-separated AUDIO track number(s): ' ATRK
  case "${ATRK}" in
    [1-9]*) 
      AUDIO=" -a ${ATRK}"
      break
      ;;
    n) 
      AUDIO=" -A"
      break
      ;;
    "") 
      AUDIO=""
      break
      ;;
    *) echo 'Invalid input, please enter numbers and commas or "n" only...' >&2;;
  esac
done && \
while true; do
  read -p 'Comma-separated SUBTITLE track number(s), "n" to discard all, no input preserves all: ' STRK
  case "${STRK}" in
    "") 
      SUBS=""
      break
      ;;
    n) 
      SUBS=" -S"
      break
      ;;
    [1-9]*) 
      SUBS=" -s ${STRK}"
      break
      ;;
    *) echo 'Invalid input, please enter numbers and commas or "n" only...' >&2;;
  esac
done && \
while true; do
  read -p 'Discard attachments? (y/n): ' NOAT
  case "${NOAT}" in
    y) 
      ATCH="-M"
      break
      ;;
    n) 
      ATCH=""
      break
      ;;
    *) echo 'Invalid input, please enter y or n...' >&2;;
  esac
done && \
while true; do
  read -p 'Delete original file? (y/n): ' RMOG
  case "${RMOG}" in
    y) 
      echo "Original file will be deleted upon operation completion..."
      echo
      break
      ;;
    n) 
      echo 'Preserving original file...'
      echo
      break
      ;;
    *) echo 'Invalid input, please enter y or n...' >&2;;
  esac
done && echo && \
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
if [[ "${RMOG}" == "y" ]]; then
  echo "Deleting original file..." 
  rm "${i}"
else
  echo "Operation complete."
fi; done
