#!/usr/bin/env bash

TMP=/var/tmp
TMP_FILE_1=${TMP}/dirdiff_tmp1.txt
TMP_FILE_2=${TMP}/dirdiff_tmp2.txt
USAGE_WARNING=0
DEBUG=0

usage() {
  echo 'USAGE: dirdiff.sh [options] <directory path 1> <directory path 2>'
  echo '       shows the files that are not in sync between both directories.'
  echo $'\nOPTIONS: -t or --time difference based on size and timestamp (default, fast)'
  echo '         -c or --checksum difference based on MD5 checksum calculation'
}

testdir() {
  if [[ ! -d $1 ]]; then
    # avoids showing the usage twice (case where an unknown option was passed)
    if [[ $USAGE_WARNING -eq 0 ]]; then
      usage
      echo  # newline
    fi
    echo "ERROR ($FUNCNAME): dirdiff script arguments must be existing directory paths."
    exit 1
  fi
}

filelist () {
  if [[ $OPTION =~ (-t|--time) ]]; then
    find . -type f -exec stat --printf="%s%Y %n\n" {} + | sort -k 1 > $1
  else
    find . -type f -exec md5sum {} + | sort -k 2 > $1
  fi
}

if [[ $# -lt 2 || $# -gt 3 ]]; then
  usage
  exit 1
fi

OPTION='-t'

if [[ $# -eq 3 ]]; then
  if [[ $1 =~ ^(-t|--time|-c|--checksum)$ ]]; then
    OPTION=$1
  else
    usage
    echo $'\nWARNING: unknown option, assuming -t as the default.\n'
    USAGE_WARNING=1  # avoids showing the usage twice (in case of an issue with the directory arguments)
  fi
  DIR1=$2
  DIR2=$3
else
  DIR1=$1
  DIR2=$2
fi

testdir "$DIR1"  # "" protects against spaces in directory name
testdir "$DIR2"

cd "$DIR1"
filelist "${TMP_FILE_1}"

cd "$DIR2"
filelist "${TMP_FILE_2}"

diff -y --suppress-common-lines ${TMP_FILE_1} ${TMP_FILE_2}

if [[ DEBUG -ne 1 ]]; then
  rm ${TMP_FILE_1}
  rm ${TMP_FILE_2}
fi
