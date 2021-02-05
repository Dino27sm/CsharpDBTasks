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
