module Jekyll

  class TagGenerator < Generator
    safe true
    def generate(site)
      dir = site.config['tags_dir'] || 'tags'
      site.tags.keys.each do |tag|
        create_tags(tag, dir)
      end
    end

    def create_tags(tag,dir)
      filename = "#{dir}/#{tag}.md"
        File.open(filename, "w") { |f| f.write("---\nlayout: posts_by_tag\ntag: #{tag}\npermalink: /tags/#{tag}/\n---") }
    end

  end
end
