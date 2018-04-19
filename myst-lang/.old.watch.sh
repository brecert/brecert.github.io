#ruby ./listener.rb & stylus ./src --out ./public --watch && kill $!

ruby ./listener.rb & pid1="$!" & stylus ./src --out ./public --watch

#pug ./src --obj ./src/vars.js --out ./public --watch & stylus ./src --out ./public --watch
# node-sass src --output . ./public --watch
# stylus src --out ./public --watch
# npm install --save jstransformer-markdown-it

# Actual    : #2D4752 NO#4f7f93
# Gravit    : #273F4A
# Displayed : 79.05 127.5 147.9 (NO#4f8094)
# Chrome    : 45.9, 71.4, 81.6 (#233840) (NO#467182)
# Firefox   : 51, 81.6, 91.8 (#273F4A) (NO#518299)