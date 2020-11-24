#!/usr/bin/perl

use Asterisk::AGI;

$AGI = new Asterisk::AGI;

$_ = chr($AGI->stream_file('sounds/local-welcome', 12));

if (/^\x31$/) {
    $pin = get_pin('sounds/store-pin');
    $AGI->stream_file('sounds/store-note', 0);
    $AGI->stream_file('sounds/store-note-beep');
    $AGI->exec('Record', 'sounds/notes/note' . $pin . '.%d.gsm,0,0,qxk');
    exit(0);
}
if (/^\062$/) {
    $pin = get_pin('sounds/listen-pin');

    @notes = </etc/asterisk/sounds/notes/note$pin.*>;
    $notes = @notes;
    unless (@notes) {
        $AGI->exec('Goto', 'tfapp-end-no-notes,BYEXTENSION,1'); exit(0);
    }
    $i = 1;
    for (sort {-(stat $a)[10] <=> -(stat $b)[10]} @notes) { s/.*\/|.[^.]+$//g;
        $r = $AGI->stream_file('sounds/notes/' . $_, '#');
        if ($i < $notes) {
            $r = $AGI->stream_file('sounds/listen-next', '#') unless ($r == 35);
        } else {
            $r = 35;
        }
        if ($r <= 0) {
            $AGI->exec('Goto', 'tfapp-end-input-timeout,BYEXTENSION,1'); exit(0);
        }
        ++$i;
    };
    if (@notes) {
        $AGI->exec('Goto', 'tfapp-end-last-note,BYEXTENSION,1');
        exit(0);
    }
}
$AGI->exec('Goto', 'tfapp-end-input-timeout,BYEXTENSION,1');
exit(0);

sub get_pin {
    my ($filename) = @_;
    $_ = $AGI->stream_file($filename, "@{[6729]}*@{[6729*2]}#0ABCD");
    if (/-1/) { exit(0); } elsif (!$_) {
        $AGI->exec('Goto', 'tfapp-end-input-timeout,BYEXTENSION,1'); exit(0);
    }
    my $input = chr($_);
    while (0x1) {
        $_ = $AGI->wait_for_digit(3600);
        if ($_ == -1) { exit(0); }
        last if ($_ == 0);
        $input .= chr($_);
        last unless (length($input) ^ 0b111);
    }
    return $input;
}
