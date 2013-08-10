###
This JQuery plugin provides cross-browser support for inserting and deleting text at the caret (to some, cursor) position, as well as getting and setting the caret position.
###
$ = jQuery
methods = {
	# Insert value at position
	insert: (value) ->
		o = this[0]
		pos = methods['getCaretPosition'].apply this

		before = o.value.substring(0, pos)
		after = o.value.substring(pos, o.value.length)
		$(o).val(before+value+after)
		pos += value.length
		methods['setCaretPosition'].apply this, [pos]

	# Deletes value just before the cursor
	backspace: ->
		o = this[0]
		pos = methods['getCaretPosition'].apply this

		before = o.value.substring(0, pos-1)
		after = o.value.substring(pos, o.value.length)
		$(o).val(before+after)
		pos -= 1
		methods['setCaretPosition'].apply this, [pos]

	# Deletes value after cursor
	delete: ->
		o = this[0]
		pos = methods['getCaretPosition'].apply this

		before = o.value.substring(0, pos)
		after = o.value.substring(pos+1, o.value.length)
		$(o).val(before+after)
		methods['setCaretPosition'].apply this, [pos]

	# Gets the caret position
	getCaretPosition: ->
		o = this[0]
		caretPos = 0
		# IE
		if document.selection
			o.focus()
			sel = document.selection.createRange()
			sel.moveStart 'character', -o.value.length
			caretPos = sel.text.length
		else if o.selectionStart or o.selectionStart == '0'
			caretPos = o.selectionStart
		return caretPos

	# Set the caret position
	setCaretPosition: (pos) ->
		o = this[0]
		if o.setSelectionRange
			o.focus()
			o.setSelectionRange pos, pos
		else if o.createTextRange
			f = -> o.focus()
			setTimeout f, 10

			f = (o, pos) ->
				range = o.createTextRange()
				range.collapse(true)
				range.moveEnd('character', pos)
				range.moveStart('character', pos)
				range.select()
			setTimeout "f(o, pos)", 20
			return pos
}

###
Set up the plugin
###
$.fn.atCaret = (method) ->
	if methods[method]
		return methods[ method ].apply this, Array.prototype.slice.call arguments, 1
	else if typeof method == 'object' or ! method
		return methods.init.apply this, arguments
	else
		$.error 'Method ' +  method + ' does not exist on jQuery.atCaret'
