// Módulo bajo prueba (DUT): Modulo_Principal (rtl/CODIGO_PRINCIPAL.v)
// Autores: Angye Valentina García Páramo & Samuel Esteban Quesada Portela.
// Casos críticos evaluados (integración completa SAR ADC + Clk + FSM + Displays):
//   1. Reset maestro (Sw2 = 1 -> R_2R = 0, S = 0).
//   2. Conversión SAR completa con comparador C = 0 (fondo inferior: 0000000000).
//   3. Conversión SAR completa con comparador C = 1 (fondo superior: 1111111111).
//   4. Conversión SAR dinámica simulando comparador real para código 10'd614 (~3.00 V).
//   5. Modo Pausa (Sw1 = 1): retiene lectura en Addr mientras R_2R sigue convirtiendo.
//
// Declaración de uso de IA:
//   Estructura de autoverificación generada con asistencia de Google Gemini (2026)
//   y validada por los autores para la integración completa del voltímetro digital.

`timescale 1ns / 1ps

module tb_Modulo_Principal;
    reg        clk_Basys;
    reg        Sw1;
    reg        Sw2;
    reg        C;

    wire [9:0] R_2R;
    wire [6:0] Di_1;
    wire [6:0] Di_2;
    wire [6:0] Di_3;
    wire       PUNTO;

    reg  [9:0] codigo_objetivo;
    reg        modo_analogico;
    integer    errores = 0;

    // Instancia del módulo principal
    Modulo_Principal dut (
        .clk_Basys(clk_Basys),
        .Sw1(Sw1),
        .Sw2(Sw2),
        .C(C),
        .R_2R(R_2R),
        .Di_1(Di_1),
        .Di_2(Di_2),
        .Di_3(Di_3),
        .PUNTO(PUNTO)
    );

    // Reloj de la Basys 3 (100 MHz -> período 10 ns)
    always #5 clk_Basys = ~clk_Basys;

    // Modelo de comparador analógico (LM311) cuando modo_analogico = 1
    always @(R_2R or codigo_objetivo or modo_analogico) begin
        if (modo_analogico)
            C = (R_2R <= codigo_objetivo) ? 1'b1 : 1'b0;
    end

    // Espera a que inicie un ciclo limpio en S0 (R=1) y termine completamente en P
    task ejecutar_conversion_completa;
        begin
            @(posedge dut.R);  // Inicia ciclo limpio tras aplicar el nuevo estímulo
            @(posedge dut.P);  // Terminan los 10 bits y se activa captura P
            @(negedge dut.P);  // Flanco de reloj guarda Etapa1 -> Addr
            #5;
        end
    endtask

    initial begin
        $dumpfile("tb_Modulo_Principal.vcd");
        $dumpvars(0, tb_Modulo_Principal);

        $display("=== INICIANDO TESTBENCH DE INTEGRACION: Modulo_Principal ===");

        clk_Basys       = 1'b0;
        Sw1             = 1'b0;
        Sw2             = 1'b1;
        C               = 1'b0;
        modo_analogico  = 1'b0;
        codigo_objetivo = 10'd0;

        // CASO 1: Reset maestro
        #50;
        if (R_2R !== 10'd0) begin
            $display("[FAIL] Reset maestro (Sw2=1) -> R_2R=%b", R_2R);
            errores = errores + 1;
        end else begin
            $display("[PASS] Reset maestro (Sw2=1) -> R_2R=%b, S=%0d", R_2R, dut.S);
        end

        Sw2 = 1'b0;

        // CASO 2: C = 0 constante (0 mV)
        C = 1'b0;
        ejecutar_conversion_completa();
        if (dut.Addr !== 10'b0000000000 || PUNTO !== 1'b0) begin
            $display("[FAIL] Conversion C=0 | Addr=%b PUNTO=%b", dut.Addr, PUNTO);
            errores = errores + 1;
        end else begin
            $display("[PASS] Conversion C=0 -> Addr=%b, PUNTO=%b", dut.Addr, PUNTO);
        end

        // CASO 3: C = 1 constante (5000 mV)
        C = 1'b1;
        ejecutar_conversion_completa();
        if (dut.Addr !== 10'b1111111111 || PUNTO !== 1'b1) begin
            $display("[FAIL] Conversion C=1 | Addr=%b PUNTO=%b", dut.Addr, PUNTO);
            errores = errores + 1;
        end else begin
            $display("[PASS] Conversion C=1 -> Addr=%b, PUNTO=%b", dut.Addr, PUNTO);
        end

        // CASO 4: Búsqueda SAR dinámica para código 10'd614 (~3.00 V)
        codigo_objetivo = 10'd614;
        modo_analogico  = 1'b1;
        ejecutar_conversion_completa();
        if (dut.Addr !== 10'd614 || PUNTO !== 1'b1) begin
            $display("[FAIL] Conversion SAR dinamica | Esperado Addr=614 | Obtenido Addr=%0d (%b)",
                     dut.Addr, dut.Addr);
            errores = errores + 1;
        end else begin
            $display("[PASS] Conversion SAR dinamica -> Addr=%0d (%b), PUNTO=%b",
                     dut.Addr, dut.Addr, PUNTO);
        end

        // CASO 5: Modo Pausa (Sw1 = 1)
        Sw1             = 1'b1;
        codigo_objetivo = 10'd100;
        ejecutar_conversion_completa();
        if (dut.Addr !== 10'd614) begin
            $display("[FAIL] Modo Pausa (Sw1=1) no retuvo Addr=614 | Obtenido Addr=%0d", dut.Addr);
            errores = errores + 1;
        end else begin
            $display("[PASS] Modo Pausa (Sw1=1) -> Addr retenido en %0d", dut.Addr);
        end

        if (errores == 0)
            $display("\n>>> RESULTADO tb_Modulo_Principal: INTEGRACION EXITOSA (0 errores) <<<\n");
        else
            $display("\n>>> RESULTADO tb_Modulo_Principal: FALLO CON %0d ERRORES <<<\n", errores);

        $finish;
        end
endmodule