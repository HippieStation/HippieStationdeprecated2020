/proc/quickSort(arr[], left, right) 
      var/i = left
      var/j = right
      var/tmp = 0
      var/pivot = arr[((left + right) / 2)]
 
      /* partition */
      while (i <= j) 
            while (arr[i] < pivot)
                  i++
            while (arr[j] > pivot)
                  j--
            if (i <= j) 
                  tmp = arr[i]
                  arr[i] = arr[j]
                  arr[j] = tmp
                  i++
                  j--

      /* recursion */
      if (left < j)
            quickSort(arr, left, j)
      if (i < right)
            quickSort(arr, i, right)
