#!/bin/bash

case $# in
0) s=0; e=0;;
1) s=$1; e=0;;
2) s=$1; e=$2;;
esac

n=0
m=0
k=0
while read line; do
    [ ${#line} -eq 0 ] && continue
    num="$(echo "$line" | cut -d: -f1)"
    [ ${num:0:1} = '#' ] && continue
    num=$((10#$num))
    kanji[$n]="$(echo "$line" | cut -d: -f4)"
    n=$(($n+1))
    [ $num -ne 0 ] && k=$(($k+1))
    OFS="$IFS"
    IFS="/"
    for alt in $(echo "$line" | cut -d: -f5); do
        [ "$alt" = "-" ] && break
        kanji[$n]="$alt"
        n=$(($n+1))
    done
    if [ $s -eq 0 -o $s -eq $num ]; then
        s=0
        for prim in $(echo "$line" | cut -d: -f6); do
            [ "$prim" = "-" ] && break
            for (( x=0; x<$n; x++ )); do
                [ "$prim" = "${kanji[$x]}" ] && break
            done
            [ $x -eq $n ] && echo "$num: $prim"
        done
    fi
    IFS="$OFS"
    if [ $(($k-$m)) -ge 100 ]; then
        m=$(($m+100))
        echo $k
    fi
    [ $e -ne 0 -a $num -eq $e ] && break
done < primitives
