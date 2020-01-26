----------------------------------------------------------------
-- Arquivo   : contador8bits.vhd
-- Projeto   : Jogo do Tempo de Reacao
-- Data      : 04/01/2020
----------------------------------------------------------------
-- Descricao : contador binario de 8 bits
--             descricao VHDL estrutural
--             similar ao cascateamento de 2 CIs 74163
----------------------------------------------------------------
-- Revisoes  :
--     Data        Versao  Autor             Descricao
--     04/01/2020  1.0     Edson Midorikawa  criacao
----------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity contador8bits is --declaração da entidade contador8bits (imagine uma "caixa preta")
   port (
        clock : in  std_logic; --entrada clock do tipo std_logic
        zera  : in  std_logic; --entrada zera do tipo std_logic
        conta : in  std_logic; --entrada conta do tipo std_logic
        Q     : out std_logic_vector (7 downto 0); --saída Q de 8 bits do tipo std_logic_vector
        rco   : out std_logic; -- saída rco do tipo std_logic

        init : in std_logic_vector(7 downto 0)
   );
end contador8bits; --fim da declaração da entidade contador8bits

architecture estrutural of contador8bits is --declaração da arquitetura estrutural da entidade contador8bits

  component contador_163 --declaração do componente contador_163 (ver arquivo contador_163.vhd para mais detalhes)
    port (
          clock    : in  std_logic;
          clr, ld  : in  std_logic;
          ent, enp : in  std_logic;
          D        : in  std_logic_vector (3 downto 0);
          Q        : out std_logic_vector (3 downto 0);
          rco      : out std_logic
    );
end component; --fim da declaração do componente contador_163

  signal s_rco : std_logic; --sinal (fio) s_rco to tipo std_logic
  signal s_Q   : std_logic_vector  (7 downto 0); --sinal (fio) s_Q de 8 bits do tipo std_logic_vector
  signal initialValue : std_logic_vector(7 downto 0);

  begin

  initialValue <= init;

    --CONT1 é uma instância do componente contador_163
  CONT1: contador_163 port map ( clock=>clock, --conecta a entrada clock do componente CONT1 (contador_163) à entrada
                                               --clock da entidade (contador8bits)
           clr=>zera, --conecta a entrada clr do componente à entrada zera da entidade
           ld=>'1', --liga o sinal lógico '1' à entrada ld do componente
           ent=>'1', --liga o sinal lógico '1' à entrada ent do componente menos significativo
           enp=>conta, --conecta a entrada enp do componente à entrada conta da entidade
           D=>initialValue(3 downto 0), --liga o sinal "1111" (4 bits) à entrada D (4 bits) do componente CONT1
           Q=>s_Q(3 downto 0), --conecta a saída Q (4 bits) do componente ao sinal s_Q (4 bits menos significativos)
           rco=>s_rco --conecta a saída rco do componente menos significativo ao sinal s_rco
         ); --fim da declaração do componente

  --CONT2 é uma OUTRA instância do componente contador_163
  CONT2: contador_163 port map ( clock=>clock, --conecta a entrada clock do componente CONT2 (contador_163) à entrada
                                               --clock da entidade (contador8bits)
           clr=>zera, --conecta a entrada clr do componente à entrada zera da entidade
           ld=>'1', --liga o sinal lógico '1' à entrada ld do componente
           ent=>s_rco, --liga o sinal s_rco à entrada ent do componente mais significativo
           enp=>conta, --conecta a entrada enp do componente à entrada conta da entidade
           D=>initialValue(7 downto 4), --liga o sinal "1111" (4 bits) à entrada D (4 bits) do componente CONT2
           Q=>s_Q(7 downto 4), --contecta a saída Q (4 bits) do componente ao sinal s_Q (4 bits mais significativos)
           rco=>rco --conecta a saída rco do componente mais significativo à saída rco da arquitetura
         );

    Q <= s_Q; --saída Q da entidade recebe o sinal s_Q de 8 bits

end estrutural; --fim da arquitetura estrutural


--1) A saída Q do contador de 8 bits deve variar de 0 a 255. Como isto pode ser confirmado pelo grupo?
--    Os 8 bits do contador são controlados pelos componentes CONT1 (4 bits menos significativos) e
--    CONT2 (4 bits mais significativos). Como são instâncias do componente contador_163, cada um deles
--    assume individualmente valores de 0 a F (base hexadecimal). Por tanto, o maior número representável
--    é FF, ou seja, 15*(16^1) + 15*(16^0) = 255.

--2) O contador de 8 bits é composto pelo cascateamento de dois contadores 74163.
--Qual componente interno da descrição se refere ao dígito hexadecimal mais significativo (CONT1 ou CONT2)?
--     De acordo com a descrição, e como já mencionado antes,
--     CONT2 é responsável pelo dígito hexadecimal mais significativo.

--3) Os sinais ENT e RCO são usados para cascateamento dos contadores. Quais linhas de código VHDL estrutural
--mostram esta ligação de sinais? Quais sinais internos VHDL são usados neste cascateamento?
--    As linhas 50, 54, 61 e 65 DESTE código mostram esta ligação.
--    O sinal interno usado no cascateamento é o s_rco do tipo std_logic.
