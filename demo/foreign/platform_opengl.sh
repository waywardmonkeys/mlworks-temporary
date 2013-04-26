#!/bin/sh
#
# Copyright 1997 The Harlequin Group Limited.  All rights reserved.
#
# See <URI:hope://MLW/demo/foreign/README#platform.opengl>
#
# Revision Log
# ------------
# $Log: platform_opengl.sh,v $
# Revision 1.2  1997/05/14 15:15:43  stephenb
# [Bug #20035]
# OS -> $OS.  This should have been in the previous change.
#
# Revision 1.1  1997/05/13  12:58:13  stephenb
# new unit
# [Bug #20035]
#

mlw_os=${1:-$OS}

case "$mlw_os" in
  NT|Irix) exit 0;;
  *) exit 1;;
esac