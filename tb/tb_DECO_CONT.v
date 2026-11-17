// Módulo bajo prueba (DUT): DECO_CONT (rtl/DECO_CONT.v)
// Autores: Angye Valentina García Páramo & Samuel Esteban Quesada Portela.
// Casos críticos evaluados (verificación unitaria decodificador SAR MSB->LSB):
//   1. Estados válidos s = 0..9: verifica desplazamiento one-hot desde E_ff[9] (En_9) hasta E_ff[0] (En_0).
//   2. Estados fuera de rango s = 10..15: verifica que todas las salidas permanezcan en 0 (10'b0000000000).
//
// Declaración de uso de IA:
//   Estructura de autoverificación generada con asistencia de Google Gemini (2026)
//   y validada por los autores para la verificación unitaria de DECO_CONT.

`timescale 1ns / 1ps

module tb_DECO_CONT;
    reg  [3:0] s;
    wire [9:0] E_ff;

    reg  [9:0] esperado;
    integer    i;
    integer    errores = 0;

    // Instancia única del módulo bajo prueba
    DECO_CONT dut (
        .s(s),
        .E_ff(E_ff)
    );

    initial begin
        $dumpfile("tb_DECO_CONT.vcd");
        $dumpvars(0, tb_DECO_CONT);

        $display("=== INICIANDO TESTBENCH UNITARIO: DECO_CONT ===");

        // 1. Verificar s = 0 hasta s = 9 (barrido SAR desde MSB bit 9 hasta LSB bit 0)
        for (i = 0; i <= 9; i = i + 1) begin
            s = i[3:0];
            esperado = (10'b1000000000 >> i);
            #5;
            if (E_ff !== esperado) begin
                $display("[FAIL] s=%0d (%b) | Esperado E_ff=%b | Obtenido E_ff=%b",
                         i, s, esperado, E_ff);
                errores = errores + 1;
            end else begin
                $display("[PASS] s=%0d (%b) -> E_ff=%b (En_%0d activo)",
                         i, s, E_ff, 9 - i);
            end
        end

        // 2. Verificar estados no utilizados s = 10 hasta s = 15 (ningún bit habilitado)
        for (i = 10; i <= 15; i = i + 1) begin
            s = i[3:0];
            #5;
            if (E_ff !== 10'b0000000000) begin
                $display("[FAIL] Fuera de rango s=%0d (%b) | Esperado E_ff=0000000000 | Obtenido E_ff=%b",
                         i, s, E_ff);
                errores = errores + 1;
            end else begin
                $display("[PASS] Fuera de rango s=%0d (%b) -> E_ff=%b", i, s, E_ff);
            end
        end

        // Resumen final
        if (errores == 0)
            $display("\n>>> RESULTADO tb_DECO_CONT: TODAS LAS PRUEBAS PASARON (0 errores) <<<\n");
        else
            $display("\n>>> RESULTADO tb_DECO_CONT: FALLO CON %0d ERRORES <<<\n", errores);

        $finish;
    end
endmodule