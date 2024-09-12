SELECT * FROM Area
;

SELECT * FROM Asignaturas
;

SELECT * FROM Encargado
;

SELECT * FROM Estudiantes
;

SELECT * FROM Profesiones
;

SELECT * FROM Staff
;

--TAREAS--

--Indicar cuántos cursos y carreras  tiene el área de Data. Renombrar la nueva columna como cant_asignaturas. 
--Keywords: Tipo, Área, Asignaturas.

SELECT * FROM Area;
SELECT * FROM Asignaturas;

SELECT 
Tipo,
COUNT(AsignaturasID) AS cant_asignaturas
FROM Asignaturas
WHERE Area=5
GROUP BY Tipo
ORDER BY cant_asignaturas DESC 
; 
---------------------------------------------------------------------------------------------------------------------
--Se requiere saber cual es el nombre, el documento de identidad y el teléfono 
--de los estudiantes que son profesionales en agronomía 
--y que nacieron entre el año 1970 y el año 2000. 
--Keywords: Estudiantes, Profesión, Fecha de Nacimiento.

SELECT * FROM Estudiantes;
SELECT * FROM Profesiones;

SELECT 
Nombre,
Documento,
Telefono
FROM Estudiantes
WHERE Profesion=6              --RANGO--
AND YEAR([Fecha de Nacimiento]) BETWEEN 1970 AND 2000
;
---------------------------------------------------------------------------------------------------------------------
--Se requiere un listado de los docentes que ingresaron en el año 2021 
--y concatenar los campos nombre y apellido. 
--El resultado debe utilizar un separador: guión (-). Ejemplo: Elba-Jimenez. 
--Renombrar la nueva columna como Nombres_Apellidos. 
--Los resultados de la nueva columna deben estar en mayúsculas. 
--Keywords: Staff, Fecha Ingreso, Nombre, Apellido.

SELECT
UPPER(CONCAT(Nombre,'-',Apellido)) AS Nombres_Apellidos
FROM Staff
WHERE YEAR([Fecha Ingreso]) = 2021
;
----------------------------------------------------------------------------------------------------------------------
--Indicar la cantidad de encargados de docentes y de tutores. 
--Renombrar la columna como CantEncargados. 
--Quitar la palabra ”Encargado ”en cada uno de los registros. 
--Renombrar la columna como NuevoTipo. 
--Keywords: Encargado, tipo, Encargado_ID.

SELECT * FROM Encargado;

SELECT 
REPLACE(Tipo,'Encargado','') AS NuevoTipo,
COUNT(Encargado_ID) AS CantEncargados
FROM Encargado
GROUP BY Tipo
ORDER BY CantEncargados DESC
;
---------------------------------------------------------------------------------------------------------------------
--Indicar cuál es el precio promedio de las carreras y los cursos por jornada. 
--Renombrar la nueva columna como Promedio. 
--Ordenar los promedios de Mayor a menor 
--Keywords: Tipo, Jornada, Asignaturas. 

SELECT * FROM Asignaturas;

SELECT 
Tipo,
Jornada,
AVG(Costo) AS Promedio
FROM Asignaturas
GROUP BY 
Tipo,
Jornada
ORDER BY Promedio DESC
;
--------------------------------------------------------------------------------------------------------------------
--Se requiere calcular la edad de los estudiantes en una nueva columna. 
--Renombrar a la nueva columna Edad. 
--Filtrar solo los que son mayores de 18 años. 
--Ordenar de Menor a Mayor 
--Keywords: Fecha de Nacimiento, Estudiantes.

SELECT * FROM Estudiantes;

ALTER TABLE Estudiantes 
ADD Edad INT
;

UPDATE Estudiantes SET 
Edad = DATEDIFF(Year,[Fecha de Nacimiento], GETDATE()) 
WHERE EstudiantesID IS NOT NULL
;

SELECT * FROM Estudiantes
ORDER BY Edad ASC
;

--SELECT 
--EstudiantesID,
--DATEDIFF(Year,[Fecha de Nacimiento], GETDATE()) AS Edad
--FROM 
--Estudiantes
--WHERE 
--DATEDIFF(Year,[Fecha de Nacimiento], GETDATE()) > 18
--ORDER BY Edad ASC
--;

------------------------------------------------------------------------------------------------------------------
--Se requiere saber el Nombre,el correo, la camada y la fecha de ingreso de personas del staff 
--que contienen correo .edu y su DocenteID se mayor o igual que 100 
--Keywords: Staff, correo, DocentesID

SELECT 
Nombre,
Correo,
Camada,
[Fecha Ingreso]
FROM Staff
WHERE RIGHT(Correo,4) = '.edu'
AND DocentesID >= 100
ORDER BY DocentesID ASC
;
-----------------------------------------------------------------------------------------------------------------
--Se requiere conocer el documento, el domicilio, el código postal y el nombre 
--de los primeros estudiantes que se registraron en la plataforma. 
--Keywords: Documento, Estudiantes, Fecha Ingreso.
SELECT TOP 3
Documento,
Domicilio,
[Codigo Postal],
Nombre 
FROM Estudiantes
ORDER BY [Fecha Ingreso] ASC
;
----------------------------------------------------------------------------------------------------------------
--Indicar el nombre, apellido y documento de identidad de los docentes y tutores que tienen asignaturas “UX” . 
--Keywords: Staff, Asignaturas, Nombre, Apellido.
SELECT * FROM Staff
--WHERE Nombre = 'Denise'
;
SELECT * FROM Asignaturas
--WHERE AsignaturasID = 4 
;

SELECT 
Nombre,
Apellido,
Documento
FROM Staff
WHERE Asignatura BETWEEN 1 AND 16
;

-----------------------------------------------------------------------------------------------------------------
--Se desea calcular el 25% de aumento para las asignaturas del área de marketing de la jornada mañana se deben traer todos los campos, 
--mas el de los cálculos correspondientes el porcentaje y el Nuevo costo debe estar en decimal con 3 digitos. 
--Renombrar el calculo del porcentaje con el nombre porcentaje y la suma del costo mas el porcentaje por NuevoCosto. 
--Keywords: Asignaturas, Costo, Área, Jornada, Nombre

SELECT 
*, 
CAST((Costo * 0.25) AS DECIMAL(7,3) ) AS PORCENTAJE,
CAST((Costo * 1.25) AS DECIMAL(7,3) ) AS NuevoCosto
FROM Asignaturas
WHERE Area = (SELECT AreaID 
                FROM Area 
                WHERE Nombre LIKE ('%Marketing%')) 
AND Jornada = 'Manana'
;
--WHERE Area = 2 AND Jornada = 'Manana'

--------------------------------------------------------------------------------------------------------------------
--Indicar por jornada la cantidad de docentes que dictan y sumar los costos. 
--Esta información solo se desea visualizar para las asignaturas de desarrollo web. 
--El resultado debe contener todos los valores registrados en la primera tabla, 
--Renombrar la columna del cálculo de la cantidad de docentes como cant_docentes 
--y la columna de la suma de los costos como suma_total. 
--Keywords: Asignaturas,Staff, DocentesID, Jornada, Nombre, costo.
SELECT * FROM Asignaturas;
SELECT * FROM Staff;

SELECT Asignaturas.Costo, Staff.Asignatura 
FROM Asignaturas
RIGHT JOIN Staff
ON Asignaturas.AsignaturasID = Staff.Asignatura 
WHERE AsignaturasID BETWEEN 57 AND 60
;

--------------------------------------------------------------------------------------------------------------------
--Se requiere saber el id del encargado, el nombre, el apellido 
--y cuántos son los docentes que tiene asignados cada encargado. 
--Luego filtrar los encargados que tienen como resultado 0 ya que son los encargados que NO tienen asignado un docente. 
--Renombrar el campo de la operación como Cant_Docentes. 
--Keywords: Docentes_id, Encargado, Staff, Nombre, Apellido,Encargado_ID.

SELECT * FROM Encargado;
SELECT * FROM Staff;

SELECT Encargado.Apellido, 
Encargado.Nombre, 
Encargado.Encargado_ID, 
COUNT(Staff.DocentesID) AS Cant_Docentes
FROM Encargado
LEFT JOIN Staff
ON Encargado.Encargado_ID = Staff.Encargado
GROUP BY Encargado.Encargado_ID, Encargado.Nombre, Encargado.Apellido
HAVING COUNT(Staff.DocentesID) > 0
ORDER BY Cant_Docentes ASC;

--------------------------------------------------------------------------------------------------------------------
--Se requiere saber todos los datos 
--de asignaturas que no tienen un docente asignado. 
--El modelo de la consulta debe partir desde la tabla docentes. 
--Keywords: Staff, Encargado, Asignaturas, costo, Area.

SELECT * FROM Staff;
SELECT * FROM Encargado;
SELECT * FROM Asignaturas;

SELECT 
Asignaturas.*
FROM Asignaturas
LEFT JOIN Staff
ON Asignaturas.AsignaturasID = Staff.Asignatura
WHERE Staff.DocentesID IS NULL


--------------------------------------------------------------------------------------------------------------------
--Se quiere conocer la siguiente información de los docentes. 
--El nombre completo concatenar el nombre y el apellido. Renombrar NombresCompletos, 
--el documento, 
--hacer un cálculo para conocer los meses de ingreso. Renombrar meses_ingreso, 
--el nombre del encargado. Renombrar NombreEncargado, el tefelono del encargado. Renombrar TelefonoEncargado, 
--el nombre del curso o carrera, la jornada y el nombre del área. 
--Solo se desean visualizar los que llevan más de 40 meses. 
--Ordenar los meses de ingreso de mayor a menor.  
--Keywords: Encargo,Area,Staff,jornada, fecha ingreso.
SELECT*FROM Staff;
SELECT*FROM Asignaturas;
SELECT*FROM Encargado
SELECT*FROM Area

SELECT 
CONCAT(Staff.Nombre,' ', Staff.Apellido) AS NOMBRESCOMPLETOS,
Staff.Documento,
DATEDIFF(MONTH, Staff.[Fecha Ingreso], GETDATE()) AS meses_ingreso,
Encargado.Nombre AS NombreEncargado,
Encargado.Telefono AS TelefonoEncargado,
Asignaturas.Nombre,
Asignaturas.Jornada,
Area.Nombre
FROM Staff
JOIN Encargado
    ON Staff.Encargado = Encargado.Encargado_ID
JOIN Asignaturas
    ON Staff.Asignatura = Asignaturas.AsignaturasID
JOIN Area
    ON Asignaturas.Area = Area.AreaID
WHERE DATEDIFF(MONTH, Staff.[Fecha Ingreso], GETDATE()) > 40
ORDER BY meses_ingreso DESC
;

--------------------------------------------------------------------------------------------------------------------
--Se requiere un listado unificado con nombre, apellido, documento y una marca indicando a que base corresponde. 
--Renombrar como Marca 
--Keywords: Encargo,Staff,Estudiantes,

SELECT * FROM Encargado;
SELECT * FROM Staff;
SELECT * FROM Estudiantes;

SELECT Nombre, Apellido, Documento, 'ENCARGADO' AS MARCA
FROM Encargado
UNION SELECT Nombre, Apellido, Documento, 'DOCENTE' AS MARCA
FROM Staff
UNION SELECT Nombre, Apellido, Documento, 'ESTUDIANTE' AS MARCA
FROM Estudiantes
