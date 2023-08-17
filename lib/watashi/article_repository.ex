defmodule Watashi.ArticleRepository do
  use Watashi.Repository,
    glob: "articles/*.{md,html}",
    name: :articles_repo,
    parser: &parser/2,
    sorter: &sorter/2

  def parser(filename, raw) do
    [raw_meta, raw_content] = String.split(raw, "---\n", parts: 2)

    {:ok, meta} = YamlElixir.read_from_string(raw_meta)

    ext = Path.extname(filename)

    content =
      case ext do
        ".md" ->
          {:ok, content, _} = Earmark.as_html(raw_content)
          content

        ".html" ->
          raw_content
      end

    cover_photo =
      if cover = meta["cover"] do
        Watashi.CoverPhoto.from(cover)
      else
        nil
      end

    Watashi.Article.from(meta)
    |> Map.merge(%{
      id: Path.basename(filename, Path.extname(filename)),
      content: raw_content,
      rendered_content: content,
      cover: cover_photo
    })
  end

  def sorter(a, b), do: Date.compare(a.published_at, b.published_at) == :gt
end
