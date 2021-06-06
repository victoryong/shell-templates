#!/bin/bash

# Usage: 
#   arr_str="aa bb ccc"
#   new_arr_str=`array_string_slice "$arr_str" "1:2"`
#   new_arr_str2=`array_string_slice "$arr_str" ":4"`
# Parameters:
#   $1: string that contains serveral single space which can be regarded as an array
#   $2: [optional] slice indices seperated by colon, if not provided, means return the original arr_str
# Echo: slice of arr_str
function array_string_slice() {
  if [ $# -lt 1 ]; then echo ''; return 1; fi

  arr=($1)

  start=`echo $2 | cut -d':' -f1`
  end=`echo $2 | cut -d':' -f2`

  if [ -z $start ]; then start=0; fi
  if [ -z $end ]; then end=${#arr[@]}; fi

  if [ $start -ge $end ]; then echo ''; return 1; fi

  slice_len=$((end - start))
  # notice: the second arg of array slice is length of slice but not the end index!! 
  echo ${arr[@]:$start:$slice_len}
  return 0
}


function __test_array_string_slice(){
  a='aaaa bb c dddd eee'
  array_string_slice "$a" "1:2"
  echo `array_string_slice "$a" "1:"`
  echo `array_string_slice "$a" ":3"`
  echo `array_string_slice "$a"`
}



