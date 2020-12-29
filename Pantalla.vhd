library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity Pantalla is
  Port ( 
  estado : in natural;
  clk : in std_logic;
  cerrado1: in std_logic;
  abierto1: in std_logic;
  presencia1 : in std_logic;
  abrir_m1 : in std_logic;
  puerta_aaux1: in std_logic;
  puerta_caux1: in std_logic;
  motor_saux : in std_logic;
  motor_baux : in std_logic;
  piso : in std_logic_vector(3 downto 0);
  display1 : out std_logic_vector(7 downto 0);
  display2 : out std_logic_vector(7 downto 0);
  display3 : out std_logic_vector(7 downto 0);
  display4 : out std_logic_vector(7 downto 0)
  );
end Pantalla;
architecture Behavioral of Pantalla is
begin
displays: process(clk) 
-- Modificamos lo que muestra el display en función del estado en el que nos encontremos.
--Los estados toman el numero correspondiente con su puesto en la declaracion realizada en la Maquina de Estados por ejemplo si parado es el tercero en la lista 
--tomara el numero 3.
--En función de la posición actual se va cambiando la letra del display correspondiente (S-subir b-bajar A-abierto C-cerrado) 

	
	begin
		if clk 'event and clk='1' then
	
	
-- ESTADO DEL ASCENSOR (S,b,A,C)	
	
		case estado is --Comprueba en que estado estamos, los estados se han asignado mediante numeros para facilitar el codigo.
		  when 17|4|5|6|7|2=> --abriendo, cerrando, cerrando1, cerrando2, cerrando3, arranque1
          --En funcion de como se encuentre la puerta del ascensor coloca la letra que debe enseñar el display correspondiente
          
		      if cerrado1='1' then --puertas cerradas
		            display1<= "11000110"; --C  
		            end if;
		      if abierto1='1'  then --puertas abiertas
		            display1<= "10001000"; --A
                    end if;
              if (presencia1='1' or abrir_m1 = '1') and puerta_aaux1='0' then --se activa la presencia o el boton de mantener las puertas abiertas
                display1<= "10001000"; --A
                    end if;
		      if ((puerta_aaux1='1'and abierto1='0') or (puerta_caux1='1' and cerrado1='0'))  then --puertas en proceso de abrirse o cerrarse
		            display1<= "01111111"; --7f "."       
		      end if;
		      
		      
          when 16 => --bajar4
                   display2<= "01111111";  --7f "."  (ni sube ni baja)
              if abierto1 = '1' then
                   display1<= "10001000"; --A
              else
                   display1<= "01111111"; --7f "." 
              end if;
              
              
         
		  when 8|9|10|11 => --cerrando4, subir1, subir2, subir3
         
		  if motor_saux='1'  then
		         display2<= "10010010"; --S
		         end if;	
		         
		         	       
		  when 12|13|14|15=> -- subir4,bajar1,bajar2,bajar3
		  if motor_baux='1'  then
		         display2<= "10000011"; --B
		         end if; 
		               
		  when 3=> --parado
		          display2<= "01111111"; --7f "."  
		          display1<= "10001000"; --A
		          
		  when 1 => --inicial
		          display1<= "10001000"; --A
		          display2<= "01111111";--7f "."  
		          
		  when others=>
		         display1<= "01111111"; --7f "."  
		         display2<= "01111111"; --7f "."  
		end case;
		
		
		
-- NÚMERO DE PISO	
	
		case piso is
        --Se comprueba en que piso esta el ascensor para mostrarlo a traves del display.
        
		  when "0001"=>
		      display3<= "11000000"; --0
		      display4<= "11111001"; --1
		  when "0010"=>
		      display3<= "11000000"; --0
		      display4<= "10100100"; --2
		  when "0100"=>
		      display3<= "11000000"; --0
		      display4<= "10110000"; --3
		  when "1000"=>
		      display3<= "11000000"; --0
		      display4<= "10011001"; --4
		   when others=>
		      display3<= "11000000";--0 
		      display4<= "10000001";--0 
	   end case;
		end if;
		
	end process; 

end Behavioral;

