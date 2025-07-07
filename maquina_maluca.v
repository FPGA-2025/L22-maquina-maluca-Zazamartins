module maquina_maluca (
    input  wire clk,
    input  wire rst_n,
    input  wire start,
    output wire [3:0] state
);

    localparam IDLE                = 4'd1;
    localparam LIGAR_MAQUINA       = 4'd2;
    localparam VERIFICAR_AGUA      = 4'd3;
    localparam ENCHER_RESERVATORIO = 4'd4;
    localparam MOER_CAFE           = 4'd5;
    localparam COLOCAR_NO_FILTRO   = 4'd6;
    localparam PASSAR_AGITADOR     = 4'd7;
    localparam TAMPEAR             = 4'd8;
    localparam REALIZAR_EXTRACAO   = 4'd9;

    reg [3:0] current_state, next_state;
    reg agua_enchida;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            current_state <= IDLE; // Inicia em IDLE
            agua_enchida  <= 1'b0; // Reservatório vazio
        end else begin
            current_state <= next_state;

            if (current_state == ENCHER_RESERVATORIO)
                agua_enchida <= 1'b1; // Ao encher marca como cheio (1)
        end
    end

    // Lógica de próxima transição com erros
    always @(*) begin
        next_state = IDLE; // Default para next_state
        case (current_state) 
            IDLE: begin // Estando em IDLE, ao detectar start=1 inicia ciclo ligando a máquina
                if (start)
                    next_state = LIGAR_MAQUINA;
                else
                    next_state = IDLE;
            end

            LIGAR_MAQUINA:
                next_state = VERIFICAR_AGUA;

            VERIFICAR_AGUA: begin
                if (!agua_enchida)
                    next_state = ENCHER_RESERVATORIO;
                else
                    next_state = MOER_CAFE;
            end

            // transições de estado conforme o fluxograma
            ENCHER_RESERVATORIO:
                next_state = VERIFICAR_AGUA;

            MOER_CAFE:
                next_state = COLOCAR_NO_FILTRO;

            COLOCAR_NO_FILTRO:
                next_state = PASSAR_AGITADOR;

            PASSAR_AGITADOR:
                next_state = TAMPEAR;

            TAMPEAR:
                next_state = REALIZAR_EXTRACAO;

            REALIZAR_EXTRACAO:
                next_state = IDLE;

            default:
                next_state = IDLE;
        endcase
    end


    assign state = current_state;

endmodule