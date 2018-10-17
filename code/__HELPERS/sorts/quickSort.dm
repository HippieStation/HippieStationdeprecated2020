/proc/quickSort(L[], left = 1, right = 0) 
	var/i = left
	var/j = right
	var/tmp = 0
	var/pivot = L[((left + right) / 2)
	
	/* partition */
	while (i <= j) 
		while (L[i] < pivot)
			i++
		while (L[j] > pivot)
			j--
		if (i <= j) 
			tmp = L[i]
			L[i] = L[j]
			L[j] = tmp
			i++
			j--

	/* recursion */
		if (left < j)
			quickSort(L, left, j)
		if (i < right)
			quickSort(L, i, right)
	return L
