all: ipakeyboard insert
ipakeyboard: insert
	coffee -c jquery.ipa.phonetic.keyboard.coffee
insert:
	coffee -c jquery.at.caret.coffee

min: all
	jsmin < jquery.ipa.phonetic.keyboard.js > jquery.ipa.phonetic.keyboard.min.js
	jsmin < jquery.at.caret.js >jquery.at.caret.min.js
