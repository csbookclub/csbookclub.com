set :css_dir, 'stylesheets'
set :images_dir, 'images'

page '/podcast.xml', layout: false

configure :build do
  activate :relative_assets unless ENV['CI']
end

activate :directory_indexes

activate :google_analytics do |ga|
  ga.tracking_id = 'UA-62242525-1'
end

data.books.each do |book_id, book|
  proxy "/#{book_id}/index.html",
    'book.html',
    locals: { book_id: book_id,  book: book },
    ignore: true
end

helpers do
  def cover_art_path(size = :medium)
    {
      small: "/images/cover-art-128.png",
      medium: "/images/cover-art-512.png",
      large: "/images/cover-art-1400.png"
    }[size]
  end

  def cover_art_url(*args)
    url(cover_art_path(*args))
  end

  def discussions
    all = data.books.flat_map { |book_id, book|
      book.discussions.map { |discussion|
        discussion.merge(book: book_id)
      }
    }

    all.select(&:mp3)
  end

  def format_time(seconds)
    m = (seconds / 60).to_s
    s = (seconds % 60).to_s.gsub(/^(\d)$/, '0\1')
    "#{m}:#{s}"
  end

  def podcast_name
    "CS Book Club"
  end

  def podcast_description
    "Computer Science for Everyone"
  end

  def podcast_path
    "/podcast.xml"
  end

  def podcast_url
    url(podcast_path)
  end

  def github_url
    "https://github.com/csbookclub/csbookclub.com"
  end

  def itunes_url
    "https://itunes.apple.com/us/podcast/cs-book-club/id972444981"
  end

  def keywords
    [
      "book club",
      "bookclub",
      "compsci",
      "computer science",
      "cs",
      "programming"
    ]
  end

  def slug(string)
    string.downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '')
  end

  def suggestion_url
    "https://justincampbell.typeform.com/to/rYUFg4"
  end

  def title
    [
      current_page.data.title || yield_content(:title),
      podcast_name
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
