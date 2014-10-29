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
	device_virtual_ir_shift -instance_index 0 -ir_value 2 -no_captured_ir_value
	set l [device_virtual_dr_shift -dr_value $led -instance_index 0  -length 8]
	puts $l
	device_virtual_ir_shift -instance_index 0 -ir_value 0 -no_captured_ir_value
	close_port
}

proc read_switch {} {
	open_port
	device_lock -timeout 10000
	device_virtual_ir_shift -instance_index 0 -ir_value 1 -no_captured_ir_value
	set dip [device_virtual_dr_shift -dr_value 0000 -instance_index 0 -length 4]

	device_virtual_ir_shift -instance_index 0 -ir_value 0 -no_captured_ir_value
	close_port

	if {[string index $dip 0] == 1} {.chks0 select} else {.chks0 deselect}
	if {[string index $dip 1] == 1} {.chks1 select} else {.chks1 deselect}
	if {[string index $dip 2] == 1} {.chks2 select} else {.chks2 deselect}
	if {[string index $dip 3] == 1} {.chks3 select} else {.chks3 deselect}

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
	.btnSend configure -state active
	.btnRead configure -state active
}


global usbblaster_name
global test_device

set displayData "No Data Sent"
set  displayConnect "Press Connect!"

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
button .btnSend -text "Update LEDs" -command "send_data"
label .lblData -textvariable displayData

frame .frmSwitch
checkbutton .chks0
checkbutton .chks1
checkbutton .chks2
checkbutton .chks3
button .btnRead -text "Read Switches Value" -command "read_switch"

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
grid .btnSend -in .frmData -row 2 -column 1 -columnspan 4
grid .lblData -in .frmData -row 2 -column 5 -columnspan 4

grid .frmSwitch -in .  -row 3 -column 1
grid .chks0 -in .frmSwitch -row 1 -column 1
grid .chks1 -in .frmSwitch -row 1 -column 2
grid .chks2 -in .frmSwitch -row 1 -column 3
grid .chks3 -in .frmSwitch -row 1 -column 4
grid .btnRead -in .frmSwitch -row 1 -column 5 -columnspan 4

.btnSend configure -state disabled
.btnRead configure -state disabled

.chks0 configure -state disabled
.chks1 configure -state disabled
.chks2 configure -state disabled
.chks3 configure -state disabled

tkwait window .
