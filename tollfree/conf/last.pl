#!/usr/bin/perl

use Asterisk::AGI;

$AGI = new Asterisk::AGI;

$_ = `ls -1t /etc/asterisk/sounds/notes | grep gsm | head -n1`; s/\.[^.]+$//;
$AGI->stream_file('sounds/notes/' . $_);

exit(0);
