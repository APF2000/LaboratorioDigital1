----------------------------------------------------------------
-- Arquivo   : medidor_largura.vhd
-- Projeto   : exp3
-- Data      : 18/01/2020
----------------------------------------------------------------
-- Descricao : circuito medidor de largura de pulso proposto
--             para o experimento 3.
--
----------------------------------------------------------------
-- T3BB3  :
--     Data             Alunos
--     18/01/2020       Lucas Lopes de Paula Junior - 9344880
--                      Arthur Pires da Fonseca - 10773096
----------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity medidor_largura is
   port ( clock, reset  :  in    std_logic;
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
end medidor_largura;

architecture comportamento of medidor_largura is

   component contador8bits
      port (
           clock : in  std_logic;
           zera  : in  std_logic;
           conta : in  std_logic;
           Q     : out std_logic_vector (7 downto 0);
           rco   : out std_logic
      );
   end component;

   component hexa7seg is
       port (
           hexa : in std_logic_vector(3 downto 0);
           sseg : out std_logic_vector(6 downto 0)
       );
   end component;

   component controlador
      port ( clock, reset:        in  STD_LOGIC;
             liga, sinal:         in  STD_LOGIC;
             zeraCont, contaCont: out STD_LOGIC;
             pronto:              out STD_LOGIC;
             estado:              out STD_LOGIC_VECTOR(3 downto 0)
           );
   end component;

   signal clk, s_zeraCont, s_contaCont, notZeraCont : std_logic;
   signal hex5 : std_logic_vector(3 downto 0);
   signal s_Q: std_logic_vector(7 downto 0);
	signal reg0, reg1 : std_logic_vector(6 downto 0);
	signal fimAux, prontoAux : std_logic;


begin                       --componente => entidade
   UC: controlador port map (       clock => clock,
                                    reset => reset,
                                    liga => liga,
                                    sinal => sinal,
                                    zeraCont => s_zeraCont,
                                    contaCont => s_contaCont,
                                    pronto => prontoAux,
                                    estado => hex5
                           );

                           --componente => entidade
   counter: contador8bits port map ( clock => clock,
                                    zera => notZeraCont,
                                    conta => s_contaCont,
                                    Q => s_Q,
                                    rco => fimAux
                              );


                           --componente => entidade
   disp0: hexa7seg port map (       hexa => s_Q(3 downto 0),
                                    sseg => reg0
                            );

                            --componente => entidade
   disp1: hexa7seg port map (       hexa => s_Q(7 downto 4),
                                     sseg => reg1
                             );

                           --componente => entidade
   disp5: hexa7seg port map (       hexa => hex5,
                                    sseg => display5
                            );


	with prontoAux select
		display0 <= reg0 when '1',
						B"1111_111" when '0';

	with prontoAux select
		display1 <= reg1 when '1',
						B"1111_111" when '0';

	fim <= fimAux;
	pronto <= prontoAux;

	notZeraCont <= not(s_zeraCont);
   db_largura <= s_Q;
   db_clock <= clock;
   db_zeraCont <= s_zeraCont;
   db_contaCont <= s_contaCont;

end architecture;
