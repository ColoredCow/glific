defmodule GlificWeb.StripeWebhook do
  @moduledoc """
  Simple plug to handle and authenticate incoming webhook calls from Stripe
  """

  @behaviour Plug

  alias Plug.Conn

  @doc false
  def init(config), do: config

  @doc false
  def call(%{request_path: "/webhook/stripe"} = conn, _) do
    signing_secret = Application.fetch_env!(:stripity_stripe, :signing_secret)
    [stripe_signature] = Conn.get_req_header(conn, "stripe-signature")

    # using the raw body which we've cached in the endpoint for all webhook urls
    body = conn.assigns[:raw_body]

    case Stripe.Webhook.construct_event(body, stripe_signature, signing_secret) do
      {:ok, stripe_event} ->
        conn
        |> Plug.Conn.assign(:stripe_event, stripe_event)

      {:error, error} ->
        conn
        |> Conn.send_resp(:bad_request, inspect(error))
        |> Conn.halt()
    end
  end

  @doc false
  def call(conn, _), do: conn
end
