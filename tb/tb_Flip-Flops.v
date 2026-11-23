// Módulo bajo prueba (DUT): Flip_Flops (rtl/Flip-Flops.v)
// Autores: Angye Valentina García Páramo & Samuel Esteban Quesada Portela.
// Casos críticos evaluados:
//   1. Reset asíncrono (R = 1 -> R_2R = 0 y Addr = 0 inmediatamente).
//   2. Carga bit a bit en Etapa 1 mediante E_ff[9:0] sin alterar bits no habilitados.
//   3. Aislamiento de Etapa 2 cuando P = 0 (Addr retiene su valor previo).
//   4. Captura síncrona a Addr cuando P = 1 y Sw1 = 0 (En_Etapa2 = 1).
//   5. Congelamiento de lectura en modo pausa (Sw1 = 1 bloquea actualización de Addr).
//   6. ReanSudación de captura al desactivar pausa (Sw1 = 0 con P = 1).
//
// Declaración de uso de IA:
//   Estructura de autoverificación generada con asistencia de Google Gemini (2026)
//   y validada por los autores para los registros de aproximaciones sucesivas y pausa.

`timescale 1ns / 1ps

module tb_Flip_Flops;
    reg        clk;
    reg        R;
    reg        B;
    reg  [9:0] E_ff;
    reg        P;
    reg        Sw1;
    wire [9:0] Addr;
    wire [9:0] R_2R;

    integer errores = 0;

    // Instancia del módulo bajo prueba (DUT)
    Flip_Flops dut (
        .clk(clk),
        .R(R),
        .B(B),
        .E_ff(E_ff),
        .P(P),
        .Sw1(Sw1),
        .Addr(Addr),
        .R_2R(R_2R)
    );

    // Generador de reloj (período = 10 ns -> 100 MHz)
    always #5 clk = ~clk;

    // Tarea de autoverificación
    task verificar_registros;
        input [9:0] r2r_esp;
        input [9:0] addr_esp;
        input [8*50:1] descripcion;
        begin
            #1;
            if (R_2R !== r2r_esp || Addr !== addr_esp) begin
                $display("[FAIL] %0s | Esperado: R_2R=%b Addr=%b | Obtenido: R_2R=%b Addr=%b",
                         descripcion, r2r_esp, addr_esp, R_2R, Addr);
                errores = errores + 1;
            end else begin
                $display("[PASS] %0s | R_2R=%b Addr=%b", descripcion, R_2R, Addr);
            end
        end
    endtask

    initial begin
        $dumpfile("tb_Flip_Flops.vcd");
        $dumpvars(0, tb_Flip_Flops);

        $display("=== INICIANDO TESTBENCH DE Flip_Flops ===");

        // Inicialización
        clk  = 1'b0;
        R    = 1'b0;
        B    = 1'b0;
        E_ff = 10'b0000000000;
        P    = 1'b0;
        Sw1  = 1'b0;

        // CASO CRÍTICO 1: Reset asíncrono
        #2 R = 1'b1;
        verificar_registros(10'b0000000000, 10'b0000000000, "Reset asincrono inicial (R=1)");
        #3 R = 1'b0;

        // CASO CRÍTICO 2: Carga bit a bit en Etapa 1 (SAR MSB -> LSB) con P = 0
        // Cargar bit 9 (MSB) = 1
        B = 1'b1; E_ff = 10'b1000000000;
        @(posedge clk);
        verificar_registros(10'b1000000000, 10'b0000000000, "Carga MSB bit[9]=1 en Etapa1 (Addr retenido)");

        // Cargar bit 5 = 1 (bit 9 debe conservarse)
        B = 1'b1; E_ff = 10'b0000100000;
        @(posedge clk);
        verificar_registros(10'b1000100000, 10'b0000000000, "Carga bit[5]=1 conservando bit[9]");

        // Cargar bit 0 (LSB) = 1
        B = 1'b1; E_ff = 10'b0000000001;
        @(posedge clk);
        verificar_registros(10'b1000100001, 10'b0000000000, "Carga LSB bit[0]=1 en Etapa1");

        // Sobrescribir bit 5 = 0
        B = 1'b0; E_ff = 10'b0000100000;
        @(posedge clk);
        verificar_registros(10'b1000000001, 10'b0000000000, "Actualizacion bit[5]=0 en Etapa1");
        E_ff = 10'b0000000000;

        // CASO CRÍTICO 3: Captura hacia Etapa 2 (P = 1, Sw1 = 0)
        P = 1'b1; Sw1 = 1'b0;
        @(posedge clk);
        verificar_registros(10'b1000000001, 10'b1000000001, "Captura a Etapa2 con P=1 y Sw1=0");
        P = 1'b0;

        // CASO CRÍTICO 4: Modo Pausa (Sw1 = 1) bloquea Addr aunque Etapa 1 cambie y P = 1
        B = 1'b1; E_ff = 10'b0111111110; // Cambiamos todos los demás bits en Etapa 1
        @(posedge clk);
        E_ff = 10'b0000000000;

        P = 1'b1; Sw1 = 1'b1; // Intentamos capturar con pausa activa
        @(posedge clk);
        verificar_registros(10'b1111111111, 10'b1000000001, "Bloqueo por pausa (Sw1=1 -> Addr congelado)");

        // CASO CRÍTICO 5: Desactivar pausa (Sw1 = 0, P = 1) permite actualizar Addr
        Sw1 = 1'b0;
        @(posedge clk);
        verificar_registros(10'b1111111111, 10'b1111111111, "Reanudacion tras pausa (Sw1=0, P=1 -> Addr actualizado)");
        P = 1'b0;

        // CASO CRÍTICO 6: Reset asíncrono limpia ambos registros
        #2 R = 1'b1;
        verificar_registros(10'b0000000000, 10'b0000000000, "Reset asincrono final limpia R_2R y Addr");
        #3 R = 1'b0;

        // Resumen final
        if (errores == 0)
            $display("\n>>> RESULTADO tb_Flip_Flops: TODOS LOS CASOS PASARON (0 errores) <<<\n");
        else
            $display("\n>>> RESULTADO tb_Flip_Flops: FALLO CON %0d ERRORES <<<\n", errores);

        $finish;
    end
endmodule