
# curl -k "http://localhost:8887/iplant-apps/trigger/job/9/token/7d7e5472e5159d726d905b4c06009c2f/status/RUNNING"

IFILE=wc-1.00/read1.fq
PLL=1

OUTPUT_FILE=wc_out.txt

ARGS=" -clw"

if [[ -n $PLL ]]; then
ARGS="${ARGS}m"
fi

set -x
# iget -f ${IFILE} .

LFILE=$(basename ${IFILE})

wc ${ARGS} ${IFILE} > ${OUTPUT_FILE}

set +x

tar czvf output.tar.gz ${OUTPUT_FILE}


# curl -k "http://localhost:8887/iplant-apps/trigger/job/9/token/7d7e5472e5159d726d905b4c06009c2f/status/FINISHED"
