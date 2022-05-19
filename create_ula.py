def create_header(FILE_PATH):
    STR_HEADER = '''
    library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;

    entity ULA is
       generic (larguraDados : natural := 32);
       port(
          inputA          : in  std_logic_vector(larguraDados-1 downto 0);
          inputB          : in  std_logic_vector(larguraDados-1 downto 0);
          operacao        : in  std_logic_vector(1 downto 0);
          inverteB        : in  std_logic;
          output          : out std_logic_vector(larguraDados-1 downto 0);
          resultado_adder : out std_logic;
          flagZero        : out std_logic
       );
    end entity;

    architecture componente of ULA is

       signal carryInInverteB, SLT : std_logic;
       signal carryIn0,  carryIn1,  carryIn2,  carryIn3  : std_logic;
       signal carryIn4,  carryIn5,  carryIn6,  carryIn7  : std_logic; 
       signal carryIn8,  carryIn9,  carryIn10, carryIn11 : std_logic;
       signal carryIn12, carryIn13, carryIn14, carryIn15 : std_logic;
       signal carryIn16, carryIn17, carryIn18, carryIn19 : std_logic;
       signal carryIn20, carryIn21, carryIn22, carryIn23 : std_logic;
       signal carryIn24, carryIn25, carryIn26, carryIn27 : std_logic;
       signal carryIn28, carryIn29, carryIn30, carryIn31 : std_logic;
       signal carryOut31                                 : std_logic;
       constant zero: std_logic_vector(larguraDados-1 downto 0) := (others => '0');

    begin

    carryInInverteB <= inverteB;
    flagZero        <= '1' when unsigned(output) = unsigned(zero) else '0';
    SLT             <= (carryIn31 xor carryOut31) xor resultado_adder;
    '''
    with open(FILE_PATH, 'w') as f:
        f.write(STR_HEADER)

def create_ula_str(idx, SLT, c_in, c_out, entity_name):
    ula_str = f'''
    ULINHA{idx}: entity work.{entity_name}
       port map(
          inputA          => inputA({idx}),
          inputB          => inputB({idx}),
          inverteB        => inverteB,
          SLT             => {SLT},
          operacao        => operacao,
          carryIn         => {c_in},
          carryOut        => {c_out},
          saida           => output({idx})
       );
    '''
    return ula_str
    
def create_ula_overflow(idx, SLT, c_in, c_out, entity_name, res_adder):
    ula_str = f'''
    ULINHA{idx}: entity work.{entity_name}
       port map(
          inputA          => inputA({idx}),
          inputB          => inputB({idx}),
          inverteB        => inverteB,
          SLT             => {SLT},
          operacao        => operacao,
          carryIn         => {c_in},
          carryOut        => {c_out},
          saida           => output({idx}),
          resultado_adder => {res_adder}
       );
    '''
    return ula_str

def create_ulas(FILE_PATH):
    with open(FILE_PATH, 'a') as f:
        QTD_ULAS = 32 #A primeira e a última são diferentes
        for idx in range(0, QTD_ULAS):
            
            entity_name = 'Ulinha'
            c_out       = f'carryIn{idx+1}'
            SLT   = "'0'"
            res_adder = "'0'"

            if idx == 0:
                SLT   = 'SLT'
                c_in  = f'carryInInverteB'
                ula = create_ula_str(idx, SLT, c_in, c_out, entity_name)
                f.write(ula)
            elif idx == QTD_ULAS-1:
                c_in        = f'carryIn{idx}'
                entity_name = 'Ula_overflow'
                c_out       = f'carryOut{idx}'
                res_adder   = 'resultado_adder'
                ula = create_ula_overflow(idx, SLT, c_in, c_out, entity_name, res_adder)
                f.write(ula)
            else: 
                c_in  = f'carryIn{idx}'
                ula = create_ula_str(idx, SLT, c_in, c_out, entity_name)
                f.write(ula)
        

            if idx == 31:
                f.write('end architecture;')

def main():
    FILE_PATH = 'ULA.txt'

    create_header(FILE_PATH)
    create_ulas(FILE_PATH)

    #Create last ula TODO

if __name__ == '__main__':
    main()


    
    








