library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity decoderGenerico is
  port   (
	 Funct : in  std_logic_vector(5  downto 0);
	 Opcode: in  std_logic_vector(5  downto 0);
	 Output: out std_logic_vector(13 downto 0)
  );
end entity;

architecture arch_name of decoderGenerico is
  -- Constantes de Opcode --
  constant TipoR  : std_logic_vector(5 downto 0) := "000000";
  constant JMP    : std_logic_vector(5 downto 0) := "000010";
  constant JAL    : std_logic_vector(5 downto 0) := "000011";
  constant BEQ    : std_logic_vector(5 downto 0) := "000100";
  constant ADDI   : std_logic_vector(5 downto 0) := "001000";
  constant BNE    : std_logic_vector(5 downto 0) := "000101";
  constant JR     : std_logic_vector(5 downto 0) := "001000";
  constant SLTI   : std_logic_vector(5 downto 0) := "001010";
  constant SLT    : std_logic_vector(5 downto 0) := "101010";
  constant ORI    : std_logic_vector(5 downto 0) := "001101";
  constant ANDI   : std_logic_vector(5 downto 0) := "001100";
  constant LUI    : std_logic_vector(5 downto 0) := "001111";
  constant LW     : std_logic_vector(5 downto 0) := "100011";
  constant SW     : std_logic_vector(5 downto 0) := "101011";
  


  -- Sinais de Habilita e SelMux --
  alias SelMuxJR         : std_logic is Output(0);
  alias SelMuxPc         : std_logic is Output(1);
  alias SelMuxRtRd       : std_logic_vector(1 downto 0) is Output(3 downto 2);
  alias ORI_ANDI         : std_logic is Output(4);
  alias habEscritaReg    : std_logic is Output(5);
  alias SelMuxRtImediato : std_logic is Output(6);
  alias ULAop            : std_logic is Output(7);
  alias SelMuxULAMem     : std_logic_vector(1 downto 0) is Output(9 downto 8);
  alias BEQ_signal       : std_logic is Output(10);
  alias BNE_signal       : std_logic is Output(11);
  alias habLeituraMEM    : std_logic is Output(12);
  alias habEscritaMEM    : std_logic is Output(13);

  
begin



	-- SelMuxJR
	SelMuxJR <= '1' when (Opcode = TipoR and Funct = JR) else '0';

	-- SelMuxPc
	SelMuxPc <= '1' when (Opcode = JMP or Opcode = JAL) else '0';

	-- SelMuxRtRd
	SelMuxRtRd <= "01" when (Opcode = TipoR) else
					  "10" when (Opcode = JAL)   else
					  "00";

  -- ORI_ANDI
  	ORI_ANDI <= '1' when (Opcode = ORI or Opcode = ANDI) else '0';

  -- Habilita Escrita Reg 3 (Banco de registadores)
	habEscritaReg <= '1' when (
	     Opcode = LUI  or 
	     Opcode = ANDI or
	     Opcode = ORI  or 
	     Opcode = LW   or 
	     Opcode = ADDI or
	     Opcode = JAL  or
	     Opcode = SLTI or
	     Opcode = SLT  or
	     Opcode = TipoR 
	  )  else '0';
	  
  -- SelMuxRtImediato
	SelMuxRtImediato <= '1' when (Opcode = LW   or
				      Opcode = SW   or
				      Opcode = ADDI or
				      Opcode = ANDI or
				      Opcode = SLTI or
				      Opcode = ORI
				      ) else '0';

  -- Operacao da ULA
  -- Quando Opcode = TipoR, utiliza-se o 'funct'
  ULAop  <= '1' when (Opcode = TipoR) else '0';

	--SelMuxUlaMen
	SelMuxULAMem <= "00" when (Opcode = TipoR or
					Opcode = ORI   or
					Opcode = ADDI  or
					Opcode = ANDI  or 
					Opcode = SLTI) else 
						 "11" when (Opcode = LUI) else
						 "10" when (Opcode = JAL) else
						 "01";
	
	-- BEQ
	BEQ_signal <= '1' when (Opcode = BEQ) else '0';

	-- BNE
	BNE_signal <= '1' when (Opcode = BNE) else '0';

	-- Habilita Leitura RAM
	habLeituraMEM <= '1' when (Opcode = LW) else '0';

	-- Habilita Escrita RAM
	habEscritaMEM <= '1' when (Opcode = SW) else '0';

end architecture;