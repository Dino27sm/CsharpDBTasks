-- 06. Find Towns Starting With

SELECT *
	FROM Towns
	WHERE LEFT([Name], 1) = 'M' OR LEFT([Name], 1) = 'K' 
		OR LEFT([Name], 1) = 'B' OR LEFT([Name], 1) = 'E'
	ORDER BY [Name] ASC

SELECT *
	FROM Towns
	WHERE [Name] LIKE '[MKBE]%'
	ORDER BY [Name] ASC

-- 07. Find Towns Not Starting With

SELECT *
	FROM Towns
	WHERE NOT (LEFT([Name], 1) = 'R' OR LEFT([Name], 1) = 'B' OR LEFT([Name], 1) = 'D')
	ORDER BY [Name] ASC
