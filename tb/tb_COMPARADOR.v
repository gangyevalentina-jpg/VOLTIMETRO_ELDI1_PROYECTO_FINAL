// Módulo bajo prueba (DUT): COMPARADOR (rtl/COMPARADOR.v)
// Autores: Angye Valentina García Páramo & Samuel Esteban Quesada Portela.
// Casos críticos evaluados (detección de umbral de auto-rango Addr >= 205 [1.0 V]):
//   1. Límite inferior (Addr = 0 - A = 0).
//   2. Frontera exacta antes del umbral (Addr = 204 [0011001100] - A = 0, 997 mV).
//   3. Umbral exacto de conmutación (Addr = 205 [0011001101] - A = 1, 1001 mV).
//   4. Activación por ramas intermedias (Addr = 208 [Addr[4]=1] y Addr = 224 [Addr[5]=1]).
//   5. Activación por bits superiores (Addr = 256 [Addr[8]=1] y Addr = 512 [Addr[9]=1]).
//   6. Límite superior (Addr = 1023 -> A = 1, 5000 mV).
//
// Declaración de uso de IA:
//   Estructura de autoverificación generada con asistencia de Google Gemini (2026)
//   y validada por los autores para el comparador digital de umbral de escala.

`timescale 1ns / 1ps

module tb_COMPARADOR;
    reg [9:0] Addr;
    wire A;

    integer errores = 0;

    COMPARADOR dut (
        .Addr(Addr),
        .A(A)
    );

    task verificar_umbral;
        input [9:0] dir_in;
        input esperado;
        input [8*45:1] descripcion;
        begin
            Addr = dir_in;
            #5;
            if (A !== esperado) begin
                $display("[FAIL] %0s | Addr=%0d (%b) | Esperado=%b | Obtenido=%b",
                         descripcion, Addr, Addr, esperado, A);
                errores = errores + 1;
            end else begin
                $display("[PASS] %0s | Addr=%0d (%b) -> A=%b", descripcion, Addr, Addr, A);
            end
        end
    endtask

    initial begin
        $dumpfile("tb_COMPARADOR.vcd");
        $dumpvars(0, tb_COMPARADOR);

        $display("=== INICIANDO TESTBENCH DE COMPARADOR DIGITAL (UMBRAL >= 205) ===");

        // CASO CRÍTICO 1: Límite inferior (0 V)
        verificar_umbral(10'd0,    1'b0, "Limite inferior (Addr=0 -> mV)");

        // CASO CRÍTICO 2: Frontera antes de 1 V (997 mV)
        verificar_umbral(10'd204,  1'b0, "Frontera inferior (Addr=204 -> mV)");

        // CASO CRÍTICO 3: Cruce exacto de umbral a 1 V (1001 mV)
        verificar_umbral(10'd205,  1'b1, "Umbral exacto 1V (Addr=205 -> V)");

        // CASO CRÍTICO 4: Ramas intermedias Addr[4] y Addr[5]
        verificar_umbral(10'd208,  1'b1, "Rama intermedia Addr[4]=1 (Addr=208)");
        verificar_umbral(10'd224,  1'b1, "Rama intermedia Addr[5]=1 (Addr=224)");

        // CASO CRÍTICO 5: Bits más significativos Addr[8] y Addr[9]
        verificar_umbral(10'd256,  1'b1, "Bit significativo Addr[8]=1 (Addr=256)");
        verificar_umbral(10'd512,  1'b1, "Bit significativo Addr[9]=1 (Addr=512)");

        // CASO CRÍTICO 6: Fondo de escala (5.0 V)
        verificar_umbral(10'd1023, 1'b1, "Fondo de escala (Addr=1023 -> V)");

        // Resumen final
        if (errores == 0)
            $display("\n>>> RESULTADO tb_COMPARADOR: TODOS LOS CASOS PASARON (0 errores) <<<\n");
        else
            $display("\n>>> RESULTADO tb_COMPARADOR: FALLO CON %0d ERRORES <<<\n", errores);

        $finish;
    end
endmodule