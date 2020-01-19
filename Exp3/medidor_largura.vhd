library IEEE;
use IEEE.std_logic_1164.all;

entity medidor_largura is
  port (
    clock, reset  : in std_logic;
    liga, sinal   : in std_logic;
    display0      : out std_logic_vector (6 downto 0); --digito 0
    display1      : out std_logic_vector (6 downto 0); -- digito 1
    display5      : out std_logic_vector (6 downto 0); -- estado
    fim           : out std_logic;
    pronto        : out std_logic;
    db_largura    : out std_logic_vector (7 downto 0);
    db_clock      : out std_logic;           -- saída de clock
    db_zeraCont   : out std_logic;
    db_contacont  : out std_logic
  );
end medidor_largura;

architecture arc of medidor_largura is
  component contador8bits is
  port (
       clock : in  std_logic;
       zera  : in  std_logic;
       conta : in  std_logic;
       Q     : out std_logic_vector (7 downto 0);
       rco   : out std_logic;

       init : in std_logic_vector(7 downto 0)
  );
  end component;

  component hexa7seg is
      port (
          hexa : in std_logic_vector(3 downto 0);
          sseg : out std_logic_vector(6 downto 0)
      );
  end component;

  component controlador is
     port ( clock, reset:        in  STD_LOGIC;
            liga, sinal:         in  STD_LOGIC;
            zeraCont, contaCont: out STD_LOGIC;
            pronto:              out STD_LOGIC;
            estado:              out STD_LOGIC_VECTOR(3 downto 0)
          );
  end component;

  begin

    
end arc;
