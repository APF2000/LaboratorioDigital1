----------------------------------------------------------------
-- Arquivo   : controlador.vhd
-- Projeto   : Jogo do Tempo de Reacao
-- Data      : 09/01/2020
----------------------------------------------------------------
-- Descricao : controlador (unidade de controle)
--             do medidor do tempo de reacao (largura de pulso)
--             descricao VHDL comportamental
--
-- sinais de condicao: liga - aciona medida da largura
--                     sinal - pulso a ser medido
-- sinais de controle: zeraCont - zera contagem
--                     contaCont - habilita contagem
--                     pronto - indica final da medida
-----------------------------------------------------------------
-- Revisoes  :
--     Data        Versao  Autor             Descricao
--     09/01/2020  1.0     Edson Midorikawa  criacao
-----------------------------------------------------------------
--
library IEEE;
use IEEE.std_logic_1164.all;

entity controlador is --entidade controlador (imagine uma caixa preta)
   port ( clock, reset:        in  STD_LOGIC; --entradas clock e reset do tipo STD_LOGIC
          liga, sinal:         in  STD_LOGIC; --entradas liga e sinal do tigo STD_LOGIC
          zeraCont, contaCont: out STD_LOGIC; --saídas zeraConta e contaCont do tipo STD_LOGIC
          pronto:              out STD_LOGIC; --saída pronto do tipo STD_LOGIC
          estado:              out STD_LOGIC_VECTOR(3 downto 0) --saída estado (4 bits) do tipo STD_LOGIC_VECTOR
        );
end controlador; --fim da entidade controlador

architecture controlador_arch of controlador is --arquitetura controlador_arch da entidade controlador
   type tipo_Estado is (INICIAL, LIGADO, CONTA, ESPERA, FIM); --definição do "tipo enumerado" tipo_Estado de parâmetros (INICIAL, LIGADO, CONTA, ESPERA, FIM)
   signal Ereg, Eprox: tipo_Estado; --sinais Ereg e Eprox do tipo tipo_Estado
begin
   --type tipo_Estado is (INICIAL, LIGADO, CONTA, ESPERA, FIM) tem o primeiro parâmetro representando o menor valor possível e o último o maior possível
   -- mudanca de estado
   process (clock, reset) --processo com entradas clock e reset na lista de sensibilidade
   begin
      if reset = '1' then --se resete = '1', então:
         Ereg <= INICIAL; --sinal Ereg recebe tipo_Estado LIGADO
      elsif clock'event and clock = '1' then --se não, se borda de subida do clock, então:
         Ereg <= Eprox; --sinal Ereg recebe sinal Eprox
      end if; --fim do if
   end process; --fim do processo

   -- logica de proximo estado
   process (LIGA, SINAL, Ereg) --processo com valores LIGA, SINAL e sinal Ereg (tipo_Estado) na lista de sensibilidade
   begin
      case Ereg is --caso Ereg mude:
         when INICIAL =>  if LIGA = '0' then --quando Ereg = estado INICIAL, se LIGA = '0', então:
                              Eprox <= INICIAL; --sinal Eprox recebe estado INICIAL
                          else --se não (LIGA != '0')
                              Eprox <= LIGADO; --sinal Eprox recebe estado LIGADO
                          end if; --fim do if

         when LIGADO =>   if SINAL = '0' then --quando Ereg = estado LIGADO, se SINAL = '0', então:
                              Eprox <= LIGADO; --sinal Eprox recebe estado LIGADO
                          else --se não (SINAL != '0')
                              Eprox <= CONTA; --sinal Eprox recebe estado CONTA
                          end if; --fim do if

         when CONTA =>    if SINAL = '1' then  --quando Ereg = estado CONTA, se SINAL = '1', então:
                              Eprox <= CONTA; --sinal Eprox recebe estado CONTA
                          else --se não (SINAL != '1')
                                 Eprox <= FIM; --sinal Eprox recebe estado FIM
                          end if; --fim do if

         when FIM =>      Eprox <= ESPERA; --quando Ereg = etado FIM, então sinal Eprox recebe estado ESPERA

         when ESPERA =>   if LIGA = '0' then --quando Ereg = estado ESPERA, se LIGA = '0', então:
                              Eprox <= INICIAL; --sinal Eprox recebe estado INICIAL
                          elsif SINAL = '0' then --se não, se SINAL = '0', então:
                              Eprox <= ESPERA; --sinal Eprox recebe estado ESPERA
                          else --se não
                              Eprox <= CONTA; --sinal Eprox recebe estado CONTA
                          end if; --fim do if

         when others =>  Eprox <= INICIAL; --Ereg em qualquer outro estado, então sinal Eprox recebe estado INICIAL
      end case; --fim do case
   end process; --fim do processo

   -- sinais de controle ativos em alto
   with Ereg select --com Ereg, selecione um sinal para a saída zeraCont
      zeraCont  <= '1' when LIGADO | ESPERA, --'1' quando Ereg = (LIGADO ou ESPERA)
                   '0' when others; --'0' quando for diferente de LIGADO ou ESPERA
   with Ereg select --com Ereg, selecione um sinal para saída contaCont
      contaCont <= '1' when CONTA, --'1' quando Ereg = CONTA
                  '0' when others; --'0' quando for diferente de CONTA
   with Ereg select --com Ereg, selecione um sinal para saída pronto
      pronto <= '1' when FIM, --'1' quando Ereg = FIM
                '0' when others; --'0' quando for diferente de FIM
   with Ereg select --com Ereg, selecione um sinal para a saída estado (4 bits)
      estado  <= "0000" when INICIAL,
                 "0001" when LIGADO,
                 "0010" when CONTA,
                 "0100" when FIM,
                 "1000" when ESPERA,
                 "1111" when others;
end controlador_arch; 
