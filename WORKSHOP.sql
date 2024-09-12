--ANALISIS DE NEGOCIOS NIVEL OPERATIVO--
--Análisis de docentes por camada/ comisión: 

--Número de documento de identidad, nombre del docente y camada, 
--para identificar la camada mayor y la menor según el número de la  camada. 

--Número de documento de identidad, nombre de docente y camada 
--para identificar la camada con fecha de ingreso ,Mayo 2021. 

--Agregar un campo indicador que informe cuáles son los registros 
--”mayor o menor” y los que son “mayo 2021” 
--y ordenar el listado de menor a mayor por camada.
SELECT * FROM Staff;

SELECT 
Documento,
Nombre,
Camada,
'CAMADA MAYOR' AS MARCA
FROM Staff
WHERE Camada = (SELECT MAX(Camada)
                    FROM Staff)
UNION
SELECT 
Documento,
Nombre,
Camada,
'CAMADA MENOR' AS MARCA
FROM Staff
WHERE Camada = (SELECT MIN(Camada)
                    FROM Staff)
UNION
SELECT 
Documento,
Nombre,
Camada,
'MAYO 2021' AS MARCA
FROM Staff
WHERE YEAR([Fecha Ingreso]) = 2021 
        AND MONTH([Fecha Ingreso]) = 05
ORDER BY Camada ASC
;

----------------------------------------------------------------------------------------------------------------------------------------
--Análisis diario de estudiantes: 
--Por medio de la fecha de ingreso de los estudiantes
-- identificar: cantidad total de estudiantes.

--Mostrar los periodos de tiempo separados por 
--año, mes y día, y presentar la información ordenada 
--por la fecha que más ingresaron estudiantes.
SELECT * FROM Estudiantes;

SELECT 
YEAR([Fecha Ingreso]) AS AÑO,
MONTH([Fecha Ingreso]) AS MES,
DAY([Fecha Ingreso]) AS DIA,
COUNT([Fecha Ingreso]) AS CANTIDAD_ESTUDIANTES
FROM Estudiantes
GROUP BY
YEAR([Fecha Ingreso]),
MONTH([Fecha Ingreso]),
DAY([Fecha Ingreso])
ORDER BY CANTIDAD_ESTUDIANTES DESC
;

---------------------------------------------------------------------------------------------------------------------------------------
--Análisis de encargados con más docentes a cargo: 
--Identificar el top 10 de los encargados que tiene más docentes a cargo,
--filtrar solo los que tienen a cargo docentes. 
--Ordenar de mayor a menor para poder tener el listado correctamente.

SELECT TOP(10)
       Encargado.Encargado_ID AS ID,
       Encargado.Nombre, 
       Encargado.Apellido,
       COUNT(Staff.DocentesID) AS CANT_DOCENTES
FROM Encargado
JOIN Staff
ON Encargado.Encargado_ID = Staff.Encargado
GROUP BY Encargado.Encargado_ID,
         Encargado.Nombre,
         Encargado.Apellido
ORDER BY CANT_DOCENTES DESC

-----------------------------------------------------------------------------------------------------------------------------------------
--Análisis de profesiones con más estudiantes: 
--Identificar la profesión y la cantidad de estudiantes que ejercen, 
--mostrar el listado solo de las profesiones que tienen más de 5 estudiantes.
--Ordenar de mayor a menor por la profesión que tenga más estudiantes.

SELECT * FROM Estudiantes
SELECT * FROM Profesiones

SELECT TOP(5) Profesiones.Profesiones,
              COUNT(Estudiantes.EstudiantesID) AS CANT_ESTUIDANTES
FROM Profesiones
JOIN Estudiantes
ON Profesiones.ProfesionesID = Estudiantes.Profesion
GROUP BY Profesiones.Profesiones
ORDER BY CANT_ESTUIDANTES DESC

------------------------------------------------------------------------------------------------------------------------------------------

--Análisis de estudiantes por área de educación: 
--Identificar: nombre del área, si la asignatura es carrera o curso 
--, a qué jornada pertenece, cantidad de estudiantes y monto total del costo de la asignatura. 
--Ordenar el informe de mayor a menor por monto de costos total, 
--tener en cuenta los docentes que no tienen asignaturas ni estudiantes asignados, también sumarlos.

SELECT 
        Area.Nombre,
        Asignaturas.Tipo,
        Asignaturas.Jornada,
        Asignaturas.Costo,
       COUNT(Estudiantes.EstudiantesID) AS cantidad_estudiantes,
       SUM(Asignaturas.Costo) AS MontoTotalCostos
FROM Area
LEFT JOIN Asignaturas
ON Area.AreaID = Asignaturas.Area
LEFT JOIN Staff
ON Asignaturas.AsignaturasID = Staff.Asignatura
LEFT JOIN Estudiantes
ON Staff.DocentesID = Estudiantes.Docente
GROUP BY Area.Nombre,
        Asignaturas.Tipo,
        Asignaturas.Jornada,
        Asignaturas.Costo
ORDER BY MontoTotalCostos DESC
;

--------------------------------------------------------------------------------------------------------------------------------------------
--ANALISIS DE NEGOCIO NIVER TACTICO--

--Análisis mensual de estudiantes por área: 
--Identificar para cada área: 
--el año y el mes (concatenados en formato YYYYMM), 
--cantidad de estudiantes y monto total de las asignaturas. 
--Ordenar por mes del más actual al más antiguo y por cantidad de clientes de mayor a menor.

SELECT
Area.Nombre,
CONCAT(YEAR(Estudiantes.[Fecha Ingreso]), RIGHT('0' + CAST(MONTH(Estudiantes.[Fecha Ingreso]) AS VARCHAR(2)), 2)) AS ingreso,
COUNT(Estudiantes.EstudiantesID) AS cantidad_estudiantes,
SUM(Asignaturas.Costo) AS MontoTotalCostos
FROM Area
JOIN 
Asignaturas ON Area.AreaID = Asignaturas.Area
JOIN 
Staff ON Staff.Asignatura = Asignaturas.AsignaturasID
JOIN 
Estudiantes ON Estudiantes.Docente = Staff.DocentesID
GROUP BY 
    Area.Nombre,
    YEAR(Estudiantes.[Fecha Ingreso]),
    MONTH(Estudiantes.[Fecha Ingreso])
ORDER BY     
    ingreso DESC, 
    cantidad_estudiantes DESC;
;

--------------------------------------------------------------------------------------------------------------------------------------------
--Análisis encargado tutores jornada noche: 
--Identificar el nombre del encargado, el documento de identidad,
--el número de la camada (solo el número) 
--y la fecha de ingreso del tutor. 
--Ordenar por camada de forma mayor a menor.

SELECT 
Encargado.Nombre AS NombreEncargado,
Encargado.Documento DocumentoEncargado,
TRIM(REPLACE(Staff.Camada, 'camada', '')) AS NumeroCamada,
Staff.[Fecha Ingreso] AS Ingreso_Tutor
FROM Encargado
JOIN
Staff ON Staff.Encargado = Encargado.Encargado_ID
JOIN 
Asignaturas ON Staff.Asignatura = Asignaturas.AsignaturasID
WHERE Asignaturas.Jornada = 'Noche'
ORDER BY Staff.Camada DESC

-------------------------------------------------------------------------------------------------------------------------------------------
--Análisis asignaturas sin docentes o tutores: 
--Identificar el tipo de asignatura, 
--la jornada, 
--la cantidad de áreas únicas 
--y la cantidad total de asignaturas que no tienen asignadas docentes o tutores.
--Ordenar por tipo de forma descendente.

SELECT 
Asignaturas.Tipo AS TipoAsignatura,
Asignaturas.Jornada AS JornadaAsignatura,
COUNT(DISTINCT Asignaturas.Area) AS CantidadAreasUnicas,
COUNT(*) AS CantidadTotalSinDocentes
FROM Asignaturas
LEFT JOIN
Staff ON Staff.Asignatura = Asignaturas.AsignaturasID
WHERE Staff.DocentesID IS NULL
GROUP BY 
    Asignaturas.Tipo,
    Asignaturas.Jornada
ORDER BY
    Asignaturas.Tipo DESC;
; 

-----------------------------------------------------------------------------------------------------------------------------------------------
--Análisis asignaturas mayor al promedio: 
--Identificar el nombre de la asignatura, 
--el costo de la asignatura 
--y el promedio del costo de las asignaturas por área. 
--Una vez obtenido el dato, del promedio se debe visualizar 
--solo las carreras que se encuentran por encima del promedio. 
SELECT * FROM Area

SELECT
    Asignaturas.Nombre AS NombreAsignatura,
    Asignaturas.Costo,
    PromedioCostoPorArea
FROM
    Asignaturas
JOIN (
    SELECT
        Area.AreaID,
        AVG(Asignaturas.Costo) AS PromedioCostoPorArea
    FROM
        Area
    JOIN
        Asignaturas ON Asignaturas.Area = Area.AreaID
    GROUP BY
        Area.AreaID
) AS SubPromedioCosto
ON Asignaturas.Area = SubPromedioCosto.AreaID
WHERE
    Asignaturas.Costo > SubPromedioCosto.PromedioCostoPorArea
ORDER BY
    Asignaturas.Costo DESC;

----------------------------------------------------------------------------------------------------------------------------------
--Análisis aumento de salario docente: 
--Identificar el nombre, documento de identidad, el área, la asignatura 
--y el aumento del salario del docente, 
--este último calcularlo sacándole un porcentaje al costo de la asignatura, 
--todas las áreas tienen un porcentaje distinto, 
--Marketing-17%, 
--Diseño-20%, 
--Programación-23%, 
--Producto-13%, 
--Data-15%, 
--Herramientas 8%

SELECT * FROM Staff;
SELECT * FROM Area;
SELECT * FROM Asignaturas;

SELECT 
    Staff.Nombre,
    Staff.Documento,
    Area.Nombre,
    Asignaturas.Nombre,
    CASE 
        WHEN Area.Nombre = 'Marketing Digital' THEN Asignaturas.Costo * 0.17
        WHEN Area.Nombre = 'Diseno UX' THEN Asignaturas.Costo * 0.20
        WHEN Area.Nombre = 'Programación' THEN Asignaturas.Costo * 0.23
        WHEN Area.Nombre = 'Producto' THEN Asignaturas.Costo * 0.13
        WHEN Area.Nombre = 'Data' THEN Asignaturas.Costo * 0.15
        WHEN Area.Nombre = 'Herramientas' THEN Asignaturas.Costo * 0.08
        ELSE 0 
    END AS AumentoSalario
FROM 
    Staff
JOIN 
    Asignaturas ON Staff.Asignatura = Asignaturas.AsignaturasID
JOIN 
    Area ON Asignaturas.Area = Area.AreaID
;

