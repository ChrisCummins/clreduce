#!/usr/bin/env bash
set -u
log=$1

w=$(grep -c 'different output' $log 2>/dev/null)
bf=$(grep -c 'failure (static)' $log 2>/dev/null)
c=$(grep -E -c 'failure \((optimised|unoptimised|oracle)\)' $log 2>/dev/null)
to=$(grep -c 'timeout' $log 2>/dev/null)
tick=$(grep -c 'same output' $log 2>/dev/null)
aborted=$(grep -c 'aborted' $log 2>/dev/null)
total=$((w+bf+c+to+tick+aborted))

set -e
(echo "w $w"
echo "bf $bf"
echo "c $c"
echo "to $to"
echo "✓ $tick"
echo "aborted $aborted"
echo "total $total") | column -t

# if [[ "$total" != 1000 ]]; then
#     echo >&2
#     echo "warning: incomplete" >&2
#     # grep -v '^+' $log | grep -v 'different output' \
#     #     | grep -v 'same output' \
#     #     | grep -E -v 'failure \((static|optimised|oracle)\)' \
#     #     | grep -v 'timeout' \
#     #     | grep -v 'same output' \
#     #     | grep -v 'aborted'
# fi
