defmodule NoctuaWeb.SubjectLiveTest do
  use NoctuaWeb.ConnCase

  import Phoenix.LiveViewTest
  import Noctua.TimetablingFixtures

  @create_attrs %{name: "some name"}
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil}

  defp create_subject(_) do
    subject = subject_fixture()
    %{subject: subject}
  end

  describe "Index" do
    setup [:create_subject]

    test "lists all subjects", %{conn: conn, subject: subject} do
      {:ok, _index_live, html} = live(conn, ~p"/subjects")

      assert html =~ "Listing Subjects"
      assert html =~ subject.name
    end

    test "saves new subject", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/subjects")

      assert index_live |> element("a", "New Subject") |> render_click() =~
               "New Subject"

      assert_patch(index_live, ~p"/subjects/new")

      assert index_live
             |> form("#subject-form", subject: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#subject-form", subject: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/subjects")

      html = render(index_live)
      assert html =~ "Subject created successfully"
      assert html =~ "some name"
    end

    test "updates subject in listing", %{conn: conn, subject: subject} do
      {:ok, index_live, _html} = live(conn, ~p"/subjects")

      assert index_live |> element("#subjects-#{subject.id} a", "Edit") |> render_click() =~
               "Edit Subject"

      assert_patch(index_live, ~p"/subjects/#{subject}/edit")

      assert index_live
             |> form("#subject-form", subject: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#subject-form", subject: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/subjects")

      html = render(index_live)
      assert html =~ "Subject updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes subject in listing", %{conn: conn, subject: subject} do
      {:ok, index_live, _html} = live(conn, ~p"/subjects")

      assert index_live |> element("#subjects-#{subject.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#subjects-#{subject.id}")
    end
  end

  describe "Show" do
    setup [:create_subject]

    test "displays subject", %{conn: conn, subject: subject} do
      {:ok, _show_live, html} = live(conn, ~p"/subjects/#{subject}")

      assert html =~ "Show Subject"
      assert html =~ subject.name
    end

    test "updates subject within modal", %{conn: conn, subject: subject} do
      {:ok, show_live, _html} = live(conn, ~p"/subjects/#{subject}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Subject"

      assert_patch(show_live, ~p"/subjects/#{subject}/show/edit")

      assert show_live
             |> form("#subject-form", subject: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#subject-form", subject: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/subjects/#{subject}")

      html = render(show_live)
      assert html =~ "Subject updated successfully"
      assert html =~ "some updated name"
    end
  end
end
