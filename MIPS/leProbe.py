#! /usr/bin/env python3
# -*- coding:utf-8 -*-
import subprocess;

def leProbe():
  win=0;
  if win == 1:
    # Para Windows, deve colocar o diretório intelFPGA_lite/20.1/quartus/bin64 no PATH.
    programa = ['quartus_stp.exe',  '-t', 'getHW.tcl']
  else:
    caminho = '/home/daniel/intelFPGA_lite/20.1/quartus/bin/'
    programa = [caminho+'quartus_stp',  '-t', 'getHW.tcl']

# quartus_stp -t getHW.tcl
  leitura = subprocess.Popen(programa, stdout=subprocess.PIPE, stderr=subprocess.STDOUT);
  stdout,stderr = leitura.communicate()
  # O replace compatibiliza o New Line entre o Windows e o Linux
  valor = stdout.decode("utf-8").replace('\r\n','\n');
  binario = valor.split('getHW.tcl\n')[1].split('\n')[0]
  return binario;

def convREG(numREG):
  nomeREG = {'00000': 'Zero','00001': 'at','00010': 'v0','00011': 'v1','00100': 'a0','00101': 'a1','00110': 'a2', '00111': 'a3',
             '01000': 't0', '01001': 't1', '01010': 't2', '01011': 't3', '01100': 't4', '01101': 't5', '01110': 't6', '01111': 't7',
             '10000': 's0', '10001': 's1', '10010': 's2', '10011': 's3', '10100': 's4', '10101': 's5', '10110': 's6', '10111': 's7',
             '11000': 't8', '11001': 't9', '11010': 'k0', '11011': 'k1', '11100': 'gp', '11101': 'sp', '11110': 'fp', '11111': 'ra'};
  return nomeREG[numREG];

def convInstrucao(opcode, funct):
  if opcode == '000000':
    if   funct == '000000':
      return ('NOP');
    elif funct == '001000':
      return ('JR');
    elif funct == '100000':
      return ('ADD');
    elif funct == '100010':
      return ('SUB');
    elif funct ==  '100100':
      return ('AND');
    elif funct ==  '100101':
      return ('OR');
    elif funct ==  '101010':
      return ('SLT');
    else:
      return ('Erro. opCode: '+str(opcode)+' - funct: '+str(funct));
  else:
    if   opcode == '000010':
      return 'JMP';
    elif opcode == '000011':
      return 'JAL';
    elif opcode == '000100':
      return 'BEQ';
    elif opcode == '000101':
      return 'BNE';
    elif opcode == '000101':
      return 'BNE';
    elif opcode == '001000':
      return 'ADDI';
    elif opcode == '001010':
      return 'SLTI';
    elif opcode == '001100':
      return 'ANDI';
    elif opcode == '001101':
      return 'ORI';
    elif opcode == '001111':
      return 'LUI';
    elif opcode == '100011':
      return 'LW';
    elif opcode == '101011':
      return 'SW';
    else:
      return 'ERRO. opCode: '+str(opcode)+' - funct: '+str(funct);

def convULActrl(ULACTRL):
  if ULACTRL == '0000':
      return 'AND';
  elif ULACTRL == '0001':
    return 'OR';
  elif ULACTRL == '0010':
    return 'Soma';
  elif ULACTRL == '0110':
    return 'Sub';
  elif ULACTRL == '0111':
    return 'SLT';
  else:
    return 'ERRO';

def convHEXA(valor, comprimento):
  valor = int(valor,2)
  return "{0:#0{1}X}".format(valor, comprimento)
#   Explanation:
#   {   # Format identifier
#   0:  # first parameter
#   #   # use "0x" prefix
#   0   # fill with zeroes
#   {1} # to a length of n characters (including 0x), defined by the second parameter
#   x   # hexadecimal number, using lowercase letters for a-f
#   X   # hexadecimal number, using uppercase letters for A-F
#   }   # End of format identifier

def convPtCtrl(selMUXPCBEQJMP, selMUXRTRD, habilitaEscritaC, selMUXRTIMED, selMUXULAMEM, BEQ, WR, RD):
  if selMUXPCBEQJMP == '1':
    if habilitaEscritaC == '0' and WR == '0':
      return 'JMP';
    else:
      return 'Erro no JMP'

  if selMUXRTRD == '1' and habilitaEscritaC == '1' and selMUXULAMEM == '0':
    if WR == '0' and selMUXRTIMED == '0':
      return 'Tipo R';
    else:
      return 'Erro no Tipo R'

  if selMUXRTRD == '0' and habilitaEscritaC == '1' and selMUXULAMEM == '1':
    if WR == '0' and selMUXRTIMED == '1':
      return 'LW';
    else:
      return 'Erro no LW'

  if WR == '1':
    if RD == '0' and selMUXRTIMED == '1' and habilitaEscritaC == '0':
      return 'SW';
    else:
      return 'Erro no SW'

  if BEQ == '1':
    if RD == '0' and WR == '0' and selMUXRTIMED == '0' and habilitaEscritaC == '0':
      return 'BEQ';
    else:
     return 'Erro no BEQ'

  return 'Nao Definido'

def main(argv=None):
# Interpretação da seleçãos dos MUXes:
  MUXJMP = {'0': 'PC+4 ou BEQ', '1': 'Jump'};
  MUXRTRD = {'00': 'RT', '01': 'RD', '10': '31', '11': 'Erro' };
  MUXRTIMED = {'0': 'RT', '1': 'Imediato'};
  MUXULAMEM = {'00': 'Saída da ULA', '01': 'Saida MemóriaRAM', '10': 'PC+4', '11': 'LUI'};
  MUXPCBEQ  = {'0': 'PC + 4', '1': 'BEQ'};
#
  valor = leProbe();
  PC = valor[480:512]
  Instrucao = valor[448:480]
  opCode = Instrucao[0:6]
  funct = Instrucao[26:32]
  enderecoRS = Instrucao[6:11]
  enderecoRT = Instrucao[11:16]
  enderecoRD = Instrucao[16:21]
  Imediato = Instrucao[16:32]
  conteudoRS = valor[416:448]
  conteudoRT = valor[384:416]
  valorRD = valor[352:384]
  EntradaBULA = valor[320:352]
  ImediatoExtendido = valor[288:320]
  SaidaULA = valor[256:288];
  DadoLidoRAM = valor[224:256];
  ProxPC = valor[192:224];
  MUXProxPC_EntradaA = valor[160:192];
  MUXProxPC_EntradaB = valor[128:160];
#
  selMUXPCBEQ = valor[16];
  flagZERO = valor[13];
  selMUXPCBEQJMP = valor[12];
  selMUXRTRD =  str(valor[11]) + str(valor[14])
  selMUXRTIMED = valor[10];
  selMUXULAMEM = str(valor[9]) + str(valor[15])
  BEQ = valor[8];
  WR = valor[7];
  RD = valor[6];
  ULActrl = valor[2:6];
  habilitaEscritaC = valor[1];

  print ('                             Binario                     Hexa       Decimal');
  print ('Etapa de Busca:');
  print ('Program Counter:    '+str(PC)+' - '+convHEXA(PC, 10)+' - '+str(int(PC,2)) );
  print ('MUXProxPC EntradaA: '+str(MUXProxPC_EntradaA)+' - '+convHEXA(MUXProxPC_EntradaA, 10)+' - '+str(int(MUXProxPC_EntradaA,2)) );
  print ('MUXProxPC EntradaB: '+str(MUXProxPC_EntradaB)+' - '+convHEXA(MUXProxPC_EntradaB, 10)+' - '+str(int(MUXProxPC_EntradaB,2)) );
  print ('ProxPC:             '+str(ProxPC)+' - '+convHEXA(ProxPC, 10)+' - '+str(int(ProxPC,2)) );
  print ('Instrucao:          '+str(Instrucao)+' - '+convHEXA(Instrucao, 10) );
  print ('Imediato Estendido: '+str(ImediatoExtendido)+' - '+convHEXA(ImediatoExtendido, 10)+' - '+str(int(ImediatoExtendido,2)) );
  print ('\nBanco Registradores:');
  print ('Leitura de RS:      '+str(conteudoRS)+' - '+convHEXA(conteudoRS,10)+' - '+str(int(conteudoRS,2)));
  print ('Leitura de RT:      '+str(conteudoRT)+' - '+convHEXA(conteudoRT,10)+' - '+str(int(conteudoRT,2)));
  print ('Escrita para RD:    '+str(valorRD)+' - '+convHEXA(valorRD,10)+' - '+str(int(valorRD,2)));
  print ('Habilita Escrita RD: '+str(habilitaEscritaC));
  print ('\nULA:');
  print ('Entrada A da ULA:   '+str(conteudoRS)+' - '+convHEXA(conteudoRS,10)+' - '+str(int(conteudoRS,2)));
  print ('Entrada B da ULA:   '+str(EntradaBULA)+' - '+convHEXA(EntradaBULA,10)+' - '+str(int(EntradaBULA,2)));
  print ('Saida da ULA:       '+str(SaidaULA)+' - '+convHEXA(SaidaULA,10)+' - '+str(int(SaidaULA,2)));
  print ('Flag de Zero:       '+str(flagZERO));
  print ('Controle da ULA:    '+str(ULActrl)+' - '+convULActrl(ULActrl));
  print ('\nPontos de Controle:');
  print ('selMUX Jump/(BEQ PC+4): '+str(selMUXPCBEQJMP)+' - '+MUXJMP[selMUXPCBEQJMP]);
  print ('selMUX RT/RD:           '+str(selMUXRTRD)+' - '+MUXRTRD[selMUXRTRD]);
  print ('selMUX RT/Imediato:     '+str(selMUXRTIMED)+' - '+MUXRTIMED[selMUXRTIMED]);
  print ('Habilita Escrita RD:    '+str(habilitaEscritaC));
  print ('selMUX ULA/MEM:         '+str(selMUXULAMEM)+' - '+MUXULAMEM[selMUXULAMEM]);
  print ('BEQ:                    '+str(BEQ));
  print ('MUX BEQ:                '+str(selMUXPCBEQ) + ' - ' + MUXPCBEQ[selMUXPCBEQ]);
  
  print ('Habilita Leitura RAM:   '+str(RD));
  print ('Habilita Escrita RAM:   '+str(WR));

  print ('\nInterpretacao:');
  print ('Instrucao: '+convInstrucao(opCode, funct)+' RD:'+convREG(enderecoRD)+' RS:'+convREG(enderecoRS)+' RT:'+convREG(enderecoRT)+' Imed:'+convHEXA(Imediato, 6) );
  print ('');
  #result = convPtCtrl(selMUXPCBEQJMP=selMUXPCBEQJMP, selMUXRTRD=selMUXRTRD, habilitaEscritaC=habilitaEscritaC,
  #           selMUXRTIMED=selMUXRTIMED, selMUXULAMEM=selMUXULAMEM, BEQ=BEQ, WR=WR, RD=RD);
  #print ('Pontos de Controle: '+result);
  print ('=============================\n');


if __name__ == "__main__":
    main() 
