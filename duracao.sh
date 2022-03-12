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

usage="
  ======= [OPÇÕES] =======

  -h - Help                   |   duracao -h
  -v - Versão                 |   duracao -v
  -s - Soma apenas um vídeo   |   duracao -u <Nome_do_Video>
  -t - Soma Total             |   duracao -t
"
total=0

versao="Versão 1.0.1"

#-------------------FUNÇÕES

SOMA_TOTAL(){
  shopt -s nullglob
    for video in *.mp4; do
      duracao=$(ffprobe -i $video -show_entries format=duration -v quiet -of csv="p=0")
      total=$( echo $total + $duracao | bc )
    done
  shopt -u nullglob

  echo "Total de: $( echo "scale=2; $total / 60 / 60" | bc -l ) horas de vídeo"
}

SOMA_MINUTOS(){
  echo -e "Vídeos disponíveis\n$(ls *.mp4)\n"
  read -p "Informe o nome do vídeo MP4: " video #Entrada do usuário

    if [ -z "$video" ];then
      echo "Não válido, Informe o nome do vídeo" && exit 1
    else
      duracao=$(ffprobe -i $video -show_entries format=duration -v quiet -of csv="p=0")
      echo -e "\nTotal de: $(echo "scale=2; $duracao/60"| bc -l) minutos de vídeo"
    fi
}

#-------------------TESTES

[ ! -x "$(type -P ffprobe)" ] && echo -e "Depende do pacote ffprobe. Este pacote vem junto com a instalação do ffmpeg,\nExecute 'sudo apt install ffmpeg'" && exit 1 #ffprobe instalado? 

#-------------------EXECUÇÃO

  case "$1" in
    -h) echo "$usage" && exit 0                                   ;;
    -v) echo "$versao" && exit 0                                  ;;
    -s) SOMA_MINUTOS                                              ;;
    -t) SOMA_TOTAL                                                ;;
     *) echo "Opção inválida, vallie o -h para ajuda." && exit 1  ;;
  esac
  shift