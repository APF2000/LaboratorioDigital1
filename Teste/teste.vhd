library ieee;
use ieee.std_logic_1164.all;

entity teste is
  port(
    A, B : in std_logic;
    O : out std_logic
  );
end entity;

architecture arch of teste is

begin

  O <= A or B;

end architecture;
