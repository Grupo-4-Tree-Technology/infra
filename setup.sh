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

# Adicionando o comando ao cron para iniciar o container Java a cada minuto:
(crontab -l 2>/dev/null; echo "* * * * * sudo docker start container-java-treetech") | sudo crontab -

echo "Configuração concluída com sucesso!"
