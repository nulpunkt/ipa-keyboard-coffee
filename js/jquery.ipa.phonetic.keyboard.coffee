###
Implements a Phonetic Keyboard on top of an input field
###
$ = jQuery

lastKey = -1
index = 0
$.fn.ipaPhoneticKeyboard = (options) ->
	# Define standard settings
	settings = {
		characters: {
			'a': [ "ɑ", "ɐ" ]
			'b': [ "β", "ɓ", "ʙ" ]
			'c': [ "ɕ", "ç" ]
			'd': [ "ð", "d͡ʒ", "ɖ", "ɗ" ]
			'e': [ "ə", "ɚ", "ɵ", "ɘ" ]
			'f': [ "ɛ", "ɜ", "ɝ", "ɛ̃", "ɞ" ]
			'g': [ "ɠ", "ɢ", "ʛ" ]
			'h': [ "ɥ", "ɦ", "ħ", "ɧ", "ʜ" ]
			'i': [ "ɪ", "ɪ̈", "ɨ" ]
			'j': [ "ʝ", "ɟ", "ʄ" ]
			'k': [ "|", "‖" ]
			'l': [ "ɫ", "ɬ", "ʟ", "ɭ", "ɮ" ]
			'm': [ "ɱ" ]
			'n': [ "ŋ", "ɲ", "ɴ", "ɳ" ]
			'o': [ "ɔ", "œ", "ø", "ɒ", "ɔ̃", "ɶ" ]
			'p': [ "ɸ" ]
			'r': [ "ɾ", "ʁ", "ɹ", "ɻ", "ʀ", "ɽ", "ɺ" ]
			's': [ "ʃ", "ʂ" ]
			't': [ "θ", "t͡ʃ", "t͡s", "ʈ" ]
			'u': [ "ʊ", "ʊ̈", "ʉ" ]
			'v': [ "ʌ", "ʋ", "ⱱ" ]
			'w': [ "ʍ", "ɯ", "ɰ" ]
			'x': [ "χ" ]
			'y': [ "ʎ", "ɣ", "ʏ", "ɤ" ]
			'z': [ "ʒ", "ʐ", "ʑ" ]
			'1': [ "ˈ", "ˌ", "ː", "ˑ" ]
			'3': [ "→", "ʼ", "ᵊ", "˞", "ʰ", "ʷ", "ʲ", "~" ]
			'4': [ "˥", "˦", "˧", "˨", "˩", "˩˥", "˥˩", "˦˥", "˩˨", "˧˦˧" ]
			'5': [ "↓", "↑", "↗", "↘", "ʘ", "ǀ", "ǃ", "ǂ", "ǁ" ]
		}
		showCheatsheat: true
	}

	###
	Prevent browser from displaying capitals
	###
	$(this).bind 'keyup keypress', (event) ->
		current = String.fromCharCode(event.which).toLowerCase()
		if event.shiftKey and settings.characters[current]
			preventDefaultAction event
	###
	Respond to key press!
	When user press a key, we need to override default action
	###
	$(this).keydown (event) ->
		# Figure what the character pressed was
		current = String.fromCharCode(event.which).toLowerCase()
		# And the character before that
		last = String.fromCharCode(lastKey).toLowerCase()
			
		# If we show the cheatsheat, do nok mark the last character pressed
		if settings.showCheatsheat then	getTdAt($(this).next(), last, index).css('color', 'black')

		if event.shiftKey and settings.characters[current]
			preventDefaultAction event

			if lastKey != event.which
				# If a new key is pressed, we insert a new character
				index = 0
				p = settings.characters[current][index]
				$(this).atCaret 'insert', p
			else
				# Else we cycle through possible fonetic characters related to the character pressed
				if this.selectionStart or this.selectionStart == 0
					charLen = settings.characters[last][index].length
					for i in [1..charLen]
						$(this).atCaret 'backspace'
				else $(this).atCaret 'backspace'
				
				index = (index+1) % settings.characters[current].length
				$(this).atCaret 'insert', settings.characters[current][index]
			
			# If we show the cheatsheat, do mark the current character pressed
			if settings.showCheatsheat then getTdAt($(this).next(), current, index).css('color', 'red')

		lastKey = event.which
	
	###
	Helper function. Returns the td at a character e.g. 'a' and
	index e.g. 0
	###
	getTdAt = (table, char, index) ->
		row = 0
		i = 0
		$.each settings.characters, (k, v) ->
			if k == char
				return row = i
			else i++
		index += 1
		return table.find("tr").eq(row).find("td").eq(index)

	###
	Tries to prevent the default action for
	either webkit or ie
	###
	preventDefaultAction = (event) ->
		if event.preventDefault then event.preventDefault()
		else event.returnValue = false

	# A little help, maybe?
	if settings.showCheatsheat
		cheatsheat = null
		click = false
		field = $(this)
		$(this).focus ->
			if cheatsheat is not null
				cheatsheat.css('display', 'inline')
			else
				# Prepare the table for the cheatsheat
				field = $(this)

				table = $("<table></table>")
					.css('width', '200px')
					.css('text-align', 'center')

				$.each settings.characters, (k, v) ->
					tr = $("<tr></tr>")
						.css('border-bottom', '1px solid black')
					tr.append("<td><strong>"+k+"</strong></td>")
					$.each v, (k, v) ->
						tr.append('<td>'+v+"</td>")
					table.append tr

				field = $(this)
				$("tr", table).find("td:not(:first)").css('cursor', 'pointer').mousedown (event) ->
					preventDefaultAction event
					field.atCaret 'insert', $(this).html()

				left = $(this).offset().left
				top = $(this).offset().top + $(this).height()+20
				cheatsheat = $('<span></span>')
					.css('position', 'absolute')
					.css('left', left)
					.css('top', top)
					.css('z-index', '2')
					.css('background-color', '#f1f1fd')
					.css('padding', '10px')
					.css('border', '1px solid black')
					.css('border-collapse', 'collapse')
					.append("Use [shift] + character to select ipa-character.")
					.append(table)
				cheatsheat.insertAfter($(this))

		$(this).blur ->
			$(cheatsheat).css('display', 'none')
