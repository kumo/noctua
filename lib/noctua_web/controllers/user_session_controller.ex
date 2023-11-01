defmodule NoctuaWeb.UserSessionController do
  use NoctuaWeb, :controller

  alias Noctua.Accounts
  alias NoctuaWeb.UserAuth

  def new(conn, _params) do
    render(conn, "new.html", error_message: nil)
  end

  def create(conn, %{"user" => user_params}) do
    %{"email" => email, "password" => password} = user_params

    if user = Accounts.get_user_by_email_and_password(email, password) do
      UserAuth.log_in_user(conn, user, user_params)
    else
      # In order to prevent user enumeration attacks, don't disclose whether the email is registered.
      render(conn, "new.html", error_message: "Invalid email or password")
    end
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "Logged out successfully.")
    |> UserAuth.log_out_user()
  end

  # login with a magic token
  def login(conn, %{"token" => token}) do
    user = Accounts.get_user_by_token(token)

  if user do
    UserAuth.log_in_user(conn, user, %{})

    conn
    # |> put_session(:user_id, user.id)
    # |> configure_session(renew: true)
    |> redirect(to: "/")
  else
    # handle invalid token
      render(conn, "new.html", error_message: "Invalid token")
    end
  end
end
