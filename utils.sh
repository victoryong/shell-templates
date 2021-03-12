#!/bin/bash
# some common function that can be used repeatedly. 


function get_current_time(){
	DATE=`date "+%Y-%m-%d %H:%M:%S"`
	echo ${DATE}
}


# logger function
# $1 in the four functions below is the log string
LOGGER_NAME=''
function log_info(){
	echo "`get_current_time` [INFO] ${LOGGER_NAME} $1"
}

function log_error(){
	echo "`get_current_time` [ERROR] ${LOGGER_NAME} $1"
}

function log_warn(){
	echo "`get_current_time` [WARN] ${LOGGER_NAME} $1"
}

function log_debug(){
	echo "`get_current_time` [DEBUG] ${LOGGER_NAME} $1"
}