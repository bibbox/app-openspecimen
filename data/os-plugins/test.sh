#!/bin/bash

touch /var/lib/openspecimen/plugins/test.test

POSITIONAL=()
while [[ $# -gt 0 ]]; do
  key="$1"

  case $key in
    -es|--emailsender)
      EMAILSENDER="$2"
      shift # past argument
      shift # past value
      ;;
    -er|--emailreceiver)
      EMAILRECEIVER="$2"
      shift # past argument
      shift # past value
      ;;
    -p|--password)
      PASSWORD="$2"
      shift # past argument
      shift # past value
      ;;
    -id|--collectionprotocolid)
      ID="$2"
      shift # past argument
      shift # past value
      ;;
    --default)
      DEFAULT=YES
      shift # past argument
      ;;
    *)    # unknown option
      POSITIONAL+=("$1") # save it in an array for later
      shift # past argument
      ;;
  esac
done

set -- "${POSITIONAL[@]}" # restore positional parameters

echo "EMAIL SENDER  = ${EMAILSENDER}" >> /var/lib/openspecimen/plugins/test.test
echo "EMAIL RECEIVER     = ${EMAILRECEIVER}" >> /var/lib/openspecimen/plugins/test.test
echo "PASSWORD    = ${PASSWORD}" >> /var/lib/openspecimen/plugins/test.test
echo "CP_ID    = ${ID}" >> /var/lib/openspecimen/plugins/test.test
echo "DEFAULT         = ${DEFAULT}" >> /var/lib/openspecimen/plugins/test.test

python3 /var/lib/openspecimen/plugins/export.py --er "${EMAILRECEIVER}"  --es "${EMAILSENDER}" --p "${PASSWORD}" --id "${ID}"
echo "DONE" >> /var/lib/openspecimen/plugins/test.test


