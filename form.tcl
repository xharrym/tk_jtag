#Tcl/Tk Form used to communicate via JTAG to the FPGA
#harrym 2014

proc send_data {} {
	global d0 d1 d2 d3 d4 d5 d6 d7 displayData
	set led ""
	set one 1
	set zero 0

	if {$d0 == 1} {set led $led$one} else {set led $led$zero}
	if {$d1 == 1} {set led $led$one} else {set led $led$zero}
	if {$d2 == 1} {set led $led$one} else {set led $led$zero}
	if {$d3 == 1} {set led $led$one} else {set led $led$zero}
	if {$d4 == 1} {set led $led$one} else {set led $led$zero}
	if {$d5 == 1} {set led $led$one} else {set led $led$zero}
	if {$d6 == 1} {set led $led$one} else {set led $led$zero}
	if {$d7 == 1} {set led $led$one} else {set led $led$zero}

	set displayData "Data sent: $led"

	open_port
	device_lock -timeout 10000

	#send instruction "1" ( = update LEDs w/ new data)
	device_virtual_ir_shift -instance_index 0 -ir_value 1 -no_captured_ir_value
	#send 8bits of data
	device_virtual_dr_shift -dr_value $led -instance_index 0  -length 8 -no_captured_dr_value
	#send instruction "0" ( = bypass)
	device_virtual_ir_shift -instance_index 0 -ir_value 0 -no_captured_ir_value

	close_port
}
proc open_port {} {
	global usbblaster_name
	global test_device
	open_device -hardware_name $usbblaster_name -device_name $test_device
}

proc close_port {} {
	catch {device_unlock}
	catch {close_device}
}

proc connect_jtag {} {
	global usbblaster_name
	global test_device
	global displayConnect

	foreach hardware_name [get_hardware_names] {

		if { [string match "USB-Blaster*" $hardware_name] } {
			set usbblaster_name $hardware_name
		}
	}

	foreach device_name [get_device_names -hardware_name $usbblaster_name] {
		if { [string match "@1*" $device_name] } {
			set test_device $device_name
		}
	}
	set displayConnect "Connected: $hardware_name \n $device_name"
	.btnConn configure -state disabled
}


global usbblaster_name
global test_device

set displayData ""
set  displayConne "Press Connect!"

#Form Setup
package require Tk
init_tk

wm state . normal
wm title . "LEDs Manager"
frame .frmConnection
label .lblConn -textvariable displayConnect
button .btnConn -text "Connect" -command "connect_jtag"

frame .frmData
checkbutton .chk0 -variable d0
checkbutton .chk1 -variable d1
checkbutton .chk2 -variable d2
checkbutton .chk3 -variable d3
checkbutton .chk4 -variable d4
checkbutton .chk5 -variable d5
checkbutton .chk6 -variable d6
checkbutton .chk7 -variable d7
button .btnSend -text "Send Data" -command "send_data"
label .lblData -textvariable displayData

grid .frmConnection -in .  -row 1 -column 1 -columnspan 8
grid .btnConn -in .frmConnection -row 1 -column 1
grid .lblConn -in .frmConnection -row 2 -column 1

grid .frmData -in .  -row 2 -column 1
grid .chk0 -in .frmData -row 1 -column 1
grid .chk1 -in .frmData -row 1 -column 2
grid .chk2 -in .frmData -row 1 -column 3
grid .chk3 -in .frmData -row 1 -column 4
grid .chk4 -in .frmData -row 1 -column 5
grid .chk5 -in .frmData -row 1 -column 6
grid .chk6 -in .frmData -row 1 -column 7
grid .chk7 -in .frmData -row 1 -column 8
grid .btnSend -in .frmData -row 2 -column 1 -columnspan 8
grid .lblData -in .frmData -row 3 -column 1 -columnspan 8

tkwait window .
