defmodule Watashi.Template do
  @templates Path.wildcard("templates/*.eex")
             |> Enum.map(fn path ->
               {Path.basename(path, ".eex"), EEx.compile_file(path)}
             end)
             |> Enum.into(%{})

  for {name, _} <- @templates do
    @external_resource "templates/" <> name <> ".eex"
  end

  @doc """
  Execute a pre-compiled template with the given name, and provide the given
  assigns to it if necessary.
  """
  def render(name, assigns \\ []) do
    assigns = Keyword.put_new(assigns, :current_env, current_env())

    {result, _bindings} =
      @templates
      |> Map.get(name)
      |> Code.eval_quoted(assigns: assigns)

    result
  end

  @doc """
  Same as `render/2`, but treats the template as a sub-template, providing its
  contents to a parent "layout" template to wrap it. The layout template
  receives the same list of assigns so it can use the same data.
  """
  def render_layout(name, assigns) when is_list(assigns),
    do: render_layout(name, "_layout.html", assigns)

  def render_layout(name, layout, assigns) do
    partial = render(name, assigns)
    layout_assigns = Keyword.merge(assigns, inner_content: partial)

    render(layout, layout_assigns)
  end

  def current_env do
    Application.get_env(:watashi, :env)
  end
end
