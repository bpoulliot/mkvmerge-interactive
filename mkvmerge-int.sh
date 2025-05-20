for i in *.mkv; do \
echo && echo "${i%.mkv}" && echo && \
mediainfo --Inform="Audio;Audio ID %StreamOrder%: %Language/String%\n" "${i}" && \
mediainfo --Inform="Text;Subs ID %StreamOrder%: %Language/String%\n" "${i}" && \
read -p 'Audio Track Number/s (comma-separated): ' ATRK && \
read -p 'Subtitle Track Number/s (comma-separated): ' STRK && echo && \
read -p 'Discard attachments? (true/false): ' NOAT && \
read -p 'Keep original file? (true/false): ' RMOG && \
case "${ATRK}" in
  [1-9]*) AUDIO=" -a ${ATRK}";;
  *) AUDIO="" 
esac && \
case "${ST}" in
  [1-9]*) SUBS=" -s ${STRK}";;
  *) SUBS="" 
esac && \
case "${NOAT}" in
  true|True|TRUE|t|yes|Yes|YES|y|Y) ATCH="-M"
  *) ATCH=""
esac && \
case "${RMOG}" in
  false|False|FALSE|f|no|No|NO|n|N\) ATCH="-M"
  *) ATCH=""
esac && \
OPTS="${ATCH}${AUDIO}${SUBS}" && \
FILE="${i%mkv}EN.mkv" && \
mkvmerge -o "${FILE}" ${OPTS} "${i}" && \
rm "${i}" "${i%mkv}nfo"; done
