#!/bin/sh
##################################################################################
#                 R E A D     T H I S  B E F O R E    U S I N G
#    This script is to help you in executing a list of thing in parralel. this will fork background processes
#    if you want to kill background processes use pkill -9 <yourscripname>
#    
#    -- U S A G E
#    suppose you have 10 thousands items in a file which requires some || processing
#    Note: if you are doing pure math, do not make it ||lel will not help much on single core CPU.
#    but if you are doing some network operation, u can make it ||lel it will help you for sure!!
#    -- INPUTS 
#    cmdParams-->  initialize the file name as cmdParams
#    maxthread --> specify max threads to fork as maxthread
#    executeInSerial function will get each item as $1 do some operation with it, replace echo with something else 
##################################################################################
########################
### maximum paralel operation
maxthread=10 ##### <---- C H A N G E      H E R E 


### filename where list of command to execute
cmdParams="GCCscenarios.txt" ##### <---- C H A N G E      H E R E 
###########################



batchSize=0;
totalCmds=`wc -l $cmdParams | sed 's/[^0-9]//g'`
echo "I am starting................................" >/dev/stderr
echo "$totalCmds commands found................................" >/dev/stderr


executeInSerial(){
  echo "executing $1" ##### <---- C H A N G E      H E R E 
}
batchExecute(){
  local lines=`head -n $1 $cmdParams | tail -n $2`
  for line in $lines
  do
      executeInSerial $line
  done
}
executeInBackground(){
  batchExecute $1 $2 $3&
}

for (( a=0; a<$maxthread; a++ ))
do
  batchSize=`expr $totalCmds / $maxthread` 
  start=`expr $batchSize \* $a`
  end=`echo "(($batchSize+1 )*$a)"`
  last=`expr $maxthread - 1`;
  if [ $a = $last ]; then
    batchSize=`expr $totalCmds - $start`
  fi  
  end=`expr $start + $batchSize`
  #amp at the end of the state ment will make it to execute in background
  executeInBackground $end $batchSize $a
done
#this will wait for backgrnd process to finish
wait
