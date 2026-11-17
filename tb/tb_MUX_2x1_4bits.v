// Módulo bajo prueba (DUT): MUX_2x1_4bits (rtl/MUX_2x1_4bits.v)
// Autores: Angye Valentina García Páramo & Samuel Esteban Quesada Portela.
// Casos críticos evaluados (se prueban los dos únicos estados de control del multiplexor
// usando valores complementarios bit a bit para validar las 4 líneas del bus):
//   1. Selección canal milivoltios (sel = 0 -> out = in_milis).
//   2. Selección canal voltios (sel = 1 -> out = in_voltios).
//
// Declaración de uso de IA:
//   Estructura de autoverificación generada con asistencia de Google Gemini (2026)
//   y validada por los autores para el multiplexor de auto-rango.

`timescale 1ns / 1ps

module tb_MUX_2x1_4bits;
    reg [3:0] in_voltios;
    reg [3:0] in_milis;
    reg sel;
    wire [3:0] out;

    integer errores = 0;

    MUX_2x1_4bits dut (
        .in_voltios(in_voltios),
        .in_milis(in_milis),
        .sel(sel),
        .out(out)
    );

    task verificar_mux;
        input [3:0] v_in;
        input [3:0] m_in;
        input s_in;
        input [3:0] esperado;
        input [8*45:1] descripcion;
        begin
            in_voltios = v_in;
            in_milis   = m_in;
            sel        = s_in;
            #5;
            if (out !== esperado) begin
                $display("[FAIL] %0s | sel=%b V=%d M=%d | Esperado=%d (%b) | Obtenido=%d (%b)",
                         descripcion, sel, in_voltios, in_milis, esperado, esperado, out, out);
                errores = errores + 1;
            end else begin
                $display("[PASS] %0s | sel=%b -> out=%d (%b)", descripcion, sel, out, out);
            end
        end
    endtask

    initial begin
        $dumpfile("tb_MUX_2x1_4bits.vcd");
        $dumpvars(0, tb_MUX_2x1_4bits);

        $display("=== INICIANDO TESTBENCH DE MUX_2x1_4bits ===");

        // CASO CRÍTICO 1: Selección de escala milivoltios (sel = 0 - in_milis = 9 [1001])
        verificar_mux(4'd6, 4'd9, 1'b0, 4'd9, "Modo milivoltios (sel=0 -> in_milis)");

        // CASO CRÍTICO 2: Conmutación a escala voltios (sel = 1 -> in_voltios = 6 [0110])
        verificar_mux(4'd6, 4'd9, 1'b1, 4'd6, "Modo voltios (sel=1 -> in_voltios)");

        // Resumen final
        if (errores == 0)
            $display("\n>>> RESULTADO tb_MUX_2x1_4bits: TODOS LOS CASOS PASARON (0 errores) <<<\n");
        else
            $display("\n>>> RESULTADO tb_MUX_2x1_4bits: FALLO CON %0d ERRORES <<<\n", errores);

        $finish;
    end
endmodule