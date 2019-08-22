set data [gets stdin]
scan $data "%d %d" inp1 inp2

set ns  [new Simulator]

$ns color 0 Ornage
$ns color 1 Green
$ns color 2 Brown
$ns color 3 Red
$ns color 4 White
$ns color 5 Cyan
$ns color 6 Blue
$ns color 7 Yellow

set nf [open out.nam w]
$ns namtrace-all $nf

proc finish {} {
    global ns nf
    $ns flush-trace
    close $nf
    exec nam out.nam
    exit 0
}

for {set i 0} {$i < $inp1} {incr i} {
	set n($i) [$ns node]
}

for {set i 1} {$i < $inp1} {incr i} {
	$ns duplex-link $n(0) $n($i) 512Kb 5ms DropTail
}

for {set i 0} {$i < $inp2} {incr i} {
	set input [gets stdin]
	scan $input "%d %d" u v
	set tcp [new Agent/TCP]
	$ns attach-agent $n($u) $tcp
	$tcp set class_ $i
	set sink [new Agent/TCPSink]
	$ns attach-agent $n($v) $sink
	$ns connect $tcp $sink
	set ftp0 [new Application/FTP]
	$ftp0 attach-agent $tcp
	$ns at 0.1 "$ftp0 start"
	$ns at 1.5 "$ftp0 stop"
}

$ns at 2.0 "finish"
$ns run
