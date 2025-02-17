----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/17/2025 10:14:55 AM
-- Design Name: 
-- Module Name: SemaforoLog - Behavioral
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

entity SemaforoLog is
    port ( 
        -- Entradas
        x: in std_logic;
        y: in std_logic;
        z: in std_logic;
        w: in std_logic;   
             
        -- Salidas
        green : out std_logic;  -- Color verde
        yellow: out std_logic;  -- Color amarillo
        red: out std_logic      -- Color rojo
    );
end SemaforoLog;



architecture Behavioral of SemaforoLog is
begin
    process(x, y, z, w)
    begin
        -- Color verde 
        green <= ((not x and not y) and (z and w)) or 
             (not x and z and not w) or
             (not x and not z and w) or 
             (not x and not z and not w);

        -- Color amarillo             
        yellow <= (not x and y) and (z and w);
    
        -- Color rojo
        red <= (x and not z and not w) or
               (x and not z and w) or
               (x and z and w) or
               (x and z and not w);
    end process;
    
--    -- Color verde 
--    green <= ((not x and not y) and (z and w)) or 
--             (not x and z and not w) or
--             (not x and not z and w) or 
--             (not x and not z and not w);

--    -- Color amarillo             
--    yellow <= (not x and y) and (z and w);
    
--    -- Color rojo
--    red <= (x and not z and not w) or
--           (x and not z and w) or
--           (x and z and w) or
--           (x and z and not w);
end Behavioral;
