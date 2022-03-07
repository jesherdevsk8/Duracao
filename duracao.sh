#!/usr/bin/env bash
# 
# duracao.sh - Soma o total de horas de vídeos em uma pasta
# Autor: Jesher Minelli | github: jesherdevsk8/duracao 
# Data: 06-03-2022
# Versão: 1.0 (inicial) - [ Jesher Minelli: é um fork do script do Mateus Muller ]
# Bash: versão 5.0.17
# Obs: CRIE UM LINK SIMBÓLICO PARA TORNA-LO EXECUTÁVEL EM QUALQUER DIRETÓRIO
# Exemplo: sudo ln -s $HOME/scripts/duracao.sh /usr/local/bin/duracao

#-------------------VARIÁVEIS
total=0

#-------------------TESTES

[ ! -x "$(type -P ffprobe)" ] && echo -e "Depende do pacote ffprobe. Este pacote vem junto com a instalação do ffmpeg,\nExecute 'sudo apt install ffmpeg'" && exit 1 #ffprobe instalado? 

#-------------------EXECUÇÃO

for video in $(ls *.mp4); do
  duracao=$(ffprobe -i $video -show_entries format=duration -v quiet -of csv="p=0")
  total=$( echo $total + $duracao | bc )   
done

echo "Total de: $( echo "scale=2; $total / 60 / 60" | bc -l )"
