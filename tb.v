`timescale 1ns/1ps

module tb();

  // sinais de estímulo e observação
  reg        clk = 0;
  reg        rst_n;
  reg        start;
  wire [3:0] state;

  // instância do DUT
  maquina_maluca dut (
    .clk   (clk),
    .rst_n (rst_n),
    .start (start),
    .state (state)
  );

  always #1 clk = ~clk;

  initial begin
    $dumpfile("saida.vcd");
    $dumpvars(0, tb, dut);

    // reset via clock
    start  = 0;
    rst_n  = 0;
    repeat (2) @(posedge clk);
    rst_n  = 1;
    @(posedge clk);

    // após reset, deve estar em IDLE
    if (state === 4'd1)
      $display("OK 1.1: após reset, state=IDLE");
    else
      $display("ERRO 1.1: após reset, esperado IDLE(1), obteve=%0d", state);

    // pulso de start alinhado ao clock
    @(posedge clk);
    start = 1;
    @(posedge clk);
    start = 0;

    // verificar sequência de estados a cada posedge
    @(posedge clk);
    if (state === 4'd2)
      $display("OK 1.2: state=LIGAR_MAQUINA");
    else
      $display("ERRO 1.2: esperado LIGAR_MAQUINA(2), obteve=%0d", state);

    @(posedge clk);
    if (state === 4'd3)
      $display("OK 1.3: state=VERIFICAR_AGUA");
    else
      $display("ERRO 1.3: esperado VERIFICAR_AGUA(3), obteve=%0d", state);

    @(posedge clk);
    if (state === 4'd4)
      $display("OK 1.4: state=ENCHER_RESERVATORIO");
    else
      $display("ERRO 1.4: esperado ENCHER_RESERVATORIO(4), obteve=%0d", state);

    @(posedge clk);
    if (state === 4'd3)
      $display("OK 1.5: state=VERIFICAR_AGUA (após encher)");
    else
      $display("ERRO 1.5: esperado VERIFICAR_AGUA(3), obteve=%0d", state);

    @(posedge clk);
    if (state === 4'd5)
      $display("OK 1.6: state=MOER_CAFE");
    else
      $display("ERRO 1.6: esperado MOER_CAFE(5), obteve=%0d", state);

    @(posedge clk);
    if (state === 4'd6)
      $display("OK 1.7: state=COLOCAR_NO_FILTRO");
    else
      $display("ERRO 1.7: esperado COLOCAR_NO_FILTRO(6), obteve=%0d", state);

    @(posedge clk);
    if (state === 4'd7)
      $display("OK 1.8: state=PASSAR_AGITADOR");
    else
      $display("ERRO 1.8: esperado PASSAR_AGITADOR(7), obteve=%0d", state);

    @(posedge clk);
    if (state === 4'd8)
      $display("OK 1.9: state=TAMPEAR");
    else
      $display("ERRO 1.9: esperado TAMPEAR(8), obteve=%0d", state);

    @(posedge clk);
    if (state === 4'd9)
      $display("OK 1.10: state=REALIZAR_EXTRACAO");
    else
      $display("ERRO 1.10: esperado REALIZAR_EXTRACAO(9), obteve=%0d", state);

    @(posedge clk);
    if (state === 4'd1)
      $display("OK 1.11: state=IDLE (fim de ciclo)");
    else
      $display("ERRO 1.11: esperado IDLE(1), obteve=%0d", state);

    // Ciclo com reservatório já cheio
    @(posedge clk);
    @(posedge clk);
    start = 1;
    @(posedge clk);
    start = 0;

    @(posedge clk);
    if (state === 4'd2)
      $display("OK 2.1: state=LIGAR_MAQUINA");
    else
      $display("ERRO 2.1: esperado LIGAR_MAQUINA(2), obteve=%0d", state);

    @(posedge clk);
    if (state === 4'd3)
      $display("OK 2.2: state=VERIFICAR_AGUA");
    else
      $display("ERRO 2.2: esperado VERIFICAR_AGUA(3), obteve=%0d", state);

    @(posedge clk);
    if (state === 4'd5)
      $display("OK 2.3: state=MOER_CAFE");
    else
      $display("ERRO 2.3: esperado MOER_CAFE(5), obteve=%0d", state);

    @(posedge clk);
    if (state === 4'd6)
      $display("OK 2.4: state=COLOCAR_NO_FILTRO");
    else
      $display("ERRO 2.4: esperado COLOCAR_NO_FILTRO(6), obteve=%0d", state);

    @(posedge clk);
    if (state === 4'd7)
      $display("OK 2.5: state=PASSAR_AGITADOR");
    else
      $display("ERRO 2.5: esperado PASSAR_AGITADOR(7), obteve=%0d", state);

    @(posedge clk);
    if (state === 4'd8)
      $display("OK 2.6: state=TAMPEAR");
    else
      $display("ERRO 2.6: esperado TAMPEAR(8), obteve=%0d", state);

    @(posedge clk);
    if (state === 4'd9)
      $display("OK 2.7: state=REALIZAR_EXTRACAO");
    else
      $display("ERRO 2.7: esperado REALIZAR_EXTRACAO(9), obteve=%0d", state);

    @(posedge clk);
    if (state === 4'd1)
      $display("OK 2.8: state=IDLE (fim de ciclo)");
    else
      $display("ERRO 2.8: esperado IDLE(1), obteve=%0d", state);

    $finish;
  end

endmodule