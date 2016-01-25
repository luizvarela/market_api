defmodule MarketApi.ProductController do
  use MarketApi.Web, :controller

  alias MarketApi.Product
  alias MarketApi.Market

  plug :scrub_params, "product" when action in [:create, :update]
  plug :assign_market

  def index(conn, _params) do
    products = Repo.all(assoc(conn.assigns[:market], :products))
    render(conn, "index.json", products: products)
  end

  def create(conn, %{"product" => product_params}) do
    changeset = conn.assigns[:market]
     |> build_assoc(:products)
     |> Product.changeset(product_params)

    case Repo.insert(changeset) do
      {:ok, product} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", market_product_path(conn, :show, conn.assigns[:market], product))
        |> render("show.json", product: product)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(MarketApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    product = Repo.get!(assoc(conn.assigns[:market], :products), id)
    render(conn, "show.json", product: product)
  end

  def update(conn, %{"id" => id, "product" => product_params}) do
    product = Repo.get!(assoc(conn.assigns[:market], :products), id)
    changeset = Product.changeset(product, product_params)

    case Repo.update(changeset) do
      {:ok, product} ->
        render(conn, "show.json", product: product)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(MarketApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    product = Repo.get!(assoc(conn.assigns[:market], :products), id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(product)

    send_resp(conn, :no_content, "")
  end

  defp assign_market(conn, _) do
    %{"market_id" => market_id} = conn.params
    if market = Repo.get(Market, market_id) do
      assign(conn, :market, market)
    else
      conn
      |> put_status(:unprocessable_entity)
      |> render(MarketApi.ChangesetView, "error.json", message: "Market Not Found")
    end
  end
end
