#!/bin/bash

. /etc/profile
. /etc/bashrc


function testPrcExists(){
  # if $#==1, check if there exists more than one relavant processes, if $#==2, use the first one to be the grep expression and use the second one to check string existance.
  # return 0 if exists, while 1 represents non-exists

  if [[ $# < 1 ]]; then return 1; fi

  grep_expr=$1
  # echo grep_expr: $grep_expr
  ps_res=`ps -ef |grep ${grep_expr}`
  # echo ps_res: $ps_res

  if [[ $# == 1 ]]; then
    i=0
    for e in $ps_res; do
      i=$((i+1))
    done
    # echo i: $i

    if [ $i -gt 10 ]; then
      # echo hhahahahha
      return 0
    fi
    # echo nononnono
    return 1
  fi

  check_str=$2
  check_res=`echo $ps_res | grep $check_str`
  if [[ $check_res != "" ]]; then
    return 0
  fi
  return 1
}


function shutup_prc(){
  # define tasks 

  testPrcExists 'jupyter'
  if [ $? -eq 1 ]; then
    echo 'launch jupyter notebook...'
    su -c "nohup jupyter notebook &" victor
  fi


  # end define tasks
  echo 'launch finished! '
}

shutup_prc