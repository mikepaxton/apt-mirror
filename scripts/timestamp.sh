#!/bin/bash
while read x; do
    echo -n `date +%m/%d/%Y\ %H:%M:%S`;
    echo -n " ";
    echo $x;
done
