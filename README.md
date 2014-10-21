tk_jtag : Access an Altea FPGA via JTAG
=======

Based on the work here: http://idle-logic.com/2012/04/15/talking-to-the-de0-nano-using-the-virtual-jtag-interface/

I just added a Tk form to connect to the FPGA and send data via a simple GUI.

![Alt text](/screenshot.png?raw=true "Form Screenshot")

Files:
1) form.tcl : the Tcl/Tk form code.
2) interface_LED.v : Verilog script for the component that manages the incoming data from the JTAG and updates the LEDs.
3) JTAG_connect.qar : Quartus II project file (for DE0 nano, if you are using something else you will need to change the pin assignment and the FPGA type.

After having programmed the FPGA, in order to try the program use quartus_stp.exe with this command:



*quartus_stp.exe -t PATH*

where PATH is the path to the form.tcl file, and -t means to use an external Tcl script.
