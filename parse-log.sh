#!/usr/bin/env bash
set -eu
log=$1

w=$(grep -c 'different output' $log)
bf=$(grep -c 'failure (static)' $log)
c=$(grep -E -c 'failure \((optimised|unoptimised|oracle)\)' $log)
to=$(grep -c 'timeout' $log)
tick=$(grep -c 'same output' $log)
aborted=$(grep -c 'aborted' $log)
total=$((w+bf+c+to+tick+aborted))

(echo "w $w"
echo "bf $bf"
echo "c $c"
echo "to $to"
echo "✓ $tick"
echo "aborted $aborted"
echo "total $total") | column -t

if [[ "$total" != 1000 ]]; then
    echo
    echo "wtf?"
    grep -v '^+' $log | grep -v 'different output' \
        | grep -v 'same output' \
        | grep -E -v 'failure \((static|optimised|oracle)\)' \
        | grep -v 'timeout' \
        | grep -v 'same output' \
        | grep -v 'aborted'
fi
