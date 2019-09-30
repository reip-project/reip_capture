#!/bin/bash
rand=$(shuf -i 0-60 -n 1)
/sbin/shutdown -r +$rand
