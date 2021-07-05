fx_version "cerulean"
game "gta5"
lua54 "yes"

author "mmleczek (mmleczek.pl)"
version "1.0.2"

ui_page "ui/ui.html"

files {
	"ui/*.css",
	"ui/*.js",
	"ui/*.html"
}

client_script "client.lua"

exports {
	"Show",
	"ShowSync",
	"IsVisible",
	"Hide"
}