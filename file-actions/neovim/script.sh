#! /usr/bin/bash
eval "$(cat ~/.bashrc | tail -n +10)"
FILE=$* konsole -e /snap/bin/nvim '$FILE'
