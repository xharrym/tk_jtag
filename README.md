tk_jtag : Access an Altera FPGA via JTAG
=======

Based on the work here: http://idle-logic.com/2012/04/15/talking-to-the-de0-nano-using-the-virtual-jtag-interface/

I just added a Tk form to connect to the FPGA and send/receive data via a simple GUI.

![Alt text](/screenshot2.png?raw=true "Form Screenshot")

*Commands of the form:*

- Connect: connect to the FPGA;
- Update LEDs: send to the FPGA the "binary string" set on the first row of check boxes, and update the LEDs on the DE0-nano accordingly;
- Read Switches Value: receive a "binary string" from the FPGA and visualize it the second row of check boxes (it is the state of the DIP-switches on the DE0-nano)

**Files:**

- *form.tcl* : the Tcl/Tk form code.
- *connect.v* : Verilog script for the component that manages the data to/from the JTAG.
- *jtagConnect.qar* : Quartus II project file (for DE0 nano, if you are using something else you will need to change the pin assignment and the FPGA type.

After having programmed the FPGA, in order to try everything use quartus_stp.exe with this command:

*quartus_stp.exe -t PATH*

where PATH is the path to the form.tcl file, and -t means to use an external Tcl script.
