/*Разработочные данные для составления отчета по драгметаллам*/
/*Выборка по счету 20302/01 - отчет по драгметаллам*/
SET NOCOUNT ON

DECLARE @s_account CHAR(25)
SELECT @s_account = "20302%"

/*по рублевому эквиваленту*/
SELECT "Остаток по счету на начало периода в рублевом эквиваленте по бал. счету №"+@s_account
SELECT	SUBSTRING(balance1,1,8) as "Бал счет",
	SUBSTRING(code_currency,1,3) as "Код вал",
	SUBSTRING(account,1,20) as "Лицевой счет",
	STR(rest,14,2) as "Остаток",
	CONVERT(CHAR(12),date_carry,106) as "Дата посл пров",
	(SELECT ac.nameaccount FROM account ac WHERE ac.account=##saldo_beg.account) as "Имя счета"
	FROM ##saldo_beg
	WHERE balance1 LIKE RTRIM(LTRIM(@s_account)) AND code_currency!="810" AND rest!=0
	ORDER BY "Код вал"


SELECT "Операции по дебету счета (дебетовый оборот) в рублевом эквиваленте по бал. счету №"+@s_account
SELECT 
	SUBSTRING(real_payer,6,3) as "Код в",
	SUBSTRING(real_payer,1,20) as "С дебета счета",
	SUBSTRING(real_receiver,1,20) as "В кредит счета",
	STR(SUM(summ),14,2) as "дебетовый об",
	(SELECT nameaccount FROM account WHERE account=real_receiver) as "Имя счета - корреспондента"
FROM ##month
WHERE real_payer IN (SELECT DISTINCT real_payer FROM ##month WHERE bal_payer LIKE RTRIM(LTRIM(@s_account)) )
	AND code_currency!="810"
GROUP BY real_payer, real_receiver WITH ROLLUP

SELECT "Операции по кредиту счета (кредитовый оборот) в рублевом эквиваленте по бал. счету №"+@s_account
SELECT 
	SUBSTRING(real_payer,6,3) as "Код в",
	SUBSTRING(real_receiver,1,20) as "С кредита счета",
	SUBSTRING(real_payer,1,20) as "В дебет счета",
	STR(SUM(summ),14,2) as "кредитовый об",
	(SELECT nameaccount FROM account WHERE account=real_payer) as "Имя счета - корреспондента"
FROM ##month
WHERE real_receiver IN (SELECT DISTINCT real_receiver FROM ##month WHERE bal_receiver LIKE RTRIM(LTRIM(@s_account)) )
	/*AND code_currency!="810"*/
GROUP BY real_receiver, real_payer WITH ROLLUP

SELECT "Остаток по счету на конец периода в рублевом эквиваленте по бал. счету №"+@s_account
SELECT	SUBSTRING(balance1,1,8) as "Бал счет",
	SUBSTRING(code_currency,1,3) as "Код вал",
	SUBSTRING(account,1,20) as "Лицевой счет",
	STR(rest,14,2) as "Остаток",
	CONVERT(CHAR(12),date_carry,106) as "Дата посл пров",
	(SELECT ac.nameaccount FROM account ac WHERE ac.account=##saldo_end.account) as "Имя счета"
	FROM ##saldo_end
	WHERE balance1 LIKE RTRIM(LTRIM(@s_account)) AND code_currency!="810" AND rest!=0
	ORDER BY "Код вал"

/*по валютному эквиваленту*/
SELECT "Остаток по счету на начало периода в инвалюте(драгметаллах) по бал. счету №"+@s_account
SELECT	SUBSTRING(account,6,3) as "Код в",
	SUBSTRING(balance1,1,8) as "Бал счет",
	SUBSTRING(account,1,20) as "Лицевой счет",
	STR(rest,14,2) as "Остаток",
	CONVERT(CHAR(12),date_carry,106) as "Дата посл пров",
	(SELECT ac.nameaccount FROM account$ ac WHERE ac.account=##saldo_beg$.account) as "Имя счета"
	FROM ##saldo_beg$ WHERE balance1 LIKE RTRIM(LTRIM(@s_account)) AND rest!=0
	ORDER BY "Код вал"

SELECT "Операции по дебету счета (дебетовый оборот) в инвалюте(драгметаллах) по бал. счету №"+@s_account
SELECT
	SUBSTRING(real_payer,6,3) as "Код в", 
	SUBSTRING(real_payer,1,20)  as "С дебета счета",
	SUBSTRING(real_receiver,1,20) as "В кредит счета",
	STR(SUM(summ),14,2) as "дебетовый об",
	(SELECT nameaccount FROM account$ WHERE account=real_receiver) as "Имя счета - корреспондента"
FROM ##month$
WHERE real_payer IN (SELECT DISTINCT real_payer FROM ##month$ WHERE bal_payer LIKE RTRIM(LTRIM(@s_account)) )
GROUP BY real_payer, real_receiver WITH ROLLUP

SELECT "Операции по кредиту счета (кредитовый оборот) в инвалюте(драгметаллах) по бал. счету №"+@s_account
SELECT 
	SUBSTRING(real_payer,6,3) as "Код в",
	SUBSTRING(real_receiver,1,20) as "С кредита счета",
	SUBSTRING(real_payer,1,20) as "В дебет счета",
	STR(SUM(summ),14,2) as "кредитовый об",
	(SELECT nameaccount FROM account$ WHERE account=real_payer) as "Имя счета - корреспондента"
FROM ##month$
WHERE real_receiver IN (SELECT DISTINCT real_receiver FROM ##month$ WHERE bal_receiver LIKE RTRIM(LTRIM(@s_account)) )
GROUP BY real_receiver, real_payer WITH ROLLUP
SELECT "Остаток по счету на конец периода в инвалюте(драгметаллах) по бал. счету №"+@s_account
SELECT	SUBSTRING(account,6,3) as "Код в",
	SUBSTRING(balance1,1,8) as "Бал счет",
	SUBSTRING(account,1,20) as "Лицевой счет",
	STR(rest,14,2) as "Остаток",
	CONVERT(CHAR(12),date_carry,106) as "Дата посл пров",
	(SELECT ac.nameaccount FROM account$ ac WHERE ac.account=##saldo_end$.account) as "Имя счета"
	FROM ##saldo_end$ WHERE balance1 LIKE RTRIM(LTRIM(@s_account)) AND rest!=0
	ORDER BY "Код вал"

SELECT "Операции по покупке (дебетовый оборот) в инвалюте(драгметаллах) по бал. счету №"+@s_account
SELECT 
	SUBSTRING(real_payer,1,20)  as "С дебета счета",
	SUBSTRING(real_receiver,1,20) as "В кредит счета",
	STR(summ,14,2) as "кредитовый об",
	ground as "Основание документа"
FROM ##month$
WHERE real_payer IN (SELECT DISTINCT real_payer FROM ##month$ WHERE bal_payer LIKE RTRIM(LTRIM(@s_account)) )

SELECT "Операции по продаже (кредитовый оборот) в инвалюте(драгметаллах) по бал. счету №"+@s_account
SELECT 
	SUBSTRING(real_receiver,1,20) as "С кредита счета",
	SUBSTRING(real_payer,1,20) as "В дебет счета",
	STR(summ,14,2) as "кредитовый об",
	ground as "Основание документа"
FROM ##month$
WHERE real_receiver IN (SELECT DISTINCT real_receiver FROM ##month$ WHERE bal_receiver LIKE RTRIM(LTRIM(@s_account)) )
