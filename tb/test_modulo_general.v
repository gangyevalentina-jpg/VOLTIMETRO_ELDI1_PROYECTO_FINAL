// Módulo bajo prueba (DUT): Modulo_Principal (rtl/CODIGO_PRINCIPAL.v)
// Autores: Angye Valentina García Páramo & Samuel Esteban Quesada Portela.
// Prueba puntual de medición analógica: 2.30 V (2300 mV -> código SAR 10'd471)
// Visualiza convergencia SAR paso a paso y salidas decodificadas Di_1, Di_2, Di_3 y PUNTO.

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

    // Traza paso a paso de la aproximación sucesiva SAR
    always @(posedge dut.clk) begin
        if (modo_analogico)
            $display("t=%0t | Q=%b | S=%0d | R_2R=%b (%0d) | C=%b | Addr=%0d",
                     $time, dut.Bloque_FSM.Q, dut.S, R_2R, R_2R, C, dut.Addr);
    end

    // Modelo del comparador analógico (LM311 / LM393)
    always @(R_2R or codigo_objetivo or modo_analogico) begin
        if (modo_analogico)
            C = (R_2R <= codigo_objetivo) ? 1'b1 : 1'b0;
    end

    // Traductor visual de 7 segmentos (activo alto y activo bajo) para verificación en consola
    function [7:0] seg7_a_char;
        input [6:0] seg;
        begin
            case (seg)
                7'b1111110, 7'b0000001: seg7_a_char = "0";
                7'b0110000, 7'b1001111: seg7_a_char = "1";
                7'b1101101, 7'b0010010: seg7_a_char = "2";
                7'b1111001, 7'b0000110: seg7_a_char = "3";
                7'b0110011, 7'b1001100: seg7_a_char = "4";
                7'b1011011, 7'b0100100: seg7_a_char = "5";
                7'b1011111, 7'b0100000: seg7_a_char = "6";
                7'b1110000, 7'b0001111: seg7_a_char = "7";
                7'b1111111, 7'b0000000: seg7_a_char = "8";
                7'b1111011, 7'b0000100: seg7_a_char = "9";
                default:                seg7_a_char = "?";
            endcase
        end
    endfunction

    task ejecutar_conversion_completa;
        begin
            @(posedge dut.P);
            @(negedge dut.P);
            @(posedge dut.P);
            @(negedge dut.P);
            #5;
        end
    endtask

    initial begin
        $dumpfile("tb_Modulo_Principal.vcd");
        $dumpvars(0, tb_Modulo_Principal);

        $display("=== MEDICION ANALOGICA: 2.30 V (Codigo objetivo = 471) ===");

        clk_Basys       = 1'b0;
        Sw1             = 1'b0;
        Sw2             = 1'b1;
        C               = 1'b0;
        modo_analogico  = 1'b0;
        codigo_objetivo = 10'd471; // ~2.30 V (471 * 5000 / 1023 = 2302 mV)

        // Liberar reset maestro
        #50;
        Sw2 = 1'b0;

        // Activar entrada analógica de 2.3 V y esperar conversión completa
        modo_analogico = 1'b1;
        ejecutar_conversion_completa();

        // Detener traza para imprimir resumen limpio
        modo_analogico = 1'b0;

        $display("\n================ RESULTADO EN DISPLAYS (2.30 V) ================");
        $display("Codigo capturado (Addr) : %0d (%b)", dut.Addr, dut.Addr);
        $display("PUNTO decimal           : %b (1 = Modo Voltios X.XX)", PUNTO);
        $display("Di_1 (Unidades / MSB)   : %b -> Digito '%s'", Di_1, seg7_a_char(Di_1));
        $display("Di_2 (Decimas)          : %b -> Digito '%s'", Di_2, seg7_a_char(Di_2));
        $display("Di_3 (Centesimas / LSB) : %b -> Digito '%s'", Di_3, seg7_a_char(Di_3));
        $display("Lectura visual final    : %s%s%s%s V",
                 seg7_a_char(Di_1),
                 (PUNTO ? "." : ""),
                 seg7_a_char(Di_2),
                 seg7_a_char(Di_3));
        $display("================================================================\n");

        $finish;
    end
endmodule