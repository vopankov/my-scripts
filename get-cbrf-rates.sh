#!/usr/bin/env bash

function main() {
  NOCOLOR='\033[0m'
  RED='\033[0;31m'
  CYAN='\033[0;36m'

  CURRENCIES=$(curl -fvs https://www.cbr-xml-daily.ru/latest.js 2>/dev/null)

  if [ $? -ne 0 ]; then
    echo -e "${RED}Ошибка при обращении к серверу ЦБ РФ${NOCOLOR}"
    exit 1
  fi

  for CURR_NAME in "$@"; do
    RATE=$(echo ${CURRENCIES} | jq -c ".[\"rates\"][\"${CURR_NAME}\"]")
    echo -e "${CURR_NAME} ${CYAN}$(printf %.5f $(echo "1.0 / $RATE" | bc -l))${NOCOLOR}"
  done

  return 0
}

main $@
