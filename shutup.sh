#!/bin/bash

# Usage:
#   crontab -e  ==>  @reboot . shutup.sh > ~/log/autoShutup.log 2>&1
# Requires:
#   log.sh

source /etc/profile
source /etc/bashrc
source ~/.bashrc

# import other scripts
SHELL_DIR='.'  # define this variable according to your real shell script path!!

source ${SHELL_DIR}/log.sh
LOGGER_NAME=AutoShutup
# set_level 'DEBUG'

# Usage:
#   test_prc_exists jupyter; if [ $? -eq 1 ]; then [ some commands to be executed... ]; fi 
#   test_prc_exists jupyter anaconda; if [ $? -eq 1 ]; then [ some commands to be executed... ]; fi 
#   test_prc_exists jupyter anaconda opt; if [ $? -eq 1 ]; then [ some commands to be executed... ]; fi 
# Parameters:
#   $1: process keyword
#   $2-$n: [optional] relative words to ensure that the process' existance 
# Returns: return 0 if exists, while 1 represents non-exists
function test_prc_exists(){
  if [[ $# < 1 ]]; then return 1; fi

  grep_expr=$1
  # echo grep_expr: $grep_expr
  ps_res=`ps -ef | grep ${grep_expr}`
  # echo ps_res: $ps_res

  # if $#==1, check if there exists more than one relavant processes via the ps result length
  if [[ $# == 1 ]]; then
    ps_res_arr=(ps_res)
    if [ ${#ps_res_arr[@]} -gt 10 ]; then 
      return 0
    else
      return 1
    fi
  fi

  # if $#>=2, use $2-$n to check substring
  args=($@)
  check_str=${args[@]:1}
  log_debug "check_str: $check_str"

  check_res=$ps_res
  for check in ${check_str[@]}; do
    log_debug "check: $check"
    check_res=`echo $check_res | grep $check`
  done

  if [ -n "$check_res" ]; then return 0; else return 1; fi
}


# Parameters:
#   $1: process name for logger info to print  
#   $2: the command to launch a process
#   $3: [optional] the grep expression for testing process existance 
#   $4-$n: [optional] the checking substring
function launch_prc(){
  if [ $# -lt 2 ]; then
    log_error "2 or more arguments are required but $# found"
    return 1
  fi

  # init some relative variables 
  prc_name="$1"
  cmd="$2"
  grep_exp=
  substr_args=

  log_debug $#
  if [ $# -ge 3 ]; then grep_exp="$3"; fi
  if [ $# -gt 3 ]; then substr_args="$4"; fi

  log_debug arguments:
  log_debug "$prc_name"
  log_debug "${cmd}"
  log_debug "$grep_exp"
  log_debug "$substr_args"

  start_info="launching $prc_name with command \`"$cmd"\`..."
  succ_info="$prc_name launched"
  fail_err="failed to launch $prc_name" 
  exist_info="$prc_name is already runnning"

  log_info "${start_info}"
  
  is_existed=1
  if [ $# -eq 3 ]; then
    test_prc_exists "$grep_exp"
    is_existed=$?
  elif [ $# -gt 3 ]; then
    test_prc_exists "$grep_exp" ${substr_args[@]}
    is_existed=$?
  fi

  if [ $# -eq 2 -o $is_existed -eq 1 ]; then    
    res=`echo "${cmd}" | /bin/bash`
    if [ $? -eq 0 ]; then
      log_info "$succ_info"
    else
      log_error "$fail_err"
    fi
    return 0
  else 
    log_error "$exist_info"
    return 1
  fi
}


function shutup_prc(){
  log_info 'start autoShutup ...'

  # define tasks 
  launch_prc 'jupyter notebook' "su -c 'nohup jupyter notebook > ~/log/jupyter.log 2>&1 &' victor" jupyter "anaconda opt"

  log_info 'finish autoShutup'
}


shutup_prc