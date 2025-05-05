module Sequencia (
    input wire clk,
    input wire rst_n,

    input wire setar_palavra,
    input wire [7:0] palavra,

    input wire start,
    input wire bit_in,

    output reg encontrado
);

reg [7:0] palavra_reg; // Variável para guardar a palavra
reg [7:0] registrador; // Registrador para armazenar os bits recebidos
reg ativo; // Variável para indicar se o processo de comparação está ativo

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin // Reset
        palavra_reg <= 8'b0;
        encontrado <= 1'b0;
        registrador <= 8'b0;
        ativo <= 1'b0;
    end else begin
        if(setar_palavra) begin // Se setar_palavra = 1, armazena a nova palavra
            palavra_reg <= palavra; // Armazena a nova palavra
            encontrado <= 1'b0; // Palavra não foi buscada ou encontrada, então é 0
            registrador <= 8'b0; // Reseta o registrador quando uma nova palavra é definida
            ativo <= 1'b0; // Processo de comparação não está ativo, então é 0
        end else if(start) begin // Verifica se o processo de comparação deve começar
            ativo <= 1'b1; // Ativa o processo de comparação
            encontrado <= 1'b0; // Reseta encontrado para 0
            registrador <= {registrador[6:0], bit_in}; // Desloca o bit de entrada para o registrador (esquerda)
        end else if(ativo && !encontrado) begin // Se o processo de comparação estiver ativo e a palavra não foi encontrada
            registrador <= {registrador[6:0], bit_in}; // Continua deslocando o registrador enquanto ativo e não encontrado
            if(registrador == palavra_reg) begin // Se o registrador for igual à palavra
                encontrado <= 1'b1; // Se o registrador for igual à palavra, define encontrado como 1
            end else begin 
                encontrado <= 1'b0; // Caso contrário, mantém encontrado como 0
            end
        end
    end
end

endmodule
