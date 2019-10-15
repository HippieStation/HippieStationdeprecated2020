/atom/GetAllContents(var/T)
	. = ..()
	// Include items in the butt as part of "GetAllContents"
	if (istype(src, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = src
		var/obj/item/organ/butt/B = H.getorgan(/obj/item/organ/butt)

		if (B)
			. += B.contents

/proc/urlbase64(str)
	var/_base64AlphaStr = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_"
	var/buffer, char, len = length(str)
	for(var/i in 1 to len step 3)
		buffer = text2ascii(str, i) << 4
		if(len-i > 0)
			char = text2ascii(str, i+1)
			buffer |= char >> 4
			. += ascii2text(text2ascii(_base64AlphaStr, 1 + (buffer >> 6))) + \
				ascii2text(text2ascii(_base64AlphaStr, 1 + (buffer & 0x3F)))
			buffer = (char & 0xF) << 8
			if(len-i > 1)
				buffer |= text2ascii(str, i+2)
				. += ascii2text(text2ascii(_base64AlphaStr, 1 + (buffer >> 6))) + \
					ascii2text(text2ascii(_base64AlphaStr, 1 + (buffer & 0x3F)))
			else . += ascii2text(text2ascii(_base64AlphaStr, 1 + (buffer >> 6)))// + "="
		else . += ascii2text(text2ascii(_base64AlphaStr, 1 + (buffer >> 6))) + \
			ascii2text(text2ascii(_base64AlphaStr, 1 + (buffer & 0x3F)))// + \
			//"=="

/proc/base64bin(string)
	. = list()
	var/list/base64=list(
		"A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z",
		"a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z",
		"0","1","2","3","4","5","6","7","8","9","-","_")
	for(var/i=0;i<length(string);i+=4)
		var/block=copytext(string,i+1,i+5)
		var/binary_text

		for(var/j=1;j<=length(block);j++)
			binary_text+=copytext(dec2bin(base64.Find(copytext(block,j,j+1))-1),3)

		for(var/j=0;j<length(binary_text);j+=8)
			.+=bin2dec(copytext(binary_text,j+1,j+9))

/proc/bin2dec(t)
	t=text2num(t)
	for(var/i=1;t;i+=i)
		if(t%2>0)
			.+=i
		t=round(t/10)

/proc/dec2bin(n)
	for(var/i=128;i>=1;i/=2)
		if(n/i>=1)
			.+="1"
			n-=i
		else .+="0"

/proc/list_avg(list/L)
	. = 0
	for(var/num in L)
		. += num
	. /= length(L)
	LAZYCLEARLIST(L)
