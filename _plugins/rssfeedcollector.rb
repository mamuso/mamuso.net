require 'rss'
require 'open-uri'

# Runs during jekyll build
class RssFeedCollector < Jekyll::Generator
   safe true
   priority :high
   def generate(site)

      url = 'https://mamuso.dev/rss.xml'
      URI.open(url) do |rss|
         feed = RSS::Parser.parse(rss)
      
         # Create a new on-the-fly Jekyll collection called "external_feed"
         jekyll_coll = Jekyll::Collection.new(site, 'external_feed')
         site.collections['external_feed'] = jekyll_coll

         # Add fake virtual documents to the collection
         feed.items.each do |item|
            title = item.title
            content = item.description
            guid = item.guid
            path = "_rss/#{guid}.md"
            path = site.in_source_dir(path)
            doc = Jekyll::Document.new(path, { :site => site, :collection => jekyll_coll })
            doc.data['title'] = title;
            doc.data['feed_content'] = content;
            jekyll_coll.docs << doc
         end
      end
   end
end