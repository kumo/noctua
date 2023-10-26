defmodule NoctuaWeb.SubjectLive.Show do
  use NoctuaWeb, :live_view

  alias Noctua.Timetabling

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:subject, Timetabling.get_subject!(id))}
  end

  defp page_title(:show), do: "Show Subject"
  defp page_title(:edit), do: "Edit Subject"
end
