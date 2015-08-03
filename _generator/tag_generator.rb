require 'yaml'

tags = YAML::load_file('./_data/tags.yml')
# puts tags.inspect
tags.each do |tag|
  filename = "./tags/#{tag}.md"
  puts tag
  if File.exist?(filename) then
    puts "#{tag}.md exist!"
  elsif
    # puts "#{tag}.md not exist!"
    File.open(filename, "w") { |f| f.write("---\nlayout: posts_by_tag\ntag: #{tag}\npermalink: /tags/#{tag}/\nredirect_from: /tag/#{tag}/\n---") }
  end
end
