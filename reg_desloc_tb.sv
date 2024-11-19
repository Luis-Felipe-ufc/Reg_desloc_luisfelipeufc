`timescale 1ns/10ps
module reg_desloc_tb;
  logic [3:0] parallel_in, out;
  logic [1:0] op;
  logic clk, reset, serial_in;
  
  // instantiating the module to map connections
  reg_desloc regd(.clk(clk), .reset(reset), .serial_in(serial_in), .parallel_in(parallel_in), 
  .out(out), .op(op)
  );
  
  // Gerador de clock
initial begin
  clk = 0;  
  forever
  #5 clk = ~clk;
end

initial begin
  serial_in = 1;
  forever
  #50 serial_in = ~serial_in;    //troca o bit de entrada
end

initial begin
  forever begin
  #10  
$display($time ,"      %b         %b         %b        %b",op, parallel_in, serial_in, out);
  end
end
  
initial
    begin
      $display("                                     Entradas             Saída");
      $display("                        ================================  ======");
      $display("                 Tempo    op     Parallel In  Serial In    out");
      $display("                 =====  ======  ============ ===========  ======");
      $display($time ,"      %b         %b         %b        %b",op, parallel_in, serial_in, out);
    end

 initial begin
  reset = 0;
  parallel_in = 4'b1111;
  repeat (2) begin
  op = 2'b00;             // sem alterações
  #10;
  op = 2'b01;             // desloca para esquerda até ser 1111
  #45;
  op = 2'b10;             // desloca para direita até ser 0000
  #40;
  op = 2'b11;             // carrega 1111
  #5;
  reset = 1;              // "reseta" e repete o processo
  #10ps;
  reset = 0;
  end
  parallel_in = 4'b1010;  // carrega 1010
  #10
$finish();
  end

endmodule
