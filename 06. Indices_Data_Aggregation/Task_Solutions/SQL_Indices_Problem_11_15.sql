-- 11. Average Interest

SELECT DepositGroup, IsDepositExpired, AVG([DepositInterest])
	FROM [WizzardDeposits]
	WHERE [DepositStartDate] > '01/01/1985'
	GROUP BY DepositGroup, IsDepositExpired
	ORDER BY DepositGroup DESC, IsDepositExpired

-- 12. Rich Wizard, Poor Wizard

SELECT SUM(host.DepositAmount - guest.DepositAmount) AS SumDifference
	FROM WizzardDeposits AS host
	JOIN WizzardDeposits AS guest ON host.Id + 1 = guest.Id

-----------------------------------Another solution using LEAD--------------------------------
SELECT SUM(DepositAmount - SecondDeposit) AS SumDifference
	FROM(SELECT DepositAmount, LEAD(DepositAmount, 1) OVER(ORDER BY Id) AS SecondDeposit
		FROM WizzardDeposits) AS TempTable

-- 13. Departments Total Salaries

SELECT [DepartmentID], SUM([Salary]) AS TotalSalary
	FROM [Employees]
	GROUP BY [DepartmentID]
	ORDER BY [DepartmentID]

-- 14. Employees Minimum Salaries

SELECT DepartmentID, MIN(Salary) AS MinimumSalary
	FROM [Employees]
	WHERE [HireDate] > '01/01/2000'
	GROUP BY DepartmentID
	HAVING DepartmentID IN (2, 5, 7)

-- 15. Employees Average Salaries

SELECT * INTO TempTable
	FROM [Employees]
	WHERE Salary > 30000

	