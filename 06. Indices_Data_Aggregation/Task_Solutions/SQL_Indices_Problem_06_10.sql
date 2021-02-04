-- 06. Deposits Sum for Ollivander Family

SELECT [DepositGroup], SUM([DepositAmount]) AS TotalSum
	FROM [WizzardDeposits]
	GROUP BY [DepositGroup], [MagicWandCreator]
	HAVING [MagicWandCreator] = 'Ollivander family'

-- 07. Deposits Filter

SELECT *
	FROM 
		(
		SELECT [DepositGroup], SUM([DepositAmount]) AS TotalSum
			FROM [WizzardDeposits]
			GROUP BY [DepositGroup], [MagicWandCreator]
			HAVING [MagicWandCreator] = 'Ollivander family'
		)
	AS TempTable
	WHERE TempTable.TotalSum < 150000
	ORDER BY TotalSum DESC

SELECT [DepositGroup], SUM([DepositAmount]) AS TotalSum
	FROM [WizzardDeposits]
	WHERE [MagicWandCreator] = 'Ollivander family'
	GROUP BY [DepositGroup], [MagicWandCreator]
	HAVING SUM([DepositAmount]) < 150000
	ORDER BY TotalSum DESC

-- 08. Deposit Charge

SELECT [DepositGroup], [MagicWandCreator], MIN([DepositCharge]) AS MinDepositCharge
	FROM [WizzardDeposits]
	GROUP BY [DepositGroup], [MagicWandCreator]
	ORDER BY [MagicWandCreator], [DepositGroup]
