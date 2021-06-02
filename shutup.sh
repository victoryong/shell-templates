#!/bin/bash

# Usage:
#   
# test_prc_exists 'jupyter'
# if [ $? -eq 1 ]; then
#   [ some commands to be executed... ] 
# fi
#
# crontab -e  ==>  @reboot . shutup.sh > ~/log/autoShutup.log 2>&1

# Requires:
# -- log.sh


. /etc/profile
. /etc/bashrc
. ~/.bashrc


function test_prc_exists(){
  # if $#==1, check if there exists more than one relavant processes, if $#==2, use the first one to be the grep expression and use the second one to check string existance.
  # return 0 if exists, while 1 represents non-exists

  if [[ $# < 1 ]]; then return 1; fi

  grep_expr=$1
  # echo grep_expr: $grep_expr
  ps_res=`ps -ef |grep ${grep_expr}`
  # echo ps_res: $ps_res

  # if just one arg, check the ps result length
  if [[ $# == 1 ]]; then
    ps_res_len=`tmp=(${ps_res[@]});echo ${#tmp[@]}`
    if [ $ps_res_len -gt 10 ]; then return 0; fi
    return 1
  fi

  # if there are more than one args, check substring using the second arg
  check_str=$2
  check_res=`echo $ps_res | grep $check_str`
  if [[ $check_res != "" ]]; then
    return 0
  fi
  return 1
}


function shutup_prc(){
  # define tasks 

  test_prc_exists 'jupyter'
  if [ $? -eq 1 ]; then
    log_info 'launching jupyter notebook...'
    su -c "nohup jupyter notebook > ~/log/jupyter.log 2>&1 &" victor
  fi


  # end define tasks
  log_info 'launch finished! '
}

. log.sh
LOGGER_NAME=AutoShutup
shutup_prc