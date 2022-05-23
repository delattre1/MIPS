library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity somadorGenerico_1bit is
    port
    (
        inputA, inputB : in std_logic;
        carryIn  : in  std_logic;
        carryOut : out std_logic;
        saida    : out std_logic
    );
end entity;

architecture comportamento of somadorGenerico_1bit is
    begin
        saida    <=  carryIn xor (inputA xor inputB);
        carryOut <= (inputA  and  inputB) or (carryIn and (inputA xor inputB));
end architecture;