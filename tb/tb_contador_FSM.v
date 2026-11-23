// Módulo bajo prueba (DUT): contador_FSM_ (rtl/contador_FSM_.v)
// Autores: Angye Valentina García Páramo & Samuel Esteban Quesada Portela.
// Casos críticos evaluados:
//   1. Reset asíncrono (R = 1 -> S = 0, F = 0 inmediatamente sin esperar clk).
//   2. Retención de estado cuando E = 0 (el contador no avanza ante flancos de clk).
//   3. Conteo ascendente paso a paso (S = 0 a 10 con E = 1, manteniendo F = 0).
//   4. Saturación en S = 10 y activación de bandera de fin de conversión (F = 1).
//   5. Reinicio limpio mediante R = 1 después de alcanzar el estado final (S = 10, F = 1).
//
// Declaración de uso de IA:
//   Estructura de autoverificación generada con asistencia de Google Gemini (2026)
//   y validada por los autores para el contador secuencial de la FSM SAR.

`timescale 1ns / 1ps

module tb_contador_FSM;
    reg clk;
    reg R;
    reg E;
    wire [3:0] S;
    wire F;

    integer ciclo;
    integer errores = 0;

    contador_FSM_ dut (
        .clk(clk),
        .R(R),
        .E(E),
        .S(S),
        .F(F)
    );

    always #5 clk = ~clk;

    task verificar_estado;
        input [3:0] s_esp;
        input f_esp;
        input [8*45:1] descripcion;
        begin
            #1; // Pequeño margen tras flanco para estabilizar salidas registradas
            if (S !== s_esp || F !== f_esp) begin
                $display("[FAIL] %0s | Esperado: S=%0d, F=%b | Obtenido: S=%0d, F=%b",
                         descripcion, s_esp, f_esp, S, F);
                errores = errores + 1;
            end else begin
                $display("[PASS] %0s | S=%0d, F=%b", descripcion, S, F);
            end
        end
    endtask

    initial begin
        $dumpfile("tb_contador_FSM.vcd");
        $dumpvars(0, tb_contador_FSM);

        $display("=== INICIANDO TESTBENCH DE contador_FSM_ ===");

        // Inicialización
        clk = 1'b0;
        R   = 1'b0;
        E   = 1'b0;

        // CASO CRÍTICO 1: Reset asíncrono (sin flanco de reloj)
        #2 R = 1'b1;
        verificar_estado(4'd0, 1'b0, "Reset asincrono inicial (R=1 -> S=0, F=0)");
        #3 R = 1'b0;

        // CASO CRÍTICO 2: Retención cuando E = 0 durante 2 flancos de reloj
        @(posedge clk);
        @(posedge clk);
        verificar_estado(4'd0, 1'b0, "Retencion con habilitacion E=0 (S=0, F=0)");

        // CASO CRÍTICO 3: Conteo ascendente S = 1..10 con E = 1 (F debe seguir en 0)
        E = 1'b1;
        for (ciclo = 1; ciclo <= 10; ciclo = ciclo + 1) begin
            @(posedge clk);
            verificar_estado(ciclo[3:0], 1'b0, "Conteo ascendente hacia paso SAR");
        end

        // CASO CRÍTICO 4: Saturación en S = 10 y activación de bandera F = 1
        @(posedge clk);
        verificar_estado(4'd10, 1'b1, "Saturacion en S=10 y bandera F=1");

        // Verificar que permanece saturado en ciclos adicionales
        @(posedge clk);
        verificar_estado(4'd10, 1'b1, "Permanencia estable en S=10, F=1");

        // CASO CRÍTICO 5: Reset asíncrono desde estado saturado
        #2 R = 1'b1;
        verificar_estado(4'd0, 1'b0, "Reinicio tras fin de conversion (R=1)");
        #3 R = 1'b0;

        // Resumen final
        if (errores == 0)
            $display("\n>>> RESULTADO tb_contador_FSM: TODOS LOS CASOS PASARON (0 errores) <<<\n");
        else
            $display("\n>>> RESULTADO tb_contador_FSM: FALLO CON %0d ERRORES <<<\n", errores);

        $finish;
    end
endmodule