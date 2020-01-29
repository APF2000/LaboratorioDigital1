library ieee;
use IEEE.std_logic_1164.all;

entity exp4_desafio is
  port (
    clock, reset : in std_logic;
    resposta : in std_logic;
    estimulo : out std_logic;
    largura : out std_logic_vector(7 downto 0);

    -- sinais de debug
    erro, pronto1: out std_logic;
    estado : out std_logic_vector(3 downto 0);
    contador : out std_logic_vector(3 downto 0);

    display0      :  out   std_logic_vector(6 downto 0); --digito 0
    display1      :  out   std_logic_vector(6 downto 0); --digito 1
    display5      :  out   std_logic_vector(6 downto 0); --estado
    fim           :  out   std_logic;
    pronto2        :  out   std_logic;
    db_largura    :  out   std_logic_vector(7 downto 0);
    db_clock      :  out   std_logic; --saida de clock
    db_zeraCont   :  out   std_logic;
    db_contaCont  :  out   std_logic
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

 signal pulsoAux, ligaAux : std_logic;

 begin

   exp4 : interface_leds_botoes port map (
     clock => clock,
     reset => reset,
     resposta => resposta,
     iniciar => resposta,  -- inicia quando o jogador aperta o botao
     ligado => ligaAux,
     estimulo => estimulo,
     pulso => pulsoAux,

     --sinais de debug
     erro => erro,
     pronto => pronto1,
     estado => estado,
     contador => contador
   );

   size : medidor_largura port map (
     clock => clock,
     reset => reset,
     liga => ligaAux,
     sinal => pulsoAux,

     --sinais de debug
     display0 => display0,
     display1 => display1,
     display5 => display5,
     fim => fim,
     pronto => pronto2, --talvez devêssemos usar este sinal para permitir ou não a vizualização dos displays
     db_largura => db_largura,
     db_clock => db_clock,
     db_zeraCont => db_zeraCont,
     db_contaCont => db_contaCont
   );
end arc;
