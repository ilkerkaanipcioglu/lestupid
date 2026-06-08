defmodule DukkadeeWeb.StoreTemplateHTML do
  use DukkadeeWeb, :html

  import DukkadeeWeb.StoreTemplateComponents
  import DukkadeeWeb.CoreComponents
  
  embed_templates "store_template_html/*"
  
  # Custom form helpers
  def error_tag(form, field) do
    Enum.map(Keyword.get_values(form.errors, field), fn error ->
      content_tag(:span, translate_error(error),
        class: "block mt-1 text-sm text-red-600",
        phx_feedback_for: input_name(form, field)
      )
    end)
  end
  
  defp translate_error({msg, opts}) do
    if count = opts[:count] do
      Gettext.dngettext(DukkadeeWeb.Gettext, "errors", msg, msg, count, opts)
    else
      Gettext.dgettext(DukkadeeWeb.Gettext, "errors", msg, opts)
    end
  end
  
  defp input_name(form, field) do
    form.name <> "[" <> to_string(field) <> "]"
  end
  
  # We'll use a simpler content_tag implementation that doesn't use HEEx
  defp content_tag(tag, content, attrs) do
    attrs_str = attrs
                |> Enum.map(fn {k, v} -> "#{k}=\"#{v}\"" end)
                |> Enum.join(" ")
                
    Phoenix.HTML.raw("<#{tag} #{attrs_str}>#{content}</#{tag}>")
  end
end
