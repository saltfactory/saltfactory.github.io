module Jekyll

  class CategoryGenerator < Generator

    safe true

    def generate(site)
      dir = site.config['categories_dir'] || 'categories'
      # puts dir
      # puts site.data["categories"]["android"]

      site.categories.keys.each do |category|
        # write_tag_index(site, File.join(dir, tag), tag)
        category_data = site.data["categories"]["#{category}"]
        filename = "#{dir}/#{category}.md"

        if category_data then
          redirect_from = "\n";

          if category_data["redirect_from"].is_a?(Array) then
            category_data["redirect_from"].each do |redriect_url|
              redirect_from += "  - #{redriect_url}\n"
            end
          else
            redirect_from = category_data["redirect_from"]
          end

          content = "---\nlayout: posts_by_category\ncategory: #{category}\npermalink: #{category_data["permalink"]}\nredirect_from: #{redirect_from}\n---"
          create_cateogry(content, filename)
        else
          content = "---\nlayout: posts_by_category\ncategory: #{category}\npermalink: /categories/#{category}/\n---"
          create_cateogry(content, filename)
        end
        # create_tags(tag, dir)
      end
    end

    def create_cateogry(content, filename)
      # puts content
      # if not File.exist?(filename) then
        File.open(filename, "w") { |f| f.write(content) }
      # end
    end

  end
end
