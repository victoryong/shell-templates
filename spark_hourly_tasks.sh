#!/bin/bash

# 参数列表：ymd1, hr1, ymd2, hr2, mode
# 没有时间参数则默认上一小时，只有两个时间参数则处理该时刻，四个时间参数则为起止时间
# 1/3/5个参数时，最后一个参数指定运行模式为local/yarn
#
# Usage:
# function main() { 
# 	cmd_task1
# 	state=$?
#
# 	cmd_task2
# 	state=$(($state+$?))
# 	...
#	return $state
# }
#
# . /fakepath/shell-scripts/spark_hourly_tash.sh "$@"

. /etc/profile
. ~/.bashrc


YMDHFORMAT="%Y%m%d%H"
Y_M_DFORMAT="%Y-%m-%d"
HourAgo="-1"

maxRetryTimes=3
sleepInterval=1m

# ========function definition

function __FormatTime() {
	TimeFormat=$1
	HourAgo=$2

	dt=`date +${TimeFormat} -d "${HourAgo} hour" `
	echo ${dt}
}


function __ExecTask() {
	ymd=$1
	hour=$2
	mode=$3
	y_m_d=`date +${Y_M_DFORMAT} -d "${ymd}"`

	echo $y_m_d $hour $mode

	main
	state=$?

	if [[ $state == 127 ]]; then
		echo "- [ERROR] - Require main function that defines task to be executed! "
	elif [[ $state != 0 ]]; then
		retryTimes=0
		while [[ $state != 0 && $retryTimes < $maxRetryTimes ]]; do
			retryTimes=`expr $retryTimes + 1`
			echo "- [INFO] - Task failed for $retryTimes times. It would be retry after $sleepInterval. "
			sleep $sleepInterval

			main
			state=$?
		done
	fi

}


# ========script starts here

max_n_args=5

mode=local
# 处理mode参数
if [[ $# -le $max_n_args && `expr $# % 2` == 1 ]]; then 
	mode="${@: -1}"
fi


if [[ $# == 2 ]]; then
	# 只有一个ymd hr对，执行该小时
	__ExecTask $1 $2 $mode
elif [[ $# == 4 ]]; then
	# 有两个ymd hr对，执行两者之间所有小时
	ymd=$1
	hour=$2

	__ExecTask $ymd $hour $mode

	while [[ $ymd$hour < $3$4 ]]; do
		dt=`date +${YMDHFORMAT} -d "+1 hour $ymd $hour"`

		ymd=${dt:0:8} 
		hour=${dt:8:2}

		__ExecTask $ymd $hour $mode
	done
else
	# 无时间参数，执行上一小时，供定时任务用
	dt=( $(__FormatTime ${YMDHFORMAT} ${HourAgo}) )
	__ExecTask ${dt:0:8} ${dt:8:2} $mode
fi
