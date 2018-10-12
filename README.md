# jekyll-memegen
meme generator for jekyll

This plugin allows jekyll to create memes based on the yaml frontmatter of a markdown file. It lets Jekyll sites automatically create memes in the same way Jekyll normally creates pages.

Installation:
 - Copy files to your Jekyll directory.

Use:
 - Base meme images go in /assets/base_images/ (hardcoded without a variable)
 - Generated images are created in /assets/images/memes/ (also hardcoded)
 - any markdown file with the type meme will be evaluated to create a meme and the meme will be included in the content.

To give credit where it is due, this project borrows heavily from this ruby meme generator: https://github.com/cmdrkeene/memegen
