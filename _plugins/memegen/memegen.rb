require "rmagick"
require "fileutils"
require "yaml"
require "pp"

module Jekyll
  module Memegen
    
    Jekyll::Hooks.register :documents, :pre_render do |page|
      new_meme = Meme.new(page.site)

      if page.data["layout"] == "meme"
        new_meme.top_text = (page.data["top_text"] || ' ')
        new_meme.bottom_text = (page.data["bottom_text"] || ' ')
        new_meme.base_image = (page.data["base_meme"]  || '')
        filename = new_meme.generate
        page.site.static_files << Jekyll::StaticFile.new(page.site, page.site.source, "assets/memes/", filename)
        page.data["source_img"] = "/assets/memes/" + filename
      end

      gallery_path = "assets/memes/"
      gallery = GalleryPage.new(page.site, page.site.source, gallery_path, "memes")
      gallery.render(page.site.layouts, page.site.site_payload)
      gallery.write(page.site.dest)
      page.site.pages << gallery
      PP.pp(gallery.inspect)
      #galleries << gallery
    end
    
    class Meme
      INTERLINE_SPACING_RATIO = 3
      attr_accessor :top_text, :bottom_text, :base_image
      
      def base_image_path()
        @base_images[@base_image]
      end

      def initialize(site)
        @base_images = Hash.new
        @base_image = ' '
        @top_text = ' '
        @bottom_text = ' '

        @target_dir = site.source + "/assets/memes/"
        site.static_files.each do |file|
          if file.relative_path.include? "/assets/base_images"
            @base_images[file.name] = site.source + file.relative_path
          end
        end
      end
      
      def generate()
        path = base_image_path

        top = @top_text.upcase
        bottom = @bottom_text.upcase

        canvas = Magick::ImageList.new(path)
        image = canvas.first

        draw = Magick::Draw.new
        draw.font = File.join(__dir__, "fonts", "Impact.ttf")
        draw.font_weight = Magick::BoldWeight

        pointsize = image.columns / 5.0
        stroke_width = pointsize / 30.0
        x_position = image.columns / 2
        y_position = image.rows * 0.15

        # Draw top
        unless top.empty?
          scale, text = scale_text(top)
          top_draw = draw.dup
          top_draw.annotate(canvas, 0, 0, 0, 0, text) do
            self.interline_spacing = -(pointsize / INTERLINE_SPACING_RATIO) * scale
            self.stroke_antialias(true)
            self.stroke = "black"
            self.fill = "white"
            self.gravity = Magick::NorthGravity
            self.stroke_width = stroke_width * scale
            self.pointsize = pointsize * scale
          end
        end

        # Draw bottom
        unless bottom.empty?
          scale, text = scale_text(bottom)
          bottom_draw = draw.dup
          bottom_draw.annotate(canvas, 0, 0, 0, 0, text) do
            self.interline_spacing = -(pointsize / INTERLINE_SPACING_RATIO) * scale
            self.stroke_antialias(true)
            self.stroke = "black"
            self.fill = "white"
            self.gravity = Magick::SouthGravity
            self.stroke_width = stroke_width * scale
            self.pointsize = pointsize * scale
          end
        end

        output_file = Digest::SHA2.new(256).hexdigest(@base_image + @top_text + @bottom_text) + ".jpeg"
        output_path = @target_dir + output_file

        FileUtils::mkdir_p(@target_dir)
        canvas.write(output_path)
        output_file
      end

      private

      def word_wrap(txt, col = 80)
        txt.gsub(/(.{1,#{col + 4}})(\s+|\Z)/, "\\1\n")
      end

      def scale_text(text)
        text = text.dup
        if text.length < 10
          scale = 0.8
        elsif text.length < 24
          text = word_wrap(text, 16)
          scale = 0.60
        elsif text.length < 48
          text = word_wrap(text, 20)
          scale = 0.45
        else
          text = word_wrap(text, 33)
          scale = 0.3
        end
        [scale, text.strip]
      end
    
    end
  end
end