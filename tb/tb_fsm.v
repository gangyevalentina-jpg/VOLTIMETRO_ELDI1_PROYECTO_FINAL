// Módulo bajo prueba (DUT): FSM (rtl/FSM.v)
// Autores: Angye Valentina García Páramo & Samuel Esteban Quesada Portela.
// Casos críticos evaluados (verificación unitaria FSM Moore/Mealy one-hot):
//   1. Reset maestro (rst = 1 -> Q = 4'b1000 [S0], R = 1, E=B=P=WE = 0).
//   2. Transición S0 (1000) -> S1 (0100): verifica B = 1 y WE = 1 (set bit de prueba).
//   3. Transición S1 (0100) -> S2 (0010) con C = 0: verifica B = 0 y WE = 1 (descarta bit).
//   4. Transición S2 (0010) -> S3 (0001) con F = 0: verifica E = 1 y P = 0 (avanza contador).
//   5. Lazo S3 (0001) -> S1 (0100) -> S2 (0010) con C = 1: verifica B = 1 y WE = 1 (conserva bit).
//   6. Finalización S3 (0001) con F = 1 -> S0 (1000): verifica P = 1 y E = 0 (captura Addr).
//
// Declaración de uso de IA:
//   Estructura de autoverificación generada con asistencia de Google Gemini (2026)
//   y validada por los autores para la verificación unitaria de la FSM.

`timescale 1ns / 1ps

module tb_FSM;
    reg  clk;
    reg  rst;
    reg  C;
    reg  F;

    wire R;
    wire E;
    wire B;
    wire P;
    wire WE;

    integer errores = 0;

    // Instancia del módulo bajo prueba
    FSM dut (
        .clk(clk),
        .rst(rst),
        .C(C),
        .F(F),
        .R(R),
        .E(E),
        .B(B),
        .P(P),
        .WE(WE)
    );

    // Reloj de prueba (período 10 ns)
    always #5 clk = ~clk;

    // Tarea auxiliar para verificar estado interno one-hot y todas las salidas
    task verificar_estado;
        input [23:0] nombre_estado;
        input [3:0]  exp_Q;
        input        exp_R;
        input        exp_E;
        input        exp_B;
        input        exp_P;
        input        exp_WE;
        begin
            #1; // Margen de propagación combinacional
            if (dut.Q !== exp_Q || R !== exp_R || E !== exp_E || B !== exp_B || P !== exp_P || WE !== exp_WE) begin
                $display("[FAIL] %s (C=%b, F=%b) | Esperado: Q=%b R=%b E=%b B=%b P=%b WE=%b | Obtenido: Q=%b R=%b E=%b B=%b P=%b WE=%b",
                         nombre_estado, C, F,
                         exp_Q, exp_R, exp_E, exp_B, exp_P, exp_WE,
                         dut.Q, R, E, B, P, WE);
                errores = errores + 1;
            end else begin
                $display("[PASS] %s (C=%b, F=%b) -> Q=%b | R=%b E=%b B=%b P=%b WE=%b",
                         nombre_estado, C, F, dut.Q, R, E, B, P, WE);
            end
        end
    endtask

    initial begin
        $dumpfile("tb_FSM.vcd");
        $dumpvars(0, tb_FSM);

        $display("=== INICIANDO TESTBENCH UNITARIO: FSM ===");

        clk = 1'b0;
        rst = 1'b1;
        C   = 1'b0;
        F   = 1'b0;

        // 1. Verificar Reset -> Estado S0 (Q = 1000)
        #12;
        verificar_estado("S0 ", 4'b1000, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0);

        // Liberar reset antes del siguiente flanco de subida
        @(negedge clk);
        rst = 1'b0;

        // 2. S0 -> S1 (Q = 0100): debe activar B=1 y WE=1
        @(posedge clk);
        verificar_estado("S1 ", 4'b0100, 1'b0, 1'b0, 1'b1, 1'b0, 1'b1);

        // 3. S1 -> S2 (Q = 0010) con C = 0: debe poner B=0 y WE=1
        @(negedge clk);
        C = 1'b0;
        @(posedge clk);
        verificar_estado("S2 ", 4'b0010, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1);

        // 4. S2 -> S3 (Q = 0001) con F = 0: debe activar E=1 y P=0
        @(negedge clk);
        F = 1'b0;
        @(posedge clk);
        verificar_estado("S3 ", 4'b0001, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0);

        // 5. Lazo S3 -> S1 (Q = 0100) porque F = 0
        @(posedge clk);
        verificar_estado("S1 ", 4'b0100, 1'b0, 1'b0, 1'b1, 1'b0, 1'b1);

        // 6. S1 -> S2 (Q = 0010) con C = 1: debe mantener B=1 y WE=1
        @(negedge clk);
        C = 1'b1;
        @(posedge clk);
        verificar_estado("S2 ", 4'b0010, 1'b0, 1'b0, 1'b1, 1'b0, 1'b1);

        // 7. S2 -> S3 (Q = 0001) ahora con F = 1: debe activar P=1 y E=0
        @(negedge clk);
        F = 1'b1;
        @(posedge clk);
        verificar_estado("S3 ", 4'b0001, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0);

        // 8. Finalización S3 -> S0 (Q = 1000) porque F = 1
        @(posedge clk);
        verificar_estado("S0 ", 4'b1000, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0);

        // Resumen final
        if (errores == 0)
            $display("\n>>> RESULTADO tb_FSM: TODAS LAS PRUEBAS PASARON (0 errores) <<<\n");
        else
            $display("\n>>> RESULTADO tb_FSM: FALLO CON %0d ERRORES <<<\n", errores);

        $finish;
    end
endmodule