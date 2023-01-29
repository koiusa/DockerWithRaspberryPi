#!/bin/bash

function get_setting(){
 ITEM_KEY=$1
 SCRIPT_DIR=$(cd $(dirname $0); pwd)
 SETTING=$(${SCRIPT_DIR}/src/parse_yaml.sh ${SCRIPT_DIR}/setting.yml)

 array=($SETTING)
 OLDIFS=$IFS
 declare -A dict
 for v in ${array[@]}
   do
            IFS='=' read -ra ARR <<< "${v}"
            dict[${ARR[0]}]=${ARR[1]}
   done
 IFS=$OLDIFS

 echo ${dict[$ITEM_KEY]}
}

