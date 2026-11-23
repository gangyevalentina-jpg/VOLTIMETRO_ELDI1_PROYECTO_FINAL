// Módulo bajo prueba (DUT): DECODIFICADOR (rtl/DECODIFICADOR.v)
// Autores: Angye Valentina García Páramo & Samuel Esteban Quesada Portela.
// Casos evaluados (verificación exhaustiva del conjunto completo BCD válido):
//   Se prueban los 10 dígitos decimales (0 a 9) verificando la activación en
//   lógica positiva (cátodo común, para los 3 displays externos) del bus Di = {a, b, c, d, e, f, g}.
//
// Declaración de uso de IA:
//   Estructura de autoverificación generada con asistencia de Google Gemini (2026)
//   y validada por los autores contra los displays externos de cátodo común.

`timescale 1ns / 1ps

module tb_DECODIFICADOR;
    reg [3:0] M;
    wire [6:0] Di;

    integer errores = 0;

    // Instancia del módulo bajo prueba (DUT)
    DECODIFICADOR dut (
        .M(M),
        .Di(Di)
    );

    // Tarea de autoverificación
    task verificar_digito;
        input [3:0] bcd_in;
        input [6:0] esperado;
        input [8*30:1] descripcion;
        begin
            M = bcd_in;
            #5;
            if (Di !== esperado) begin
                $display("[FAIL] %0s | M=%0d (%b) | Esperado=%b | Obtenido=%b",
                         descripcion, M, M, esperado, Di);
                errores = errores + 1;
            end else begin
                $display("[PASS] %0s | M=%0d -> Di=%b", descripcion, M, Di);
            end
        end
    endtask

    initial begin
        $dumpfile("tb_DECODIFICADOR.vcd");
        $dumpvars(0, tb_DECODIFICADOR);

        $display("=== INICIANDO TESTBENCH DE DECODIFICADOR (CATODO COMUN, 0 a 9) ===");

        // Barrido completo de los 10 dígitos BCD (patrón {a,b,c,d,e,f,g} en cátodo común)
        verificar_digito(4'd0, 7'b1111110, "Digito 0");
        verificar_digito(4'd1, 7'b0110000, "Digito 1");
        verificar_digito(4'd2, 7'b1101101, "Digito 2");
        verificar_digito(4'd3, 7'b1111001, "Digito 3");
        verificar_digito(4'd4, 7'b0110011, "Digito 4");
        verificar_digito(4'd5, 7'b1011011, "Digito 5");
        verificar_digito(4'd6, 7'b1011111, "Digito 6");
        verificar_digito(4'd7, 7'b1110000, "Digito 7");
        verificar_digito(4'd8, 7'b1111111, "Digito 8");
        verificar_digito(4'd9, 7'b1111011, "Digito 9");

        // Resumen final
        if (errores == 0)
            $display("\n>>> RESULTADO tb_DECODIFICADOR: TODOS LOS DIGITOS PASARON (0 errores) <<<\n");
        else
            $display("\n>>> RESULTADO tb_DECODIFICADOR: FALLO CON %0d ERRORES <<<\n", errores);

        $finish;
    end
endmodule