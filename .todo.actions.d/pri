#!/bin/bash

action=$1
shift

[ "$action" = "usage" ] && {
    echo "pri ITEM#[, ITEM#, ITEM#, ...] PRIORITY"
    echo "  For each ITEM#, calls command pri with priority PRIORITY."
    echo ""
    exit
}

for pri; do true; done

for i in $(seq 1 `expr $# - 1`); do
    $TODO_SH command pri ${!i} $pri;
done
