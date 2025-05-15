; ArrayToString by just me
; https://www.autohotkey.com/boards/viewtopic.php?p=228529#p228529
; Edited by NABN00B

; Function:                 ArrayToString(array [, separator] )
;                           Converts the specified array into a string by concatenating every element.
; Parameters:
;   array               -   The array to be converted to string.
;   [separator]         -   The string to be concatenated between two elements in order to separate them in the
;                           result string. Defaults to an empty string.
; Return values:
;   string              -   The list of concatenated elements from the input array, separated by the characters
;                           specified by the separator parameter.
;   "" (empty string)   -   The result of the conversion in case of an empty or invalid array.

ArrayToString(array, separator := "")
{
	str := ""
	for index, value in array
	   str .= separator . value
	str := LTrim(str, separator)
	return str
}
