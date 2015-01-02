xml.instruct!
xml.rss(
  'xmlns:atom' => "http://www.w3.org/2005/Atom",
  'xmlns:itunes' => "http://www.itunes.com/dtds/podcast-1.0.dtd",
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

    xml.itunes :author, podcast_name
    xml.itunes :explicit, "no"
    xml.itunes :image, href: cover_art_url(:large)
    xml.itunes :summary, podcast_description

    xml.itunes :category, text: "Education" do
      xml.itunes :category, text: "Educational Technology"
    end

    xml.itunes :category, text: "Technology" do
      xml.itunes :category, text: "Software How-To"
      xml.itunes :category, text: "Tech News"
    end

    xml.itunes :keywords, keywords.join(',')

    podcast_episodes.each do |episode|
      xml.item do
        xml.title episode.name
        # xml.link url(episode.url)
        xml.description episode.name
        # xml.content :encoded, episode.body + partial(:shownotes_footer, locals: { episode: episode })
        xml.pubDate (episode.date.to_time + (15 * 60 * 60)).strftime("%a, %d %b %Y %H:%M:%S %z")
        # xml.guid url(episode.url), isPermaLink: "true"
        xml.media :content, url: episode.mp3, type: "audio/mpeg", fileSize: episode.bytes
        xml.enclosure url: episode.mp3, type: "audio/mpeg", length: episode.bytes

        xml.itunes :subtitle, episode.name
        xml.itunes :summary, episode.name
        xml.itunes :author, podcast_name
        xml.itunes :explicit, "no"
        xml.itunes :duration, episode.seconds
        xml.itunes :keywords, keywords.join(',')
        xml.itunes :image, href: cover_art_url(:large)
      end
    end
  end
end
