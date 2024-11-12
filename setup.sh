#!/bin/bash

# Atualizando os pacotes do sistema:
sudo apt update && sudo apt upgrade -y

# Instalando o Docker na EC2 (caso não tenha sido instalado ainda):
sudo apt install docker.io -y

# Instalando o Docker Compose (caso não tenha sido instalado ainda):
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Habilitando e iniciando o serviço do Docker:
sudo systemctl enable docker
sudo systemctl start docker

# Rodando o Docker Compose para iniciar os containers (dentro da pasta onde o docker-compose.yml está):
sudo docker-compose up -d

# Comando utilizado pelo cron
COMMAND="sudo docker start container-java-treetech"
# Define o cron timing (exemplo: rodar a cada minuto)
CRON_TIME="* * * * *"
# Verifica se o crontab já existe para o usuário
(crontab -l 2>/dev/null) || echo "" > /tmp/crontab_backup
# Verifica se o comando já está no crontab
grep -q "$COMMAND" /tmp/crontab_backup
if [ $? -ne 0 ]; then
  # Se o comando não for encontrado, adiciona o cron job
  echo "$CRON_TIME $COMMAND" >> /tmp/crontab_backup
  crontab /tmp/crontab_backup
  echo "Comando adicionado ao crontab com sucesso!"
else
  echo "Comando já existe no crontab."
fi
# Limpa o arquivo temporário
rm /tmp/crontab_backup


echo "Configuração concluída com sucesso!"
