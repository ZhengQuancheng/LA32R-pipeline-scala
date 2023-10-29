// Generated by CIRCT firtool-1.56.1

    
//  Xilinx Simple Dual Port Single Clock RAM
//  This code implements a parameterizable SDP single clock memory.
//  If a reset or enable is not necessary, it may be tied off or removed from the code.

 module xilinx_simple_dual_port_1_clock_ram #(
     parameter RAM_WIDTH = 64,                       // Specify RAM data width
     parameter RAM_DEPTH = 512                      // Specify RAM depth (number of entries)
   ) (
     input [$clog2(RAM_DEPTH)-1:0] addra, // Write address bus, width determined from RAM_DEPTH
     input [$clog2(RAM_DEPTH)-1:0] addrb, // Read address bus, width determined from RAM_DEPTH
     input [RAM_WIDTH-1:0] dina,          // RAM input data
     input clka,                          // Clock
     input wea,                           // Write enable
     input enb,                           // Read Enable, for additional power savings, disable when not in use
     output [RAM_WIDTH-1:0] doutb         // RAM output data
   );
   (*ram_style="block"*)
     reg [RAM_WIDTH-1:0] BRAM [RAM_DEPTH-1:0];
     reg [RAM_WIDTH-1:0] ram_data = {RAM_WIDTH{1'b0}};
   
     // The following code either initializes the memory values to a specified file or to all zeros to match hardware
     always @(posedge clka) begin
       if (wea)
         BRAM[addra] <= dina;
       if (enb)
         ram_data <= BRAM[addrb];
     end
   
     //  The following code generates HIGH_PERFORMANCE (use output register) or LOW_LATENCY (no output register)
     assign doutb = ram_data;
   endmodule
