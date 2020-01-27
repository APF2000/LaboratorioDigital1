library ieee;
use IEEE.std_logic_1164.all;

entity exp4_desafio is
  port (
    clock, reset : in std_logic;
    resposta : in std_logic;
    estimulo : out std_logic;
    largura : out std_logic_vector(7 downto 0)
  );
end exp4_desafio;

architecture arc of exp4_desafio is
  component interface_leds_botoes is
    port (
       clock, reset: in std_logic;
       iniciar, resposta: in std_logic;
       ligado, estimulo, pulso: out std_logic;
       erro, pronto: out std_logic;
       estado : out std_logic_vector(3 downto 0);
    	 contador : out std_logic_vector(3 downto 0)
   );
 end component;

 component medidor_largura is
    port (
       clock, reset  :  in    std_logic;
       liga, sinal   :  in    std_logic;
       display0      :  out   std_logic_vector(6 downto 0); --digito 0
       display1      :  out   std_logic_vector(6 downto 0); --digito 1
       display5      :  out   std_logic_vector(6 downto 0); --estado
       fim           :  out   std_logic;
       pronto        :  out   std_logic;
       db_largura    :  out   std_logic_vector(7 downto 0);
       db_clock      :  out   std_logic; --saida de clock
       db_zeraCont   :  out   std_logic;
       db_contaCont  :  out   std_logic
    );
 end component;

 signal pulsoAux : std_logic;

 begin

   exp4 : exp4_desafio port map (
     clock => ,
     reset => ,
     iniciar => ,
     ligado => ,
     estimulo => ,
     pulso => ,
     erro => ,
     pronto => ,
     estado => ,
     contador => :
   );

   largura : medidor_largura port map (
     lock => ,
     reset => ,
     liga => ,
     sinal => ,
     display0 => ,
     display1 => ,
     display5 => ,
     fim => ,
     pronto => ,
     db_largura => ,
     db_clock => ,
     db_zeraCont => ,
     db_contaCont =>
   );
end arc;
