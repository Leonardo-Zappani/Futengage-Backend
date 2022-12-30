# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

## Ruby version
- v3.1.2

Se não possuir a versão 3.1.2, você pode instalar utilizando o RBENV como exemplo abaixo:
- `$ rbenv install 3.1.2`

## System dependencies
Utilizar de preferência um Sistema Operacional UNIX (MacOS ou Linux), se utilizar windows, executar o projeto com WSL2

## Configuration

Antes de iniciar a execução do projeto é preciso configurá-lo executando os seguintes comandos:
- `$ bundle install`
- `$ yarn install` (não utilizar npm)
- `$ docker-compose up`

Em outro terminal, executar os seguintes comandos do Rails:
- `$ rails db:create`
- `$ rails db:migrate`
- `$ rails c` e rodar o comando `Money.default_bank.update_rates`

Agora podemos executar a aplicação:
- `$ bin/dev`

## Database creation
- `$ rails db:create`

## Database initialization
- `$ rails db:migrate`

## How to run the test suite
- `$ rails test`

## Services (job queues, cache servers, search engines, etc.)

## Deployment instructions

