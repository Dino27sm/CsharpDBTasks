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

-- 09. Age Groups

SELECT AgeGroup, COUNT(AgeGroup) AS WizardCount
	FROM(SELECT 
			CASE
				WHEN Age BETWEEN 0 AND 10 THEN '[0-10]'
				WHEN Age BETWEEN 11 AND 20 THEN '[11-20]'
				WHEN Age BETWEEN 21 AND 30 THEN '[21-30]'
				WHEN Age BETWEEN 31 AND 40 THEN '[31-40]'
				WHEN Age BETWEEN 41 AND 50 THEN '[41-50]'
				WHEN Age BETWEEN 51 AND 60 THEN '[51-60]'
				WHEN Age > 60 THEN '[61+]'
			END AS AgeGroup
			FROM [WizzardDeposits]
		 )
		 AS TempTable
	GROUP BY AgeGroup

-- 10. First Letter

SELECT DISTINCT LEFT(FirstName, 1) AS FirstLetter
	FROM [WizzardDeposits]
	WHERE [DepositGroup] = 'Troll Chest'
	ORDER BY FirstLetter
------------------------------

SELECT DISTINCT LEFT(FirstName, 1) AS FirstLetter
	FROM [WizzardDeposits]
	WHERE [DepositGroup] = 'Troll Chest'
-------------------------------

SELECT LEFT(FirstName, 1) AS FirstLetter
	FROM [WizzardDeposits]
	WHERE [DepositGroup] = 'Troll Chest'
	GROUP BY LEFT(FirstName, 1)
--------------------------------
