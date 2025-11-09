#!/usr/bin/env sh

#!/bin/bash
mem_used=$(free -m | awk '/Mem:/ {print $3}')
mem_total=$(free -m | awk '/Mem:/ {print $2}')
echo "  ${mem_used} MB"

