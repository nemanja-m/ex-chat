# ex |> chat

[![Build Status](https://semaphoreci.com/api/v1/nemanja-m/ex-chat/branches/master/badge.svg)](https://semaphoreci.com/nemanja-m/ex-chat)

Distributed chat application built with Elixir/Phoenix and React + Redux, along with RabbitMQ for publishing messages.

## Up And Running

### Prerequisites

In order to run applications you need several things:

* [Elixir v1.4.2](http://elixir-lang.org/install.html)
* [Phoenix v1.2.1](http://www.phoenixframework.org/docs/installation)
* [Yarn](https://yarnpkg.com/en/docs/install)
* [RabbitMQ](http://www.rabbitmq.com/download.html)

### Setup

Run `./scripts/setup` to install mix dependencies, compile applications, configure database and
install `yarn` dependencies.

__NOTE__: Before you run `./scripts/setup` make sure you have installed everything from `Prerequisites`.

### Running the applications

Make sure you have:

* RabbitMQ server running on `amqp://localhost`
* PostgreSQL user specified at `apps/user_app/config/dev.exs`

Start applications with `./scripts/start` and when applications are up and running go [here](http://localhost:4000).

Stop applications with `./scripts/stop`.

### Running the tests

Run tests with `mix test`

## Licence

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details
