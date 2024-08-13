`timescale 1ms/1us
module testbench;
 
reg reset;
reg clk;
reg [1:0] inhour_msb;
reg [3:0] inhour_lsb;
reg [3:0] inmin_msb;
reg [3:0] inmin_lsb;
reg set_time;
reg set_alarm;
reg alm_off;
reg alm_on;
 
wire alarm;
wire [1:0] hour_msb;
wire [3:0] hour_lsb;
wire [3:0] min_msb;
wire [3:0] min_lsb;
wire [3:0] sec_msb;
wire [3:0] sec_lsb;
 
clock dut(
.reset(reset), 
.clk(clk),
.inhour_msb(inhour_msb),.inhour_lsb(inhour_lsb),
.inmin_msb(inmin_msb),.inmin_lsb(inmin_lsb),.set_time(set_time),
.set_alarm(set_alarm),.alm_off(alm_off),.alm_on(alm_on),.alarm(alarm),
.hour_msb(hour_msb),.hour_lsb(hour_lsb),.min_msb(min_msb),.min_lsb(min_lsb),
.sec_msb(sec_msb),.sec_lsb(sec_lsb));
 
initial begin
clk=0;
forever #500 clk = ~clk;
end
 
initial begin
// Initialize Inputs
reset = 1;
inhour_msb = 1;
inhour_lsb = 0;
inmin_msb = 1;
inmin_lsb = 4;
set_time = 0;
set_alarm = 0;
alm_off = 0;
alm_on = 0; // set clock time to 11h26, alarm time to 00h00 when reset
// Wait 100 ns for global reset to finish
#0.001;
      reset = 0;
inhour_msb = 1;
inhour_lsb = 0;
inmin_msb = 2;
inmin_lsb = 0;
set_time = 0;
set_alarm = 1;
alm_off = 0;
alm_on = 1; // turn on alarm and set the alarm time to 11h30
#0.001; 
reset = 0;
inhour_msb = 1;
inhour_lsb = 0;
inmin_msb = 2;
inmin_lsb = 0;
set_time = 0;
set_alarm = 0;
alm_off = 0;
alm_on = 1; 
wait(alarm); // wait until alarm signal is high when the alarm time equals clock time
#1000
alm_off = 1; // pulse high the alm_off to push low the alarm signal
#1000
alm_off = 0;
inhour_msb = 0;
inhour_lsb = 4;
inmin_msb = 4;
inmin_lsb = 5;
set_time = 1; // set clock time to 11h25
set_alarm = 0;
#1000
alm_off = 0;
inhour_msb = 0;
inhour_lsb = 4;
inmin_msb = 5;
inmin_lsb = 5;
set_alarm = 1; // set alarm time to 11h35
set_time = 0;
wait(alarm); // wait until alarm signal is high when the alarm time equals clock time
#1000
alm_off = 1;
#5000 $finish;// pulse high the alm_off to push low the alarm signal
end
endmodule