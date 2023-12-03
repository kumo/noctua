defmodule NoctuaWeb.UserView do
  use NoctuaWeb, :view

  def title("show.html", assigns) do
    assigns.user.first_name <> " " <> assigns.user.last_name
  end

  def title("index.html", _assigns) do
    "Elenco Utenti"
  end

  def title("new.html", _assigns) do
    "Nuova Utente"
  end

  def title("edit.html", _assigns) do
    "Modifica Utente"
  end

  def title(_action, _assigns), do: "Utenti"

  def show_role(%Noctua.Accounts.User{role: :Admin} = _user) do
    "🧑🏻‍💻‍ - Admin"
  end

  def show_role(%Noctua.Accounts.User{role: :Secretary} = _user) do
    "🧑🏻‍💼 - Segreteria"
  end

  def show_role(%Noctua.Accounts.User{role: :Teacher, teacher: nil} = _user) do
    "🧑🏻‍🏫" <> " - " <> "???"
  end

  def show_role(%Noctua.Accounts.User{role: :Teacher} = user) do
    "🧑🏻‍🏫" <> " - " <> full_name(user.teacher)
  end

  def show_role(%Noctua.Accounts.User{role: :Parent} = user) do
    "👪" <> " - " <> full_name(user.parent)
  end
end
