--Testbench del divisor de reloj
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity divisor_reloj_tb is
end divisor_reloj_tb;
architecture behavioral of divisor_reloj_tb is
component divisor_reloj is  --Estructura del divisor de reolj
	port(	clk: in std_logic;  --Entrada reloj original
	        reset: in std_logic;  --Entrada reset
			clk_dividido: out std_logic);  --Salida reloj dividido
end component;
--Una se�al para cada puerto del componente
signal clk_s: std_logic :='1';  --Se�al clock se inicializa en 0
signal reset_s: std_logic :='0';  --Se�al reset se inicializa en 0
signal clk_dividido_s: std_logic;  --Se�al reloj dividido
begin
  uut: divisor_reloj port map(  --Asignaci�n de puertos a las se�ales correspondientes
	clk => clk_s,  --A la entrada clk se le asigna la se�al de reloj clk_s
	reset => reset_s,  --A la entrada reset se le asigna la se�al reset_s
	clk_dividido => clk_dividido_s);  --A la salida clk_dividido se le asigna la se�al clk_dividido_s
  --Generaci�n de est�mulos
    reset_s <='0', '1' after 600 ns;
    clk_s <= not clk_s after 10 ns;    
end behavioral;
