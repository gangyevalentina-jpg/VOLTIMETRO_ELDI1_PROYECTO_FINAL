`timescale 1ns / 1ps // Define la escala de tiempo para la simulación

module tb_modulo_principal();

    // 1. Declaración de señales

    reg [9:0] tb_entrada;

    wire [15:0] tb_salida_12bits;
    wire [6:0] tb_disp1;
    wire [6:0] tb_disp2;
    wire [6:0] tb_disp3;


    modulo_principal DUT ( 
        .B(tb_entrada),            
        .SS(tb_salida_12bits),     
        .DISP1(tb_disp1),
        .DISP2(tb_disp2),
        .DISP3(tb_disp3)
    );

    initial begin
        
        $dumpfile("simulacion.vcd"); 
        $dumpvars(0, tb_modulo_principal);

        $monitor("Tiempo = %0t | Direccion Binaria = %b | Direccion Decimal = %d | Salida 12 bits (Hex) = %h", 
                 $time, tb_entrada, tb_entrada, tb_salida_12bits);

        // --- PRUEBA 1 ---
        tb_entrada = 10'b0000000000;
        #20; 

        // --- PRUEBA 2 ---
        tb_entrada = 10'b1111111111;
        #20; 

         // --- PRUEBA 2 ---
        tb_entrada = 10'b0011001100;
        #20; 

         // --- PRUEBA 2 ---
        tb_entrada = 10'b0011001111;
        #20; 

        $finish;
    end


endmodule