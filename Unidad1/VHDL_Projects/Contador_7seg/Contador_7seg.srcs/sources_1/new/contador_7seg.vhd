library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity contador_7seg is
    Port ( 
        clk : in STD_LOGIC;         -- Señal de reloj
        reset : in STD_LOGIC;       -- Reset asíncrono
        display : out STD_LOGIC_VECTOR (6 downto 0) -- Salida para 7 segmentos (a-g)
    );
end contador_7seg;

architecture Behavioral of contador_7seg is
    signal contador : STD_LOGIC_VECTOR(3 downto 0) := "0000"; -- Contador de 4 bits
    signal slow_clk : STD_LOGIC := '0'; -- Reloj lento para visualización
    signal clk_divider : integer range 0 to 50000000 := 0; -- Divisor de reloj
begin
    -- Divisor de frecuencia para hacer visible el cambio
    process(clk, reset)
    begin
        if reset = '1' then
            clk_divider <= 0;
            slow_clk <= '0';
        elsif rising_edge(clk) then
            if clk_divider = 25000000 then -- Ajustar según velocidad deseada
                clk_divider <= 0;
                slow_clk <= not slow_clk;
            else
                clk_divider <= clk_divider + 1;
            end if;
        end if;
    end process;
    
    -- Proceso para el contador
    process(slow_clk, reset)
    begin
        if reset = '1' then
            contador <= "0000";
        elsif rising_edge(slow_clk) then
            if contador = "1111" then -- Contador de 0 a 15 (hexadecimal)
                contador <= "0000";
            else
                contador <= contador + 1;
            end if;
        end if;
    end process;
    
    -- Decodificador para 7 segmentos (0-F)
    -- Configuración: abcdefg (0 = segmento encendido)
    process(contador)
    begin
        case contador is
            when "0000" => display <= "1000000"; -- 0
            when "0001" => display <= "1111001"; -- 1
            when "0010" => display <= "0100100"; -- 2
            when "0011" => display <= "0110000"; -- 3
            when "0100" => display <= "0011001"; -- 4
            when "0101" => display <= "0010010"; -- 5
            when "0110" => display <= "0000010"; -- 6
            when "0111" => display <= "1111000"; -- 7
            when "1000" => display <= "0000000"; -- 8
            when "1001" => display <= "0010000"; -- 9
            when "1010" => display <= "0001000"; -- A
            when "1011" => display <= "0000011"; -- b
            when "1100" => display <= "1000110"; -- C
            when "1101" => display <= "0100001"; -- d
            when "1110" => display <= "0000110"; -- E
            when "1111" => display <= "0001110"; -- F
            when others => display <= "1111111"; -- Apagado
        end case;
    end process;
    
end Behavioral;