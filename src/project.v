/*
 * Copyright (c) 2024 Ayra 3project
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_ayra (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

  // All output pins must be assigned. If not used, assign to 0.
  //assign uo_out  = ui_in + uio_in;  // Example: ou_out is the sum of ui_in and uio_in
  assign uio_out = 8'b0;
  assign uio_oe  = 8'b0;

  reg [2:0] ball = 3;
  reg dir = 1;
  reg [23:0] counter = 0;

  always @(posedge clk) begin 
    if (!rst_n) begin 
      ball <= 3;
      dir <= 1;
      counter <= 0;
    end
    else begin 
      counter <= counter + 1;
      if (counter == 0) begin
        if (dir) 
          ball <= ball + 1;
        else
          ball <= ball - 1;
        if (ball == 0) begin 
          if (ui_in[0])
            dir <= 1;
          else 
            ball <= 3;
        end  
        if (ball == 7) begin 
          if (ui_in[1])
            dir <= 0;
          else 
             ball <= 3;
        end
      end 
    end 
  end
 assign uo_out = 8'b00000001 << ball;
  // List all unused inputs to prevent warnings
  wire _unused = &{ena, uio_in};

endmodule
