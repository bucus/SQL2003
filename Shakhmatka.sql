#Шахматка - ведомость, включает обороты каждого счёта бухгалтерского учёта

SELECT	bal_receiver,
	bal_payer,
	STR(SUM(summ),14,2) as ob_kredit
	FROM ##month
	GROUP BY bal_receiver, bal_payer
	ORDER BY bal_receiver, bal_payer
  
