xml.instruct!
xml.rss(
  'xmlns:atom' => "http://www.w3.org/2005/Atom",
  'xmlns:itunes' => "http://www.itunes.com/dtds/podcast-1.0.dtd",
  'xmlns:googleplay' => "http://www.google.com/schemas/play-podcasts/1.0",
  'xmlns:content' => "http://purl.org/rss/1.0/modules/content/",
  'xmlns:media' => "http://search.yahoo.com/mrss/",
  'version' => "2.0"
) do
  xml.channel do
    xml.title podcast_name
    xml.description podcast_description
    xml.copyright "2015-#{Time.now.year} #{podcast_name}"
    xml.language "en-us"
    xml.link podcast_url

    xml.image do
      xml.link podcast_url
      xml.title podcast_name
      xml.url cover_art_url(:medium)
    end

    xml.googleplay :author, podcast_name
    xml.googleplay :email, podcast_email

    xml.itunes :author, podcast_name
    xml.itunes :email, podcast_email
    xml.itunes :explicit, "no"
    xml.itunes :image, href: cover_art_url(:large)
    xml.itunes :summary, podcast_description

    xml.itunes :category, text: "Education" do
      xml.itunes :category, text: "Educational Technology"
    end

    xml.itunes :category, text: "Technology" do
      xml.itunes :category, text: "Software How-To"
    end

    xml.itunes :keywords, keywords.join(',')

    discussions.each do |discussion|
      xml.item do
        book = data.books[discussion.book]

        title = "#{book.title}: #{discussion.name}"

        xml.title title
        xml.link url(discussion.book)
        xml.description partial(:book_text, locals: { book: book }) + partial(:shownotes_footer)
        xml.content :encoded, partial(:book, locals: { book_id: discussion.book, book: book }) + partial(:shownotes_footer)

        xml.pubDate (discussion.date.to_time + (15 * 60 * 60)).strftime("%a, %d %b %Y %H:%M:%S %z")
        xml.guid url(discussion.book, anchor: discussion.name), isPermaLink: "true"
        xml.media :content, url: discussion.mp3, type: "audio/mpeg", fileSize: discussion.bytes
        xml.enclosure url: discussion.mp3, type: "audio/mpeg", length: discussion.bytes

        xml.itunes :subtitle, discussion.name
        xml.itunes :summary, discussion.name
        xml.itunes :author, podcast_name
        xml.itunes :explicit, "no"
        xml.itunes :duration, discussion.seconds
        xml.itunes :keywords, keywords.join(',')
        xml.itunes :image, href: cover_art_url(:large)
      end
    end
  end
end
