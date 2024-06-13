USE `company`;

-- Número de empregados por departamento e localidade
SELECT 
    d.Dname AS Department_Name,
    dl.Dlocation AS Department_Location,
    COUNT(e.Ssn) AS Number_of_Employees
FROM 
    departament d
JOIN 
    dept_locations dl ON d.Dnumber = dl.Dnumber
LEFT JOIN 
    employee e ON d.Dnumber = e.Dno
GROUP BY 
    d.Dname, dl.Dlocation;

-- Lista de departamentos e seus gerentes 

SELECT 
    d.Dname AS Department_Name,
    e.Ssn AS Super_Ssn,
    e.Fname AS Manager_First_Name,
    e.Lname AS Manager_Last_Name
FROM 
    departament d
LEFT JOIN 
    employee e ON d.Mgr_ssn = e.Ssn;
    
-- Projetos com maior número de empregados

SELECT 
    p.Pname AS Project_Name,
    p.Pnumber AS Project_Number,
    COUNT(w.Essn) AS Number_of_Employees
FROM 
    project p
JOIN 
    works_on w ON p.Pnumber = w.Pno
GROUP BY 
    p.Pname, p.Pnumber
ORDER BY 
    Number_of_Employees DESC
LIMIT 1;

-- Lista de projetos, departamentos e gerentes

SELECT 
    p.Pname AS Project_Name,
    p.Pnumber AS Project_Number,
    d.Dname AS Department_Name,
    e.Ssn AS Manager_Ssn,
    e.Fname AS Manager_First_Name,
    e.Lname AS Manager_Last_Name
FROM 
    project p
JOIN 
    departament d ON p.Dnum = d.Dnumber
LEFT JOIN 
    employee e ON d.Mgr_ssn = e.Ssn;
    
-- Quais empregados possuem dependentes e se são gerentes
SELECT 
    e.Ssn AS Employee_Ssn,
    e.Fname AS Employee_First_Name,
    e.Lname AS Employee_Last_Name,
    CASE 
        WHEN d.Mgr_ssn IS NOT NULL THEN 'Yes'
        ELSE 'No'
    END AS Is_Manager
FROM 
    employee e
JOIN 
    dependent dp ON e.Ssn = dp.Essn
LEFT JOIN 
    departament d ON e.Ssn = d.Mgr_ssn
GROUP BY 
    e.Ssn, e.Fname, e.Lname, Is_Manager;
    
-- Triggers de remoção

CREATE TABLE IF NOT EXISTS employee_deletion_log (
    id INT AUTO_INCREMENT PRIMARY KEY,
    ssn CHAR(9) NOT NULL,
    fname VARCHAR(15),
    lname VARCHAR(15),
    deletion_time DATETIME);
    
CREATE TRIGGER before_employee_delete
BEFORE DELETE ON employee
FOR EACH ROW
BEGIN
    INSERT INTO employee_deletion_log (ssn, fname, lname, deletion_time)
    VALUES (OLD.Ssn, OLD.Fname, OLD.Lname, NOW());
END;

-- Triggers de Atualizacao

CREATE TABLE IF NOT EXISTS employee_salary_log (
    id INT AUTO_INCREMENT PRIMARY KEY,
    ssn CHAR(9) NOT NULL,
    old_salary DECIMAL(10,2),
    new_salary DECIMAL(10,2),
    update_time DATETIME
);

CREATE TRIGGER before_employee_update
BEFORE UPDATE ON employee
FOR EACH ROW
BEGIN
    IF OLD.Salary != NEW.Salary THEN
        INSERT INTO employee_salary_log (ssn, old_salary, new_salary, update_time)
        VALUES (OLD.Ssn, OLD.Salary, NEW.Salary, NOW());
    END IF;
END;





    
    
    



    
    