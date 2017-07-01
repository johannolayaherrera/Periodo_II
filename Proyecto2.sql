

DECLARE @Oferente TABLE (
	IdOferente INT PRIMARY KEY IDENTITY(1,1),
	Nit VARCHAR(20),
	NombreOferente VARCHAR(20),
	Estado TINYINT 
)

DECLARE @Oferta TABLE (
	IdOferta VARCHAR(20)PRIMARY KEY,
	IdOferente INT,
	NombreOferta VARCHAR(20),
	Estado TINYINT -- Activo,Inactivo,Finalizado
)

DECLARE @Items TABLE (
	IdItem INT PRIMARY KEY IDENTITY(1,1),
	IdOferente INT,
	TipoControl TINYINT,
	NombreItem VARCHAR(20),
	Activo BIT
)

DECLARE @Proceso TABLE (
	IdProceso INT PRIMARY KEY IDENTITY(1,1),
	IdOferente INT,
	NombreProceso VARCHAR(20), -- El primero es Inscripci�n
	IdItem INT
)

DECLARE @OfertaProceso TABLE (
	IdOferta INT,
	IdProceso INT,
	FechaActivacion DATE,
	Estado TINYINT,
	Finalizado BIT -- Cuando ya se calific�
)

DECLARE @Calificacion TABLE (
	IdCalificacion INT PRIMARY KEY IDENTITY(1,1),
	NombreCalificacion VARCHAR(20),
	Activo BIT
)

DECLARE @CalificacionItem TABLE (
	IdCalificacion INT,
	IdItem INT 
)

DECLARE @Solicitante TABLE (
	Cedula VARCHAR(20) PRIMARY KEY,
	NombreSolicitante VARCHAR(20),
	Activo BIT 
)

DECLARE @Postulacion TABLE (
	IdPostulacion INT PRIMARY KEY IDENTITY(1,1),
	IdOferta INT, 
	Cedula VARCHAR(20),
	Activo BIT 
)

DECLARE @ProcesoPostulacion TABLE (
	IdProcesoPostulacion INT IDENTITY(1,1),
	IdOferta INT,
	IdProceso INT,
	IdPostulacion INT,
	Estado TINYINT
)

DECLARE @Estado TABLE (
	IdEstado INT IDENTITY(1,1),
	Estado INT,
	Oferente INT,
	IndicaAprobado TINYINT --(0,1,2 Pendiente)
)


DECLARE @PostulacionProcesoFormulario TABLE (
	IdPostulacion INT,
	IdOferta INT,
	IdProceso INT,
	IdItem INT,
	Respuesta VARCHAR(20)
)

-- COMO LOS FORMULARIOS DE GMAIL
---------------------------------------------------
--			   Administrador                     --
--------------------------------------------------- 
--Crear Oferente
	-- Env�o informaci�n de oferente
INSERT INTO @Oferente (Nit,NombreOferente,Estado)
VALUES ('123','Empresa Prueba',1)

---------------------------------------------------
--					Oferente                     --
--------------------------------------------------- 
--Crear Oferta 
	-- Env�o informaci�n Oferente,Oferta y proceso de inscripci�n (Proceso,items)
DECLARE @Nit VARCHAR(20) = '123'

DECLARE @IdOferente INT = (SELECT IdOferente FROM @Oferente
WHERE Nit = @Nit)
	-- Mostrar Procesos existentes
	-- Puede tomar un IdProceso de aqu�
	SELECT * FROM @Proceso p
	INNER JOIN @Items i ON p.IdItem = i.IdItem
	WHERE p.IdOferente = @IdOferente
	AND p.NombreProceso = 'Inscripci�n'
	
DECLARE @IdOferta VARCHAR(20)= 'AC1'
DECLARE @NombreOferta VARCHAR(20)= 'Beca Android'

INSERT INTO @Oferta (IdOferta,IdOferente,NombreOferta,Estado)
VALUES (@IdOferta,@IdOferente,@NombreOferta,1)

-- o tambien puede crear una nueva si el formulario no es conveniente
IF(NOT EXISTS (SELECT IdItem FROM @Items WHERE IdOferente = @IdOferente
AND TipoControl = 'Texto' AND NombreItem = 'Nombre postulante'))
BEGIN
	INSERT INTO @Items (IdItem,IdOferente,TipoControl,NombreItem,Activo)
	VALUES (1,@IdOferente,'Texto','Nombre postulante',1)
END

IF(NOT EXISTS (SELECT IdItem FROM @Items WHERE IdOferente = @IdOferente
AND TipoControl = 'Texto' AND NombreItem = 'Apellido postulante'))
BEGIN
	INSERT INTO @Items (IdItem,IdOferente,TipoControl,NombreItem,Activo)
	VALUES (2,@IdOferente,'Texto','Apellido postulante',1)
END


INSERT INTO @Proceso (IdOferente,NombreProceso,IdItem)
VALUES (@IdOferente,'Inscripci�n',1)

INSERT INTO @Proceso (IdOferente,NombreProceso,IdItem)
VALUES (@IdOferente,'Inscripci�n',2)

	
--Que un estado para todos sea finalizado.

-- SI EL PROCESO NO TIENE FORMULARIO ENTONCES TODOS LOS POSTULADOS SE TENDRIAN EN CUENTA PARA LA DECISION
/*
---------------------------------------------------------------------------------------------------
--- POR CADA CREACION DE OFERENTE O SE LE CREAN SUS PROPIAS TABLAS O SU PROPIA BASE DE DATOS ------
---------------------------------------------------------------------------------------------------

/tbl.Oferente -> Oferente
/**tbl.Oferta -> Oferente - Oferta, Activo,Finalizado
-- Formulario ----
/**tbl.Proceso -> Oferente - Proceso - items (Formulario) El proceso debe tener un formulario,Inscripci�n (Si/No)
/**tbl.OfertaProceso -> Oferta,Proceso,FechaActivaci�n, Activo,Finalizado(Cuando ya se calific�)
/**tbl.tipoControl -> tipoControl
/**tbl.items -> Oferente, items, tipoControl
/**tbl.Calificacion -> Calificacion
/**tbl.CalificacionItems -> Calificacion - Items
-- Fin Formulario -----
/**tbl.ProcesoPostulaci�n ->	Oferta, Proceso, Postulaci�n
,Finalizado (Indica que ya se ha enviado el formulario)
,Estado(Activo,Inactivo,Pendiente) -- Indica la calificaci�n final -- Verificar en que proceso se Reprobo
/**tbl.Postulaci�nProcesoFormulario (ReferenciaGestionitem) ->  Postulaci�n - Oferta - Proceso - items - Respuesta 
(Algoritmo de validaci�n)
**tbl.MensajeNotificacion -> Oferente,estado,Mensaje
/**tbl.Postulaci�n -> Solicitante,Cod.Postulacion,Oferta,Activo
/**tbl.Solicitante -> Solicitante
Adjuntos -> Proceso - Adjunto - Solcitante	
//-----------------

*Ingresa el oferente en tbl.Oferente
*Crear Oferta en tbl.Oferta
	Opci�n mostrar procesos existentes en tbl.Proceso
		Opci�n mostrar formulario de proceso existente tbl.Proceso
	-Debe crear el proceso de inscripci�n 
		
*Crear Proceso para una oferta en tbl.OfertaProceso
	+ desde tbl.Proceso
	+ o Si es nuevo se guarda en tbl.Proceso , Aqui ya tenemos el formulario creado.

*Ingresa el solicitante en tbl.Solicitante

*Crear postulaci�n        
	-Busca oferta con proceso de inscripci�n Activo en tbl.OfertaProceso.
		-Se crea la postulaci�n en tbl.Postulaci�n y en tbl.ProcesoPostulaci�n
		-Se crea el proceso para esa postulaci�n en tbl.Postulaci�nProcesoFormulario 
		Los dos pasos anteriores se realizan por demanda.(Organizar por turnos)
		
*Activaci�n de Procesos autom�tico
 Un Job busca para las ofertas activas la fecha de activaci�n en tbl.OfertaProceso si es igual a la actual entonces,
	+Si es de inscripci�n entonces activa el proceso en tbl.OfertaProceso y activa en 
	+Sino entonces revisa en tbl.Postulaci�n las postulaciones activas y para estos crea la asociaci�n al proceso 
	que se activa en tbl.ProcesoPostulaci�n, Luego crear el formulario correspondiente en tbl.Postulaci�nProcesoFormulario 
	para almacenar las respuestas.


*Llenar formulario de proceso
	Busca la postulaci�n activa en tbl.Postulaci�n
	Busca el proceso en tbl.ProcesoPostulaci�n activo
	Se carga el formulario del proceso desde tbl.Postulaci�nProcesoFormulario
		guarda en tbl.Postulaci�nProcesoFormulario
	Si finaliza actualiza en tbl.ProcesoPostulaci�n --  (Una tabla afectada por Oferente y Solicitante 
	y actualizaci�n restringida a nivel de columna,sp)
	
	*En la tabla tbl.ProcesoPostulaci�n la columna finaliza indica que ya se ha guardado totalmente el formulario y 
	no se puede modificar. Si esta no esta finalizada el formulario se cargara con los datos anteriores que el solicitante
	ha guardado.

*Calificar postulaci�n
	Busca Oferta, Busca Proceso (Solo permite calificar los procesos que no est�n finalizados) Ver postulaciones 
	en tbl.ProcesoPostulaci�n y califico el proceso (Calificacion de procesos parametrizados, estados finales 
	que pasen el proceso)
	Si la calificaci�n indica reprobado entonces la postulaci�n tbl.Postulaci�n queda inactiva
	
	Al final btn EnviarNotificaciones envia notificaciones a las postulaciones de tbl.ProcesoPostulaci�n indicando el 
	estado de la calificaci�n del proceso y el estado de la postulaci�n tbl.Postulaci�n 
	
*Consultar estado de la postulaci�n
	Buscar Postulaci�n en tbl.Postulaci�n (Activas e inactivas) mostrar las postulaciones
		Buscar Procesos de esa postulaci�n como un detalle tbl.ProcesoPostulaci�n

*Inactivar oferta
Buscar oferta en tbl.Oferta 
	Inactivarla en tbl.Oferta 
	Buscar los procesos activos asociados a esa oferta tbl.OfertaProceso 
		+Si hay procesos activos entonces se buscan las postulaciones asociadas a ese proceso en tbl.ProcesoPostulaci�n
		finaliza en tbl.ProcesoPostulaci�n e inactiva la postulaci�n en tbl.Postulaci�n
		+ SIno entonces toma el ultimo proceso que tuvo esa oferta, y realiza el procedimiento anterior.
		
	Env�a notificaciones a las postulaciones asociadas a esa oferta.
		
*Buscar Oferta 
	Buscar oferta en tbl.Oferta 
	

**Como se finalizar� un proceso por parte del oferente
	
Extra
Reutilizaci�n de procesos con formulario
Permitir filtrar Candidatos con ciertas respuestas para que no tengan que ver una a una, filtro de calificaci�n.
Permite edici�n de los formularios temporalmente antes de finalizarlo 
Permite editar un formulario finalizado por Ticket, colocando 0 en finalizado.

*Pendiente configuraci�n de los mensajes seg�n el estado.

Restricciones
Cada proceso debe tener por lo menos un formulario
Todas las ofertas y procesos tendr�n un estado finalizado definido por el sistema
---BackUp Cada vez que se termina -- Temas Legales 


Ha implementar

Seguridad Log in
Oferente
	Crear Oferta
	Crear Proceso
	Crear Formulario
	Calificar postulaciones
Solicitante
	Crear postulaci�n
	LLenar formulario de proceso
	Consultar estado de postulaci�n
Adminis
	Inactivar oferta
	Crear oferente 
	Inactivar Oferente
	Inactivar Solicitante (Problemas de seguridad)

*/