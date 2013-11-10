xml.instruct!
xml.feed "xmlns" => "http://www.w3.org/2005/Atom" do
  xml.title "Alex Blackie"
  xml.subtitle "The Internet Sensation"
  xml.id "http://www.alexblackie.com/"
  xml.link "href" => "http://www.alexblackie.com/"
  xml.link "href" => "http://www.alexblackie.com/feed.xml", "rel" => "self"
  xml.updated blog.articles.first.date.to_time.iso8601
  xml.author { xml.name "Alex Blackie" }

  blog.articles[0..5].each do |article|
    xml.entry do
      xml.title article.title
      xml.link "rel" => "alternate", "href" => article.url
      xml.id article.url
      xml.published article.date.to_time.iso8601
      xml.updated article.date.to_time.iso8601
      xml.author { xml.name "Alex Blackie" }
      xml.content article.body, "type" => "html"
    end
  end
end
