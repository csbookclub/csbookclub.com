set :css_dir, 'stylesheets'
set :images_dir, 'images'

page '/podcast.xml', layout: false

configure :build do
  activate :relative_assets unless ENV['CI']
end

activate :directory_indexes

data.books.each do |book_id, book|
  proxy "/#{book_id}/index.html",
    'book.html',
    locals: { book_id: book_id,  book: book },
    ignore: true
end

helpers do
  def cover_art_path(size = :medium)
    {
      small: "/cover-art-128.png",
      medium: "/cover-art-512.png",
      large: "/cover-art-1400.png"
    }[size]
  end

  def cover_art_url(*args)
    url(cover_art_path(*args))
  end

  def discussions
    data.books.each_with_object([]) { |(book_id, book), results|
      book.discussions.each do |discussion|
        discussion[:book] = book_id
      end
      results << book.discussions.select(&:mp3)
    }.flatten
  end

  def podcast_name
    "CS Book Club"
  end

  def podcast_description
    "Computer Science for Everyone"
  end

  def podcast_url
    url("podcast.xml")
  end

  def github_url
    "https://github.com/csbookclub/csbookclub.com"
  end

  def itunes_url
    "https://itunes.apple.com/us/podcast/TODO/TODO"
  end

  def keywords
    %w[
      book\ club
      bookclub
      compsci
      computer\ science
      cs
      programming
    ]
  end

  def slug(string)
    string.downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '')
  end

  def title
    [
      podcast_name,
      current_page.data.title || yield_content(:title)
    ].compact.join(" - ")
  end

  def twitter_url
    "https://twitter.com/cs_bookclub"
  end

  def url(path = "", anchor: nil)
    path = path.gsub(/^\//, '')

    result = "http://www.csbookclub.com/#{path}"
    result << "##{slug(anchor)}" if anchor
    result
  end
end
