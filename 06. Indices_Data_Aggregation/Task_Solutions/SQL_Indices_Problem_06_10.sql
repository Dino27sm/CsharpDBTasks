-- 06. Deposits Sum for Ollivander Family

SELECT [DepositGroup], SUM([DepositAmount]) AS TotalSum
	FROM [WizzardDeposits]
	GROUP BY [DepositGroup], [MagicWandCreator]
	HAVING [MagicWandCreator] = 'Ollivander family'

