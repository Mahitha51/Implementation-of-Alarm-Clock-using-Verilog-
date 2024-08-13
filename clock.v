module clock(
input reset,
input clk,
input [1:0] inhour_msb,
input [3:0] inhour_lsb,
input [3:0] inmin_msb,
input [3:0] inmin_lsb,
 
input set_time,
input set_alarm,
input alm_off,
input alm_on,
 
output reg alarm,
 
output reg [1:0] hour_msb,
output reg [3:0] hour_lsb,
output reg [3:0] min_msb,
output reg [3:0] min_lsb,
output reg [3:0] sec_msb,
output reg [3:0] sec_lsb
);
 
reg [5:0] tmp_hour, tmp_minute, tmp_second;
reg [1:0] a_hour_msb;
reg [3:0] a_hour_lsb,a_min_msb,a_min_lsb,a_sec_msb,a_sec_lsb;
function [3:0] mod10;
 input [5:0] number;
 begin
 mod10 = (number >=50) ? 5 : ((number >= 40)? 4 :((number >= 30)? 3 :((number >= 20)? 2 :((number >= 10)? 1 :0))));
 end
 endfunction
 
always@(posedge clk or posedge reset)
begin
if(reset) begin
a_hour_msb<=2'b00;
a_hour_lsb<=4'b0000;
a_min_msb<=4'b0000;
a_min_lsb<=4'b0000;
a_sec_msb<=4'b0000;
a_sec_lsb<=4'b0000;
 
tmp_hour<=inhour_msb*10+inhour_lsb;
tmp_minute<=inmin_msb*10+inmin_lsb;
tmp_second<=0;
end
 
else begin 
if(set_alarm) begin
a_hour_msb<=inhour_msb;
a_hour_lsb<=inhour_lsb;
a_min_msb<=inmin_msb;
a_min_lsb<=inmin_lsb;
a_sec_msb<=4'b0000;
a_sec_lsb<=4'b0000;
end
 
if(set_time) begin
tmp_hour<=inhour_msb*10+inhour_lsb;
tmp_minute<=inmin_msb*10+inmin_lsb;
tmp_second<=0;
end
 
else begin
tmp_second <= tmp_second + 1;
if(tmp_second >=59) begin // second > 59 then minute increases
tmp_minute <= tmp_minute + 1;
tmp_second <= 0;
if(tmp_minute >=59) begin // minute > 59 then hour increases
tmp_minute <= 0;
tmp_hour <= tmp_hour + 1;
if(tmp_hour >= 24) begin // hour > 24 then set hour to 0
tmp_hour <= 0;
end 
end 
end
end
end
end
always@(*) begin
if(tmp_hour>=20) begin
hour_msb<=2;
end
else begin
if(tmp_hour>=10)
hour_msb<=1;
else
hour_msb<=0;
end
hour_lsb = tmp_hour - hour_msb*10; 
min_msb = mod10(tmp_minute); 
min_lsb = tmp_minute - min_msb*10;
sec_msb = mod10(tmp_second);
sec_lsb = tmp_second - sec_msb*10; 
end
 
always @(posedge clk or posedge reset) begin
if(reset)
alarm<=0;
else begin
if({a_hour_msb,a_hour_msb,a_min_msb,a_min_lsb,a_sec_msb,a_sec_lsb}=={hour_msb,hour_lsb,min_msb,min_lsb,sec_msb,sec_lsb})
begin
if(alm_on) alarm<=1;
end
if(alm_off) alarm<=0;
end
end
 
endmodule