# Places API

[![Build Status](https://travis-ci.org/ramonsantos/places-api.svg?branch=master)](https://travis-ci.org/ramonsantos/places-api)
[![Maintainability](https://api.codeclimate.com/v1/badges/efa72aa4b1a4b713255c/maintainability)](https://codeclimate.com/github/ramonsantos/places-api/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/efa72aa4b1a4b713255c/test_coverage)](https://codeclimate.com/github/ramonsantos/places-api/test_coverage)

## Resumo

O desafio foi implementado em Ruby on Rails e os testes em RSpec. Os dados são armazenados no PostgreSQL e gem [Geokit](https://github.com/geokit/geokit-rails) foi usada na parte da localização. O método de autenticação usado é o JWT (JSON Web Tokens).

Foi criado um processo de CI/CD usando Travis CI, que é iniciado quando um push é feito para a master do repositório no Github. O processo de CI/CD consiste em fazer build do projeto, criar e migrar o banco de dados, fazer uma análise de segurança com o Brakeman (o processo falha se for encontrada alguma vulnerabilidade) e rodar os testes (o processo falha se algum teste quebrar ou se a cobertura de testes for menor que 95%). Se não acontecer problemas em nenhum dos passos anteriores, a API será implantada no Heroku.

### Tecnologias

* Ruby (MRI) 2.7.1
* Ruby on Rails 6
* PostgreSQL
* Docker Compose
* JWT
* Geokit Rails
* RSpec

### Documentação

Os endpoints desenvolvidos foram documentados através do Postman e a documentação está disponível [neste link](https://documenter.getpostman.com/view/8343594/TVCe18Jo#dd3418e8-af0a-4545-af6b-2d65bb8ae599).

Uma coleção com exemplos de requisições pode ser importada pelo Postman com este link: https://www.getpostman.com/collections/7d45c971bbab1e7913df. A coleção possui as seguintes variáveis de ambiente:

* **HOST:** ```localhost:3000``` para requisições em desenvolvimento e ```https://api-places-mesa.herokuapp.com``` para requisições em produção.
* **JWT_TOKEN:** deve ser preenchido com o token retornado da requisição ao endpoint de login.

### Produção

A API está hospedada no Heroku e disponível neste endereço https://api-places-mesa.herokuapp.com.

**Obs.:** A primeira requisição pode levar alguns segundos pra responder por conta das limitações do plano free do Heroku. As demais requisições devem ser respondidas no tempo normal.

## Instruções

### Instalar Ruby

Usando [rbenv](https://github.com/rbenv/rbenv)

``` bash
rbenv install 2.7.1
```

### Instalar PostgreSQL

Usando [Docker Compose](https://docs.docker.com/compose/)

``` bash
docker-compose up -d
```

### Instalar as Dependências

``` bash
bundle install
```

### Criar e Migrar o Bando de Dados

``` bash
bundle exec rake db:prepare
```

### Criar Dados de Desenvolvimento (Opcional)

``` bash
bundle exec rake dev:seed
```

### Rodar os Testes

``` bash
bundle exec rspec
```

### Rodar a Aplicação

``` bash
rails server
```
