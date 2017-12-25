# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path.
# Rails.application.config.assets.paths << Emoji.images_path
# Add Yarn node_modules folder to the asset load path.
Rails.application.config.assets.paths << Rails.root.join('node_modules')

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in the app/assets
# folder are already added.
Rails.application.config.assets.precompile += %w( 
admin/AdminLTE.min.scss
admin/_all-skins.min.scss
admin/bootstrap.min.scss
plugin/morris.js/morris.scss
admin/adminlte.min.js
admin/pages/dashboard.js
admin/demo.js
plugin/raphael/raphael.min.js
plugin/morris.js/morris.min.js
plugin/jquery-slimscroll/jquery.slimscroll.min.js
plugin/fastclick/fastclick.js
admin.js 
admin.css 
pages.coffee
pages.scss)
