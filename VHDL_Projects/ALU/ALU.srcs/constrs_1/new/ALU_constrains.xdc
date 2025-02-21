## Archivo de restricciones para ALU 74LS181
## Configurado para la placa Basys 3 con Artix-7 (xc7a35tcpg236-1)

## Solución al problema de routing con M y BUFG
set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets M_IBUF]

## Entradas A (4 bits) - Switches
set_property PACKAGE_PIN V17 [get_ports {A[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {A[0]}]
set_property PACKAGE_PIN V16 [get_ports {A[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {A[1]}]
set_property PACKAGE_PIN W16 [get_ports {A[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {A[2]}]
set_property PACKAGE_PIN W17 [get_ports {A[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {A[3]}]

## Entradas B (4 bits) - Switches
set_property PACKAGE_PIN W15 [get_ports {B[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {B[0]}]
set_property PACKAGE_PIN V15 [get_ports {B[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {B[1]}]
set_property PACKAGE_PIN W14 [get_ports {B[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {B[2]}]
set_property PACKAGE_PIN W13 [get_ports {B[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {B[3]}]

## Selección de función S (4 bits) - Switches
set_property PACKAGE_PIN V2 [get_ports {S[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {S[0]}]
set_property PACKAGE_PIN T3 [get_ports {S[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {S[1]}]
set_property PACKAGE_PIN T2 [get_ports {S[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {S[2]}]
set_property PACKAGE_PIN R3 [get_ports {S[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {S[3]}]

## Modo (M) - Switch
set_property PACKAGE_PIN W2 [get_ports M]
set_property IOSTANDARD LVCMOS33 [get_ports M]

## Acarreo de entrada (Cin) - Switch
set_property PACKAGE_PIN U1 [get_ports Cin]
set_property IOSTANDARD LVCMOS33 [get_ports Cin]

## Salidas F (4 bits) - LEDs
set_property PACKAGE_PIN U16 [get_ports {F[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {F[0]}]
set_property PACKAGE_PIN E19 [get_ports {F[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {F[1]}]
set_property PACKAGE_PIN U19 [get_ports {F[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {F[2]}]
set_property PACKAGE_PIN V19 [get_ports {F[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {F[3]}]

## Acarreo de salida (Cout) - LED
set_property PACKAGE_PIN W18 [get_ports Cout]
set_property IOSTANDARD LVCMOS33 [get_ports Cout]

## Igualdad A=B (AeqB) - LED
set_property PACKAGE_PIN U15 [get_ports AeqB]
set_property IOSTANDARD LVCMOS33 [get_ports AeqB]

## Propagar (P) - LED
set_property PACKAGE_PIN U14 [get_ports P]
set_property IOSTANDARD LVCMOS33 [get_ports P]

## Generar (G) - LED
set_property PACKAGE_PIN V14 [get_ports G]
set_property IOSTANDARD LVCMOS33 [get_ports G]

## Reloj para el testbench (cuando se utilice en HW)
set_property PACKAGE_PIN W5 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]