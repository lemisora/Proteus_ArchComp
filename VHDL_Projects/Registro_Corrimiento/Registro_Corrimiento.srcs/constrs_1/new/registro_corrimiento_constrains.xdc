## Archivo de restricciones para Registros de Corrimiento
## Configurado para la placa Basys 3 con Artix-7 (xc7a35tcpg236-1)

## Señal de reloj
set_property PACKAGE_PIN W5 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]
create_clock -period 10.000 -name sys_clk_pin -waveform {0.000 5.000} -add [get_ports clk]

## Reset - Botón central
set_property PACKAGE_PIN U18 [get_ports reset]
set_property IOSTANDARD LVCMOS33 [get_ports reset]

## Entrada de datos serial - Switch 0
set_property PACKAGE_PIN V17 [get_ports data_in]
set_property IOSTANDARD LVCMOS33 [get_ports data_in]

## Entradas paralelas - Switches 8-15
set_property PACKAGE_PIN V16 [get_ports {parallel_in[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {parallel_in[0]}]
set_property PACKAGE_PIN W16 [get_ports {parallel_in[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {parallel_in[1]}]
set_property PACKAGE_PIN W17 [get_ports {parallel_in[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {parallel_in[2]}]
set_property PACKAGE_PIN W15 [get_ports {parallel_in[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {parallel_in[3]}]
set_property PACKAGE_PIN V15 [get_ports {parallel_in[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {parallel_in[4]}]
set_property PACKAGE_PIN W14 [get_ports {parallel_in[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {parallel_in[5]}]
set_property PACKAGE_PIN W13 [get_ports {parallel_in[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {parallel_in[6]}]
set_property PACKAGE_PIN V2 [get_ports {parallel_in[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {parallel_in[7]}]

## Señal de carga - Botón
set_property PACKAGE_PIN T18 [get_ports load]
set_property IOSTANDARD LVCMOS33 [get_ports load]

## Modo de operación - Switches
set_property PACKAGE_PIN T3 [get_ports {mode[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {mode[0]}]
set_property PACKAGE_PIN T2 [get_ports {mode[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {mode[1]}]

## Dirección de desplazamiento - Switch
set_property PACKAGE_PIN R3 [get_ports direction]
set_property IOSTANDARD LVCMOS33 [get_ports direction]

## Habilitación del registro - Switch
set_property PACKAGE_PIN W2 [get_ports enable]
set_property IOSTANDARD LVCMOS33 [get_ports enable]

## Salida serial - LED
set_property PACKAGE_PIN U16 [get_ports data_out]
set_property IOSTANDARD LVCMOS33 [get_ports data_out]

## Salidas paralelas - LEDs
set_property PACKAGE_PIN E19 [get_ports {parallel_out[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {parallel_out[0]}]
set_property PACKAGE_PIN U19 [get_ports {parallel_out[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {parallel_out[1]}]
set_property PACKAGE_PIN V19 [get_ports {parallel_out[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {parallel_out[2]}]
set_property PACKAGE_PIN W18 [get_ports {parallel_out[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {parallel_out[3]}]
set_property PACKAGE_PIN U15 [get_ports {parallel_out[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {parallel_out[4]}]
set_property PACKAGE_PIN U14 [get_ports {parallel_out[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {parallel_out[5]}]
set_property PACKAGE_PIN V14 [get_ports {parallel_out[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {parallel_out[6]}]
set_property PACKAGE_PIN V13 [get_ports {parallel_out[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {parallel_out[7]}]