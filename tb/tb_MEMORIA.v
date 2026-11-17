// Módulo bajo prueba (DUT): mem_rom (rtl/MEMORIA.v)
// Autores: Angye Valentina García Páramo & Samuel Esteban Quesada Portela.
// Casos críticos evaluados:
//   1. Límite inferior (B = 0 - 0000 mV)
//   2. Paso mínimo 1 LSB (B = 1 - 0004 mV).
//   3. Frontera de cambio de escala mV/V (B = 204 - 0997 mV vs B = 205 - 1001 mV).
//   4. Punto medio (B = 512 - 2502 mV)
//   5. Límite superior (B = 1023 -> 5000 mV).
//
// Declaración de uso de IA:
//   Estructura de autoverificación generada con asistencia de Google Gemini (2026)
//   y validada por los autores contra la tabla de conversión rom_data.mem.

`timescale 1ns / 1ps

module tb_MEMORIA;
    reg [9:0] B;
    wire [15:0] S;

    integer errores = 0;

    mem_rom dut (
        .B(B),
        .S(S)
    );

    task verificar_dato;
        input [9:0] dir;
        input [15:0] esperado;
        input [8*45:1] descripcion;
        begin
            B = dir;
            #5;
            if (S !== esperado) begin
                $display("[FAIL] %0s | Dir=%0d (%b) | Esperado=%h | Obtenido=%h",
                         descripcion, dir, dir, esperado, S);
                errores = errores + 1;
            end else begin
                $display("[PASS] %0s | Dir=%0d -> S=%h", descripcion, dir, S);
            end
        end
    endtask

    initial begin
        $dumpfile("tb_MEMORIA.vcd");
        $dumpvars(0, tb_MEMORIA);

        $display("=== INICIANDO TESTBENCH DE MEMORIA ROM ===");

        // CASO CRÍTICO 1: Límite inferior (0 V)
        verificar_dato(10'd0,    16'h0000, "Limite inferior (0 mV)");

        // CASO CRÍTICO 2: Resolución mínima (1 LSB)
        verificar_dato(10'd1,    16'h0004, "Paso minimo 1 LSB (4 mV)");

        // CASO CRÍTICO 3: Frontera de cambio de escala (mV -> V)
        verificar_dato(10'd204,  16'h0997, "Umbral antes de 1V (997 mV)");
        verificar_dato(10'd205,  16'h1001, "Cruce de umbral a 1V (1001 mV)");

        // CASO CRÍTICO 4: Punto medio de escala (~2.5 V)
        verificar_dato(10'd512,  16'h2502, "Punto medio de escala (2502 mV)");

        // CASO CRÍTICO 5: Límite superior (5.0 V)
        verificar_dato(10'd1023, 16'h5000, "Fondo de escala (5000 mV)");

        // Resumen final
        if (errores == 0)
            $display("\n>>> RESULTADO tb_MEMORIA: TODOS LOS CASOS PASARON (0 errores) <<<\n");
        else
            $display("\n>>> RESULTADO tb_MEMORIA: FALLO CON %0d ERRORES <<<\n", errores);

        $finish;
    end
endmodule