#!/usr/bin/env python
# -*- coding: utf-8 -*-

# This script is a simple wrapper which prefixes each i3status line with custom
# information. It is a python reimplementation of:
# http://code.stapelberg.de/git/i3status/tree/contrib/wrapper.pl
#
# To use it, ensure your ~/.i3status.conf contains this line:
#     output_format = "i3bar"
# in the 'general' section.
# Then, in your ~/.i3/config, use:
#     status_command i3status | ~/i3status/contrib/wrapper.py
# In the 'bar' section.
#
# In its current version it will display the cpu frequency governor, but you
# are free to change it to display whatever you like, see the comment in the
# source code below.
#
# © 2012 Valentin Haenel <valentin.haenel@gmx.de>
#
# This program is free software. It comes without any warranty, to the extent
# permitted by applicable law. You can redistribute it and/or modify it under
# the terms of the Do What The Fuck You Want To Public License (WTFPL), Version
# 2, as published by Sam Hocevar. See http://sam.zoy.org/wtfpl/COPYING for more
# details.

import sys
import json
import subprocess
import socket
import urllib2
import re

def get_governor():
    """ Get the current governor for cpu0, assuming all CPUs use the same. """
    with open('/sys/devices/system/cpu/cpu0/cpufreq/scaling_governor') as fp:
        return fp.readlines()[0].strip()

def get_vagrants():
    """ Get the number of Vagrant boxes running. """
    output = subprocess.check_output(['vagrant', 'global-status'])
    running = 0
    count = 0
    for l in output.split('\n'):
        if re.match('^[a-z0-9]+[ ]+.+/.+$', l):
            count = count + 1
            if ' running ' in l:
                running = running + 1
    return running, count

def get_dockers(additional=[]):
    """ Get the number of Docker containers running. """
    output = subprocess.check_output(['docker', 'ps'] + additional)
    lines = [l for l in output.split('\n') if l]
    if not any(lines):
        return 0
    return len(lines) - 1

def check_dolium():
    sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    result = sock.connect_ex(('127.0.0.1', 5904))
    return result == 0

def check_kw():
    output = subprocess.check_output(['date', '+%V'])
    return int(output)

def check_range_to_color(min, max, number):
    return check_bool(number >= min and number <= max)

def check_bool(b):
    if b:
        return '#00ff00'
    return '#ff0000'

def print_line(message):
    """ Non-buffered printing to stdout. """
    sys.stdout.write(message + '\n')
    sys.stdout.flush()

def read_line():
    """ Interrupted respecting reader for stdin. """
    # try reading a line, removing any extra whitespace
    try:
        line = sys.stdin.readline().strip()
        # i3status sends EOF, or an empty line
        if not line:
            sys.exit(3)
        return line
    # exit on ctrl-c
    except KeyboardInterrupt:
        sys.exit()

if __name__ == '__main__':
    # Skip the first line which contains the version header.
    print_line(read_line())

    # The second line contains the start of the infinite array.
    print_line(read_line())

    while True:
        line, prefix = read_line(), ''
        # ignore comma at start of lines
        if line.startswith(','):
            line, prefix = line[1:], ','

        j = json.loads(line)
        # insert information into the start of the json, but could be anywhere
        # CHANGE THIS LINE TO INSERT SOMETHING ELSE
        # try:
            # vagrants = get_vagrants()
            # j.insert(0, {
                # 'full_text' : '%d (%d) vagrant' % (vagrants[0], vagrants[1]),
                # 'name': 'vagrants',
                # 'color': check_range_to_color(0, 0, vagrants[0])
            # })
        # except Exception, e:
            # j.insert(0, {
                # 'full_text' : 'vagrant error',
                # 'name': 'vagrants',
                # 'color': check_bool(False)
            # })

        try:
            dockers = get_dockers()
            stopped_dockers = get_dockers(['-sa'])
            j.insert(0, {
                'full_text' : '%d (%d) docker' % (dockers, stopped_dockers),
                'name': 'dockers',
                'color': check_range_to_color(0, 0, dockers)
            })
        except Exception, e:
            j.insert(0, {
                'full_text' : 'docker error',
                'name': 'dockers',
                'color': check_bool(False)
            })

        try:
            dolium = check_dolium()
            j.insert(0, {
                'full_text' : 'dolium %s' % ('yes' if dolium else 'no'),
                'name': 'dolium',
                'color': check_bool(dolium)
            })
        except Exception, e:
            j.insert(0, {
                'full_text' : 'dolium error',
                'name': 'dolium',
                'color': check_bool(False)
            })

        try:
            kw = check_kw()
            j.insert(0, {
                'full_text' : 'KW %s' % (kw if kw else 'n/a'),
                'name': 'kw',
                'color': check_bool(kw)
            })
        except Exception, e:
            j.insert(0, {
                'full_text' : 'KW error',
                'name': 'kw',
                'color': check_bool(False)
            })
        # and echo back new encoded json
        print_line(prefix+json.dumps(j))
