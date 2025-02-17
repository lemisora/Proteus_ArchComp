----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/17/2025 12:51:23 PM
-- Design Name: 
-- Module Name: Testbench - sim
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity Testbench is
end Testbench;

architecture sim of Testbench is
    signal x_tb, y_tb, z_tb, w_tb: std_logic := '0';
    signal green_tb, yellow_tb, red_tb: std_logic;
    
    -- Componente a probar (semáforo)
    component SemaforoLog is
        port(
            x, y, z, w: in std_logic;
            green, yellow, red: out std_logic
        );
    end component;
    
    
begin
    -- Se instancia el componente (Semáforo)
    UUT: SemaforoLog port map(
        -- Entradas
        x => x_tb,
        y => y_tb,
        z => z_tb,
        w => w_tb,
        
        -- Salidas
        green => green_tb,
        yellow => yellow_tb,
        red => red_tb
    );
    
--    Semaforo: entity work.SemaforoLog
--        port map(x_tb, y_tb, z_tb, w_tb, green_tb, yellow_tb, red_tb);
    
--    stimulus: process
--    begin
--        for i in 0 to 15 loop
--            x_tb <= 
--        end loop;
----    x <= '0'; y <= '0'; z <= '0'; w <= '0'; wait for 1000 ns; 
--    end process;

    stimulus: process
        begin
            -- Inicializamos un bucle que probará todas las combinaciones posibles
            for i in 0 to 15 loop  -- 2^4 = 16 combinaciones posibles
                -- Convertimos el contador a un vector de bits y asignamos a las entradas
                x_tb <= std_logic(to_unsigned(i, 4)(3));
                y_tb <= std_logic(to_unsigned(i, 4)(2));
                z_tb <= std_logic(to_unsigned(i, 4)(1));
                w_tb <= std_logic(to_unsigned(i, 4)(0));
                
                -- Esperamos 10ns para que se estabilicen las salidas
                wait for 10 ns;
                
                -- Verificamos las salidas e imprimimos los resultados
                report "Test " & integer'image(i) & ": " &
                      "Entradas (x,y,z,w) = " & std_logic'image(x_tb) & std_logic'image(y_tb) & 
                      std_logic'image(z_tb) & std_logic'image(w_tb) &
                      " Salidas (v,a,r) = " & std_logic'image(green_tb) & std_logic'image(yellow_tb) & 
                      std_logic'image(red_tb);
            end loop;
            
            -- Terminamos la simulación
            wait for 10 ns;
            report "Simulación completada";
            wait;
        end process;

end sim;
