defmodule PentoWeb.WrongLive do
  use PentoWeb, :live_view

  @impl true
  def mount(_params, session, socket) do
    {
      :ok,
      assign(
        socket,
        score: 0,
        message: "Guess a number.",
        time: time,
        needle: :rand.uniform(10),
        won: false,
        user: Pento.Accounts.get_user_by_session_token(session["user_token"]),
        session_id: session["live_socket_id"]

      )
    }
  end

  @impl true
  def handle_event(
        "guess",
        %{"number" => guess},
        %{
          assigns: %{
            score: score,
            needle: needle
          } = assigns
        } = socket
      ) do


    guess_int = String.to_integer(guess)
    won = guess_int === needle

    score = case won do
      true -> score + 1
      _ -> score - 1
    end

    message = case won do
      true -> "You won!!!"
      _ -> "Your guess: #{guess}. Wrong. Guess again."
    end

    {
      :noreply,
      assign(
        socket,
        score: score,
        message: message,
        time: time,
        won: won
      )
    }
  end

  def time() do
    DateTime.utc_now
    |> to_string
  end
end
