#include <String.au3>
#include <Inet.au3>
#include <File.au3>

For $i = 1 To 721
	TraySetToolTip("Pokemon Image DL" & @CRLF & $i & "...")
	DirCreate(@ScriptDir & "\poke\" & $i)
	$source = _INetGetSource('http://pokemondb.net/pokedex/' & $i)
	$source = StringReplace($source, @CRLF, "")
	$source = StringReplace($source, @CR, "")
	$source = StringReplace($source, @LF, "")
	$source = StringReplace($source, @TAB, "")
	$img = _StringBetween($source, '<img src="https://img.pokemondb.net/artwork/', '.jpg')
	$name = _StringBetween($source, '<h1>', '</h1>')
	$text = _StringBetween($source, 'entries</h2><table class="vitals-table"><tbody><tr>', '</td></tr>')
	if not IsArray($text) Then
		ConsoleWrite(@CRLF & $source & @CRLF)
		Exit
	EndIf
	$remove = _StringBetween($text[0], ' <th>', '<td>')
	$text = StringReplace($text[0], ' <th>' & $remove[0] & '<td>', '')
	$t1 = _StringBetween($source, '<th>Type</th><td><a class="type-icon type-', '"')
	$t2 = _StringBetween($source, '<th>Type</th><td><a class="type-icon type-' & $t1[0] & '"  href="/type/' & $t1[0] & '" >' & $t1[0] & '</a><a class="type-icon type-', '"')
	$weight = _StringBetween($source, '<th>Weight</th><td>', '</td>')
	$height = _StringBetween($source, '<th>Height</th><td>', '</td>')
	$kind = _StringBetween($source, "<th>Species</th><td>", "</td>")
	$height = StringReplace($height[0], '&#8242;', "ft ")
	$height = StringReplace($height, '&#8243;', 'in')
	if IsArray($img) Then
		InetGet('https://img.pokemondb.net/artwork/' & $img[0] & '.jpg', @ScriptDir & "\poke\" & $i & '\' & $img[0] & '.jpg')
		$file = FileOpen(@ScriptDir & "\poke\" & $i & "\info.lua", 2)
		if not IsArray($t2) Then
			Local $t2[1]
			$t2[0] = ""
		EndIf
		FileWrite($file, 'name="' & $name[0] & '"' & @CRLF & 'dextext="' & $text & '"' & @CRLF & 'type1="' & $t1[0] & '"' & @CRLF & 'type2="' & $t2[0] & '"' & @CRLF & 'height="' & $height & '"' & @CRLF & 'weight="' & $weight[0] & '"' & @CRLF & 'kind="' & StringReplace($kind[0], 'Ã©m', 'em') & '"')
		FileClose($file)
		ConsoleWrite('[' & $i & '] Saved. (' & $img[0] & '.jpg)' & @CRLF)
	EndIf
	sleep(random(500, 900, 1))
Next
