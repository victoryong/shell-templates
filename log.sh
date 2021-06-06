#!/bin/bash

function get_current_time(){
	DATE=`date "+%Y-%m-%d %H:%M:%S"`
	echo ${DATE}
}


# logger function
# $1 in the four functions below is the log string
LOGGER_NAME=''

_LOGGER_LEVEL=2 # default is _LEVEL_INFO
_LEVEL_ERROR=1
_LEVEL_INFO=2
_LEVEL_WARN=3
_LEVEL_DEBUG=4

function set_level(){
	if [ "$1" = 'ERROR' ]; then
		_LOGGER_LEVEL=1
	elif [ "$1" = 'INFO' ]; then
		_LOGGER_LEVEL=2
	elif [ "$1" = 'WARN' ]; then
		_LOGGER_LEVEL=3
	elif [ "$1" = 'DEBUG' ]; then
		_LOGGER_LEVEL=4
	else
		echo "cannot set logger level to be [$1], use default: [INFO]"
		return 0
	fi
	echo "set logger level: [$1]"
}

function log_info(){
	if [ $_LOGGER_LEVEL -ge $_LEVEL_INFO ]; then
		echo "`get_current_time` [INFO] - ${LOGGER_NAME} - $1"
	fi
}

function log_error(){
	if [ $_LOGGER_LEVEL -ge $_LEVEL_ERROR ]; then
		echo "`get_current_time` [ERROR] - ${LOGGER_NAME} - $1"
	fi
}

function log_warn(){
	if [ $_LOGGER_LEVEL -ge $_LEVEL_WARN ]; then
		echo "`get_current_time` [WARN] - ${LOGGER_NAME} - $1"
	fi
}

function log_debug(){
	if [ $_LOGGER_LEVEL -ge $_LEVEL_DEBUG ]; then
		echo "`get_current_time` [DEBUG] - ${LOGGER_NAME} - $1"
	fi
}
