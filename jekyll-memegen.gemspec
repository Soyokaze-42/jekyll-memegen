Gem::Specification.new do |s|
  s.name        = 'jekyll-memegen'
  s.version     = '0.0.0'
  s.date        = '2018-10-15'
  s.summary     = "meme generator for Jekyll"
  s.description = "This gem creates memes from Jekyll frontmatter"
  s.authors     = ["Robbie Nichols"]
  s.email       = 'nichols.robbie@gmail.com'
  s.files       = ["lib/jekyll-memegen.rb"]
  s.homepage    = 'https://github.com/Soyokaze-42/jekyll-memegen'
  s.license     = 'MIT'
  
  spec.add_dependency "jekyll", "~> 3.3"
  spec.add_dependency "rmagick", "~> 2.1"
  spec.add_dependency "fileutils"
  spec.add_dependency "yaml"
end
