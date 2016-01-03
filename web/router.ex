defmodule MarketApi.Router do
  use MarketApi.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json-api"]
    plug JaSerializer.ContentTypeNegotiation
    plug JaSerializer.Deserializer
  end

  scope "/", MarketApi do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  scope "/api", MarketApi do
    pipe_through :api

    resources "/markets", MarketController, except: [:new, :edit] do
      resources "/products", ProductController, only: [:index]
    end

    resources "/products", ProductController, except: [:index, :new, :edit]
  end
end
