<?php
header('content-type: text/html; charset=utf-8');
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en">
<head>
<meta http-equiv="language" content="da_DK" />
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<script src="http://www.google.com/jsapi" charset="utf-8"></script> 
<script type="text/javascript" charset="utf-8"> 
	google.load("jquery", "1.6.2");
</script> 
<script src="js/jquery.at.caret.js" charset="utf-8" type="text/javascript"></script>
<script src="js/jquery.ipa.phonetic.keyboard.js" charset="utf-8" type="text/javascript"></script> 
<script type="text/javascript">
$(document).ready(function() {
	$("input").ipaPhoneticKeyboard();
});
</script>
</head>
<body>
<input />
<input />
<div id="out"></div>
</body>
</html>
