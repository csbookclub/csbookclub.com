set :css_dir, 'stylesheets'
set :images_dir, 'images'

configure :build do
end

helpers do
  def podcast_name
    "CS Book Club"
  end

  def podcast_description
    "Computer Science for Everyone"
  end

  def title
    [
      podcast_name,
      current_page.data.title || yield_content(:title)
    ].compact.join(" - ")
  end
end
