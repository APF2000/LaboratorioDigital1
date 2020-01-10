----------------------------------------------------------------
-- Arquivo   : contador_163.vhd
-- Projeto   : Jogo do Tempo de Reacao
-- Data      : 04/01/2020
----------------------------------------------------------------
-- Descricao : contador binario hexadecimal (modulo 16)
--             similar ao CI 74163
----------------------------------------------------------------
-- Revisoes  :
--     Data        Versao  Autor             Descricao
--     04/01/2020  1.0     Edson Midorikawa  criacao
----------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity contador_163 is -- declaração da entidade contador_163 (imagine como uma "caixa preta")
   port (
        clock    : in  std_logic; -- entrada clock do tipo std_logic
        clr, ld  : in  std_logic; -- entradas clr (clear) e ld (load) do tipo std_logic
        ent, enp : in  std_logic; -- entradas ent e enp (enable T e P) do tipo std_logic
        D        : in  std_logic_vector (3 downto 0); -- entrada D (data) de 4 bits do tipo std_logic_vector
        Q        : out std_logic_vector (3 downto 0); -- saída Q de 4 bits do tipo std_logic_vector
        rco      : out std_logic -- saída rco (Ripple Carry Out) do tipo std_logic
   );
end contador_163; -- fim da declaração da entidade contador_163

architecture comportamental of contador_163 is -- início da declaração da arquitetura da entidade contador_163
  signal IQ: integer range 0 to 15; -- sinal (fio) do tipo integer assumindo valores de  0 a 15
begin

  process (clock,clr,ld,ent,enp,IQ) -- processo (sequencial) e lista de sensibilidade (se um desses sinais mudar o processo é ativado)
  begin

    if clock'event and clock='1' then -- se for detectada uma borda de subida, então
      if clr = '0' then   -- se o clear estiver ativo baixo, então
         IQ <= 0;  -- o sinal IQ assume valor 0
      elsif ld = '0' then --se não (clr != '0'), se load for ativo baixo, então
         IQ <= to_integer(unsigned(D)); -- IQ recebe o valor da entrada D (conversão de tipos é necessária)
      elsif ent = '1' and enp = '1' then -- se não (ld != '0'), se ent e enp forem ativos alto, então
         if IQ = 15 then -- se o sinal IQ for 15, então
            IQ <= 0; --sinal IQ assume 0
         else -- caso contrário (IQ != 15)
            IQ <= IQ + 1; -- sinal IQ é incrementado de 1
        end if; -- fim das condições no caso de ent e enp estarem ativos alto
      else -- caso contrário (nenhuma das condições para clr, ld, ent e enp)
         IQ <= IQ; --sinal IQ continua o mesmo pois assume o valor do último estado (sem mudança)
      end if; -- fim das condições para as entradas
    end if; -- fim das condições caso em que a borda de subida é detectada

    if IQ = 15 and ENT = '1' --se o sinal IQ = 15 e ENT = 1
      then rco <= '1'; -- sinal rco assume valor 1 (usado para cascateamento)
    else -- caso contrário
      rco <= '0'; -- rco = 0
    end if; --fim da detecção de borda de subida

    Q <= std_logic_vector(to_unsigned(IQ, Q'length)); --saída Q assume o valor do sinal IQ (conversão de tipo e adaptação de comprimento são necessários)

  end process; --fim do processo
end comportamental; -- fim da declaração da arquitetura comportamental


--1) A saída Q deve variar de 0 a 15. Quais linhas de código VHDL confirmam este intervalo de valores?
--       Linha 30 e também as 42 e 43 DESTE código

--2) O sinal de CLEAR é síncrono e ativo em baixo. Quais linhas de código VHDL confirmam esta característica?
--       Linhas 36 e 37

--3) Este componente é sensível a borda de subida do sinal de clock.
--Quais linhas de código VHDL confirmam esta característica?
--       Linha 36

--4)Os sinais ENT e RCO devem ser usados para cascateamento de contadores.
--Quais linhas de código VHDL confirmam esta característica?
--       Linhas 52 até 56
