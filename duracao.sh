#!/usr/bin/env bash
# 
# duracao.sh - Soma total horas de vídeos em umm diretório
# Autor: Jesher Minelli | github: jesherdevsk8/duracao 
# Data: 06-03-2022
# Versões: 
#       1.0 (inicial) - [ Jesher Minelli: é um fork do script do Mateus Muller ]       
#       1.0.1 - [ Adicionado um globbing direto com a opção nullglob ligada para evitar
#               interrupção do programa caso o glob não retorne arquivos.] Data - ( 12-03-2022 )
#                     
# Bash: versão 5.0.17
#
# Obs: CRIE UM LINK SIMBÓLICO PARA TORNA-LO EXECUTÁVEL EM QUALQUER DIRETÓRIO
# Exemplo: sudo ln -s $HOME/scripts/duracao.sh /usr/local/bin/duracao

#-------------------VARIÁVEIS
total=0

#-------------------TESTES

[ ! -x "$(type -P ffprobe)" ] && echo -e "Depende do pacote ffprobe. Este pacote vem junto com a instalação do ffmpeg,\nExecute 'sudo apt install ffmpeg'" && exit 1 #ffprobe instalado? 

#-------------------EXECUÇÃO

shopt -s nullglob
  for video in *.mp4; do
    duracao=$(ffprobe -i $video -show_entries format=duration -v quiet -of csv="p=0")
    total=$( echo $total + $duracao | bc )
  done
shopt -u nullglob

echo "Total de: $( echo "scale=2; $total / 60 / 60" | bc -l ) horas de vídeo"
