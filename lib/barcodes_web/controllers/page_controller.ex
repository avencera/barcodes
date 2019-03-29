defmodule BarcodesWeb.PageController do
  use BarcodesWeb, :controller

  def index(conn, %{"prefix" => prefix}) do
    generated = Barcodes.Gtin.generate_all(prefix)
    render(conn, "index.html", generated: generated, prefix: prefix)
  end

  def index(conn, _params) do
    render(conn, "index.html", generated: [], prefix: "")
  end

  def generate(conn, %{"generate" => %{"prefix" => nil}}) do
    redirect(conn, to: Routes.page_path(conn, :index))
  end

  def generate(conn, %{"generate" => %{"prefix" => ""}}) do
    redirect(conn, to: Routes.page_path(conn, :index))
  end

  def generate(conn, %{"generate" => %{"prefix" => prefix}}) do
    redirect(conn, to: Routes.page_path(conn, :index, prefix: prefix))
  end

  def generate(conn, _params) do
    redirect(conn, to: Routes.page_path(conn, :index))
  end
end
