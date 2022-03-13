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
# Cores
verde="\033[32;1m"
tira_cor="\033[m"

help="
  ======= [OPÇÕES] =======
  -h - Help
  -v - Versão
  -s - Soma apenas um vídeo
  -t - Soma Total
"
total=0

versao="Versão 1.2"

#-------------------FUNÇÕES

SOMA_TOTAL(){
  echo -e "Fazendo a soma total..................."
  sleep 1s

  shopt -s nullglob
    for video in *.mp4; do
      duracao=$(ffprobe -i $video -show_entries format=duration -v quiet -of csv="p=0")
      total=$( echo $total + $duracao | bc )
    done
  shopt -u nullglob

  echo -e "Total de: $( echo "scale=2; $total / 60 / 60" | bc -l ) horas de vídeo"
}

SOMA_MINUTOS(){
  echo -e "${verde}Vídeos disponíveis:${tira_cor}\n$(ls *.mp4)\n" # Titulo da saída na tela
  read -p "Informe o nome do vídeo MP4: " video # Entrada do usuário

  duracao=$(ffprobe -i $video -show_entries format=duration -v quiet -of csv="p=0")
  [ -z "$duracao" ] && { echo "Não válido"; exit 1 ; } || { echo -e "O vídeo ${verde}$video${tira_cor} tem $(echo "scale=2; $duracao/60"| bc -l) minutos"; exit 0 ; }
}

#-------------------TESTES

[ ! -x "$(type -P ffprobe)" ] && echo -e "Depende do pacote ffprobe. Este pacote vem junto com a instalação do ffmpeg,\nExecute 'sudo apt install ffmpeg'" && exit 1 #ffprobe instalado? 

#-------------------EXECUÇÃO
while test -n "$1"; do
  case "$1" in
    -h) echo "$help" && exit 0                                    ;;
    -v) echo "$versao" && exit 0                                  ;;
    -s) SOMA_MINUTOS && exit 0                                    ;;
    -t) SOMA_TOTAL && exit 0                                      ;;
     *) echo "Opção inválida, valie o -h para ajuda." && exit 1   ;;
  esac
  shift
done

echo "Olá $USER valie o -h para ajuda"