fx_version 'cerulean'

game "gta5"

author "Xirvin"
version '0.0.1'

lua54 'yes'


ui_page 'html/index.html'
-- ui_page "http://localhost:3000/"


client_script {
  'client/tables.lua',
  'client/camHandler.lua',
  'client/functions.lua',
  'client/client.lua',
}
server_script {
  "server/**",
  }


files {
  'html/**',
}
