# MarketApi

To start your Phoenix app:

  1. Install dependencies with `mix deps.get`
  2. `cp config/dev.exs.example config/dev.exs`
  3. Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  4. Start Phoenix endpoint with `mix phoenix.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## Test it out

Lauch the app

`mix phoenix.server`

Creating Markets

`curl -i -H "Accept: application/vnd.api+json" -H 'Content-Type:application/vnd.api+json' -X POST -d '{"market":{"name":"My Market", "phone":"123321"}}' http://localhost:4000/api/markets`


Ready to run in production? Please [check our deployment guides](http://www.phoenixframework.org/docs/deployment).

## Learn more

  * Official website: http://www.phoenixframework.org/
  * Guides: http://phoenixframework.org/docs/overview
  * Docs: http://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix
