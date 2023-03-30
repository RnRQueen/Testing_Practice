--Слияние всех таблиц
SELECT * FROM Customer cs
JOIN Contract ct ON ct.customer_id = cs.id
JOIN Executor ex ON ct.id = ex.contract_id
JOIN Employees emp ON ex.tab_no = emp.id
JOIN Department dp ON emp.department_id = dp.id



--1.Найти информацию о всех контрактах, связанных с сотрудниками департамента «Logistic». Вывести: contract_id, employee_name

SELECT ct.id AS contract_id, emp.name AS employee_name 
FROM Customer cs
JOIN Contract ct ON ct.customer_id = cs.id
JOIN Executor ex ON ct.id = ex.contract_id
JOIN Employees emp ON ex.tab_no = emp.id
JOIN Department dp ON emp.department_id = dp.id
WHERE dp.name = 'Logistic'
ORDER BY 1
ASC

--2.Найти среднюю стоимость контрактов, заключенных сотрудников Ivan Ivanov. Вывести: среднее значение amount

SELECT ROUND(AVG(ct.amount),2) AS avg_amount FROM Customer cs
JOIN Contract ct ON ct.customer_id = cs.id
JOIN Executor ex ON ct.id = ex.contract_id
JOIN Employees emp ON ex.tab_no = emp.id
WHERE emp.name = 'Ivan Ivanov'

--3.Найти самую часто встречающуюся локации среди всех заказчиков. Вывести: location, count

SELECT location, COUNT(location) AS count FROM Customer
GROUP BY location 
ORDER BY 2
DESC
LIMIT 1

--4.Найти контракты одинаковой стоимости. Вывести count, amount

SELECT COUNT(amount), amount FROM Contract
GROUP BY amount
HAVING COUNT(amount) > 1
ORDER BY 2

--5.Найти заказчика с наименьшей средней стоимостью контрактов. Вывести customer_name, среднее значение amount

SELECT cs.customer_name, ROUND(AVG(ct.amount),2) AS avg_amount FROM Customer cs
JOIN Contract ct ON ct.customer_id = cs.id
GROUP BY cs.customer_name
HAVING ROUND(AVG(ct.amount),2) = (SELECT ROUND(AVG(ct.amount),2) FROM Contract
                        GROUP BY cs.customer_name
                        ORDER BY 1
                        ASC
                        LIMIT 1)
ORDER BY 2
ASC
LIMIT 1

--6.Найти отдел, заключивший контрактов на наибольшую сумму. Вывести: department_name, sum

SELECT dp.name AS department_name, SUM(ct.amount) AS sum FROM  Contract ct
JOIN Executor ex ON ct.id = ex.contract_id
JOIN Employees emp ON ex.tab_no = emp.id
JOIN Department dp ON emp.department_id = dp.id
GROUP BY dp.name
HAVING SUM(ct.amount) = (SELECT SUM(ct.amount) FROM  Contract ct
                        JOIN Executor ex ON ct.id = ex.contract_id
                        JOIN Employees emp ON ex.tab_no = emp.id
                        JOIN Department dp ON emp.department_id = dp.id
                        GROUP BY dp.name
                        ORDER BY 1
                        DESC
                        LIMIT 1)
