library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity contador_2displays is
    Port ( 
        clk : in STD_LOGIC;         -- Señal de reloj
        reset : in STD_LOGIC;       -- Reset asíncrono
        display_unidades : out STD_LOGIC_VECTOR (6 downto 0); -- Dígito de unidades
        display_decenas : out STD_LOGIC_VECTOR (6 downto 0)   -- Dígito de decenas
    );
end contador_2displays;

architecture Behavioral of contador_2displays is
    signal contador_unidades : integer range 0 to 9 := 0;
    signal contador_decenas : integer range 0 to 9 := 0;
    signal slow_clk : STD_LOGIC := '0';
    signal clk_divider : integer range 0 to 50000000 := 0;
    
    -- Función para convertir dígito a código de 7 segmentos
    function to_7segment(digit : integer) return STD_LOGIC_VECTOR is
    begin
        case digit is
            when 0 => return "1000000"; -- 0 (Común ánodo: 0 = segmento encendido)
            when 1 => return "1111001"; -- 1
            when 2 => return "0100100"; -- 2
            when 3 => return "0110000"; -- 3
            when 4 => return "0011001"; -- 4
            when 5 => return "0010010"; -- 5
            when 6 => return "0000010"; -- 6
            when 7 => return "1111000"; -- 7
            when 8 => return "0000000"; -- 8
            when 9 => return "0010000"; -- 9
            when others => return "1111111"; -- Apagado
        end case;
    end function;
    
begin
    -- Divisor de frecuencia para hacer visible el cambio
    process(clk, reset)
    begin
        if reset = '1' then
            clk_divider <= 0;
            slow_clk <= '0';
        elsif rising_edge(clk) then
            if clk_divider = 25000000 then -- Aproximadamente 1 Hz con reloj de 50MHz
                clk_divider <= 0;
                slow_clk <= not slow_clk;
            else
                clk_divider <= clk_divider + 1;
            end if;
        end if;
    end process;
    
    -- Proceso para el contador BCD (0-99)
    process(slow_clk, reset)
    begin
        if reset = '1' then
            contador_unidades <= 0;
            contador_decenas <= 0;
        elsif rising_edge(slow_clk) then
            if contador_unidades = 9 then
                contador_unidades <= 0;
                if contador_decenas = 9 then
                    contador_decenas <= 0;
                else
                    contador_decenas <= contador_decenas + 1;
                end if;
            else
                contador_unidades <= contador_unidades + 1;
            end if;
        end if;
    end process;
    
    -- Asignar valores a los displays
    display_unidades <= to_7segment(contador_unidades);
    display_decenas <= to_7segment(contador_decenas);
    
end Behavioral;