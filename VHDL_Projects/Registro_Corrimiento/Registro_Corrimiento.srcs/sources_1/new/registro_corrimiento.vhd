library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ShiftRegisters is
    Port ( 
        clk : in STD_LOGIC;                     -- Señal de reloj
        reset : in STD_LOGIC;                   -- Reset asíncrono
        data_in : in STD_LOGIC;                 -- Bit de entrada para SISO, SIPO
        parallel_in : in STD_LOGIC_VECTOR(7 downto 0);  -- Entrada paralela para PISO, PIPO
        load : in STD_LOGIC;                    -- Carga paralela para PISO, PIPO
        mode : in STD_LOGIC_VECTOR(1 downto 0); -- 00:SISO, 01:SIPO, 10:PISO, 11:PIPO
        direction : in STD_LOGIC;               -- 0: izquierda->derecha, 1: derecha->izquierda
        enable : in STD_LOGIC;                  -- Habilitación del registro
        
        -- Salidas
        data_out : out STD_LOGIC;               -- Salida serial para SISO, PISO
        parallel_out : out STD_LOGIC_VECTOR(7 downto 0) -- Salida paralela para SIPO, PIPO
    );
end ShiftRegisters;

architecture Behavioral of ShiftRegisters is
    -- Registro interno para todas las operaciones
    signal reg : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
begin
    process(clk, reset)
    begin
        if reset = '1' then
            -- Reset asíncrono
            reg <= (others => '0');
        elsif rising_edge(clk) then
            if enable = '1' then
                case mode is
                    when "00" =>  -- SISO (Serie In, Serie Out)
                        if direction = '0' then
                            -- Desplazamiento hacia derecha (LSB primero)
                            reg <= data_in & reg(7 downto 1);
                        else
                            -- Desplazamiento hacia izquierda (MSB primero)
                            reg <= reg(6 downto 0) & data_in;
                        end if;
                        
                    when "01" =>  -- SIPO (Serie In, Paralelo Out)
                        if direction = '0' then
                            -- Desplazamiento hacia derecha (LSB primero)
                            reg <= data_in & reg(7 downto 1);
                        else
                            -- Desplazamiento hacia izquierda (MSB primero)
                            reg <= reg(6 downto 0) & data_in;
                        end if;
                        
                    when "10" =>  -- PISO (Paralelo In, Serie Out)
                        if load = '1' then
                            -- Carga paralela
                            reg <= parallel_in;
                        else
                            -- Desplazamiento
                            if direction = '0' then
                                -- Desplazamiento hacia derecha
                                reg <= '0' & reg(7 downto 1);
                            else
                                -- Desplazamiento hacia izquierda
                                reg <= reg(6 downto 0) & '0';
                            end if;
                        end if;
                        
                    when "11" =>  -- PIPO (Paralelo In, Paralelo Out)
                        if load = '1' then
                            -- Carga paralela
                            reg <= parallel_in;
                        end if;
                        
                    when others =>
                        -- Caso por defecto
                        reg <= reg;
                end case;
            end if;
        end if;
    end process;
    
    -- Asignación de salidas
    -- Salida serial (SISO, PISO) - depende de la dirección de desplazamiento
    data_out <= reg(0) when direction = '0' else reg(7);
    
    -- Salida paralela (SIPO, PIPO)
    parallel_out <= reg;
    
end Behavioral;