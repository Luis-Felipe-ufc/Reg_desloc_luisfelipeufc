`timescale 1ns/10ps
module reg_desloc (
    input logic clk,                // Clock
    input logic reset,              // Reset assíncrono
    input logic [1:0] op,           // Operação de seleção (00, 01, 10, 11)
    input logic [3:0] parallel_in,  // Entrada paralela de 4 bits
    input logic serial_in,          // Entrada serial de 1 bit
    output logic [3:0] out          // Saída do registrador de 4 bits
);

    // Registrador de 4 bits
    logic [3:0] reg_out;

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            reg_out <= 4'b0000; // Reset do registrador
        end else begin
            case (op)
                2'b00: reg_out <= reg_out;             // NOP (Nenhuma operação)
                2'b01: reg_out <= {reg_out[2:0], serial_in}; // SHL (Deslocamento para a esquerda)
                2'b10: reg_out <= {serial_in, reg_out[3:1]}; // SHR (Deslocamento para a direita)
                2'b11: reg_out <= parallel_in;         // LOAD (Carregamento paralelo)
                default: reg_out <= reg_out;           // Default (sem alteração)
            endcase
        end
    end

    // A saída é o valor do registrador
    assign out = reg_out;

endmodule
