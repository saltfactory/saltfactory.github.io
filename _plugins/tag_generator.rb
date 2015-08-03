module Jekyll
  # class TagIndex < Page
  #   def initialize(site, base, dir, tag)
  #     @site = site
  #     @base = base
  #     @dir = dir
  #     @name = 'index.html'
  #     self.process(@name)
  #     self.read_yaml(File.join(base, '_layouts'), 'tag_index.html')
  #     self.data['tags'] = tag
  #     tag_title_prefix = site.config['tag_title_prefix'] || 'Posts Tagged &ldquo;'
  #     tag_title_suffix = site.config['tag_title_suffix'] || '&rdquo;'
  #     self.data['title'] = "#{tag_title_prefix}#{tag}#{tag_title_suffix}"
  #   end
  # end
  class TagGenerator < Generator
    safe true
    def generate(site)
      if site.layouts.key? 'tag_index'
        dir = site.config['tags_dir'] || 'tags'
        site.tags.keys.each do |tag|
          # write_tag_index(site, File.join(dir, tag), tag)
          # puts tag
          create_tags(tag, dir)
        end
      end
    end

    def create_tags(tag,dir)
      filename = "#{dir}/#{tag}.md"
      # puts filename
      if not File.exist?(filename) then
        # puts "#{tag}.md not exist!"
        File.open(filename, "w") { |f| f.write("---\nlayout: posts_by_tag\ntag: #{tag}\npermalink: /tags/#{tag}/\nredirect_from: /tag/#{tag}/\n---") }
      end
    end


    # def write_tag_index(site, dir, tag)
    #   index = TagIndex.new(site, site.source, dir, tag)
    #   puts dir
    #   index.render(site.layouts, site.site_payload)
    #   index.write(dir)
    #   # site.pages << index
    # end
  end
  	end

# require 'yaml'
#
# tags = YAML::load_file('./_data/tags.yml')
# tags.each do |tag|
#   puts tag
#   # filename = "./tags/#{tag.tag}.md"
#   #
#   # if File.exist?(filename) then
#   #   puts "#{filenameg}.md exist!"
#   # elsif
#   #   puts "#{filename}.md not exist!"
#   #   # File.open(filename, "w") { |f| f.write("---\nlayout: posts_by_tag\ntag: #{tag.tag}\npermalink: #{tag.permalink}\nredirect_from: #{tag.redirect_from}\n---") }
#   # end
# end
