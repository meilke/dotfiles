#!/bin/bash

scrot -e 'convert $f -blur 5x5 $f && i3lock -i $f && rm $f'
