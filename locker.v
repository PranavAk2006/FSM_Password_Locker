`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.06.2026 19:59:25
// Design Name: 
// Module Name: locker
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module locker(input clk,rst,d_in,submit,reset_sys,
                output reg locked,unlocked);
      parameter idle=3'b000;
      parameter s0=3'b001;
      parameter s1=3'b010;
      parameter s2=3'b011;
      parameter s3=3'b100;
      parameter error=3'b101;
      parameter blocked=3'b110;
      
      reg [2:0] ps,ns;
      reg [1:0] count=2'b00;
      
      
      
      //present state
      
      always@(posedge clk or posedge rst or posedge reset_sys) begin
        if(reset_sys) begin
            count<=2'b00;
            ps<=idle;
            end
        else if(rst)
            begin
                ps<=idle;
            end
         
        else if(ps==error  && submit) begin
            if(count==2) begin
             count<=2'b11;
             ps<=blocked;
             end
             else begin
                count<=count+1'b1;
                ps<=idle;
                end
                end
        
        else 
            begin 
                ps<=ns;
        end 
        
     
      end
      
      //next state combi
      always@(*)
        begin
            ns=ps;
            
            case(ps)
                idle:begin
                    
                        if(d_in)
                            ns=s0;
                        else
                            ns=error;
                     end
                s0:begin
                    if(d_in)
                        ns=s1;
                    else
                        ns=error;
                   end
                s1: begin
                        if(!d_in)
                            ns=s2;
                        else
                            ns=error;
                    end
                s2: begin
                 
                        if(d_in)
                            ns=s3;
                        else 
                            ns=error;
                      end
                      
                 s3:begin                
                    if(submit) begin
                        ns=idle;
                        end
                    else
                        ns=s3;
                     end
                     
                 error:begin
                            if(submit) begin
                                    
                                    
                                    ns=idle;
                                end
                             else
                                ns=error;
                        end
                  blocked:
                        ns=blocked;
                  default: ns=idle;             
          endcase
          
       end
     
       
       //output combi
       
       always@(*)
       begin
        case(ps)
           idle:
                begin
                    {locked,unlocked}=2'b10;
                end
           s0:
            {locked,unlocked}=2'b10;
           s1:
            {locked,unlocked}=2'b10;
           s2:
            {locked,unlocked}=2'b10;
           s3: begin
                if(submit)
                    {locked,unlocked}=2'b01;
                else
                    {locked,unlocked}=2'b10;
                end
           error:
                {locked,unlocked}=2'b10;
           blocked:
            {locked,unlocked}=2'b10;
           default:
            {locked,unlocked}=2'b10;
      endcase
            
     end      
               
 endmodule
