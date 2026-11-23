// Módulo bajo prueba (DUT): Clk (divisor de reloj 100 MHz -> 20 kHz)
// Autores: Angye Valentina García Páramo & Samuel Esteban Quesada Portela.
// Casos críticos evaluados (verificación unitaria divisor de frecuencia):
//   1. Reset maestro (rst = 1 -> contador = 0, clk = 0).
//   2. Estabilidad antes del umbral (ciclos 1..2499 de clk_Basys -> clk permanece en 0).
//   3. Primer flanco de subida de clk exactamente en el ciclo 2500 (25.000 ns).
//   4. Segundo flanco (bajada) exactamente a los 5000 ciclos (50.000 ns -> T = 50 us / 20 kHz).
//   5. Reset en mitad de operación (rst = 1 limpia contador y regresa clk a 0).
//
// Declaración de uso de IA:
//   Estructura de autoverificación generada con asistencia de Google Gemini (2026)
//   y validada por los autores para la verificación unitaria del módulo Clk.

`timescale 1ns / 1ps

module tb_Clk;
    reg  clk_Basys;
    reg  rst;
    wire clk;

    time    t_subida;
    time    t_bajada;
    time    semiperiodo;
    integer errores = 0;

    // Instancia única del módulo bajo prueba
    Clk dut (
        .clk_Basys(clk_Basys),
        .rst(rst),
        .clk(clk)
    );

    // Reloj de entrada de la Basys 3: 100 MHz (período = 10 ns)
    always #5 clk_Basys = ~clk_Basys;

    initial begin
        $dumpfile("tb_Clk.vcd");
        $dumpvars(0, tb_Clk);

        $display("=== INICIANDO TESTBENCH UNITARIO: Clk (100 MHz -> 20 kHz) ===");

        clk_Basys = 1'b0;
        rst       = 1'b1;

        // 1. Verificar estado de Reset
        #25;
        if (clk !== 1'b0 || dut.contador !== 12'd0) begin
            $display("[FAIL] Reset inicial (rst=1) | clk=%b, contador=%0d", clk, dut.contador);
            errores = errores + 1;
        end else begin
            $display("[PASS] Reset inicial (rst=1) -> clk=%b, contador=%0d", clk, dut.contador);
        end

        // Liberar reset antes del siguiente flanco de subida
        @(negedge clk_Basys);
        rst = 1'b0;

        // 2. Verificar que tras 2499 flancos positivos (contador llega a 2499), clk sigue en 0
        repeat (2499) @(posedge clk_Basys);
        #1;
        if (clk !== 1'b0 || dut.contador !== 12'd2499) begin
            $display("[FAIL] Antes del umbral (ciclo 2499) | clk=%b, contador=%0d", clk, dut.contador);
            errores = errores + 1;
        end else begin
            $display("[PASS] Ciclo 2499 -> contador=%0d, clk=%b (aun sin conmutar)", dut.contador, clk);
        end

        // 3. Verificar flanco 2500: clk debe subir a 1 y contador volver a 0
        @(posedge clk_Basys);
        #1;
        t_subida = $time;
        if (clk !== 1'b1 || dut.contador !== 12'd0) begin
            $display("[FAIL] Umbral ciclo 2500 | Esperado clk=1 contador=0 | Obtenido clk=%b contador=%0d",
                     clk, dut.contador);
            errores = errores + 1;
        end else begin
            $display("[PASS] Ciclo 2500 -> clk conmuto a %b, contador=%0d (t=%0t ns)", clk, dut.contador, t_subida);
        end

        // 4. Esperar el siguiente semiperíodo (otros 2500 ciclos) y medir frecuencia
        @(negedge clk);
        t_bajada    = $time;
        semiperiodo = t_bajada - t_subida;
        if (semiperiodo !== 25000) begin
            $display("[FAIL] Semiperiodo medido = %0t ns | Esperado = 25000 ns (20 kHz)", semiperiodo);
            errores = errores + 1;
        end else begin
            $display("[PASS] Semiperiodo exacto = %0t ns (Periodo = %0t ns -> 20 kHz)",
                     semiperiodo, semiperiodo * 2);
        end

        // 5. Verificar reset asíncrono mientras clk = 1
        @(posedge clk);
        #12;
        rst = 1'b1;
        #5;
        if (clk !== 1'b0 || dut.contador !== 12'd0) begin
            $display("[FAIL] Reset en operacion | clk=%b, contador=%0d", clk, dut.contador);
            errores = errores + 1;
        end else begin
            $display("[PASS] Reset en operacion -> clk=%b, contador=%0d", clk, dut.contador);
        end

        // Resumen final
        if (errores == 0)
            $display("\n>>> RESULTADO tb_Clk: TODAS LAS PRUEBAS PASARON (0 errores) <<<\n");
        else
            $display("\n>>> RESULTADO tb_Clk: FALLO CON %0d ERRORES <<<\n", errores);

        $finish;
    end
endmodule