

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
	NombreProceso VARCHAR(20), -- El primero es Inscripción
	IdItem INT
)

DECLARE @OfertaProceso TABLE (
	IdOferta INT,
	IdProceso INT,
	FechaActivacion DATE,
	Estado TINYINT,
	Finalizado BIT -- Cuando ya se calificó
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
	-- Envío información de oferente
INSERT INTO @Oferente (Nit,NombreOferente,Estado)
VALUES ('123','Empresa Prueba',1)

---------------------------------------------------
--					Oferente                     --
--------------------------------------------------- 
--Crear Oferta 
	-- Envío información Oferente,Oferta y proceso de inscripción (Proceso,items)
DECLARE @Nit VARCHAR(20) = '123'

DECLARE @IdOferente INT = (SELECT IdOferente FROM @Oferente
WHERE Nit = @Nit)
	-- Mostrar Procesos existentes
	-- Puede tomar un IdProceso de aquí
	SELECT * FROM @Proceso p
	INNER JOIN @Items i ON p.IdItem = i.IdItem
	WHERE p.IdOferente = @IdOferente
	AND p.NombreProceso = 'Inscripción'
	
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
VALUES (@IdOferente,'Inscripción',1)

INSERT INTO @Proceso (IdOferente,NombreProceso,IdItem)
VALUES (@IdOferente,'Inscripción',2)

	
--Que un estado para todos sea finalizado.

-- SI EL PROCESO NO TIENE FORMULARIO ENTONCES TODOS LOS POSTULADOS SE TENDRIAN EN CUENTA PARA LA DECISION
/*
---------------------------------------------------------------------------------------------------
--- POR CADA CREACION DE OFERENTE O SE LE CREAN SUS PROPIAS TABLAS O SU PROPIA BASE DE DATOS ------
---------------------------------------------------------------------------------------------------

/tbl.Oferente -> Oferente
/**tbl.Oferta -> Oferente - Oferta, Activo,Finalizado
-- Formulario ----
/**tbl.Proceso -> Oferente - Proceso - items (Formulario) El proceso debe tener un formulario,Inscripción (Si/No)
/**tbl.OfertaProceso -> Oferta,Proceso,FechaActivación, Activo,Finalizado(Cuando ya se calificó)
/**tbl.tipoControl -> tipoControl
/**tbl.items -> Oferente, items, tipoControl
/**tbl.Calificacion -> Calificacion
/**tbl.CalificacionItems -> Calificacion - Items
-- Fin Formulario -----
/**tbl.ProcesoPostulación ->	Oferta, Proceso, Postulación
,Finalizado (Indica que ya se ha enviado el formulario)
,Estado(Activo,Inactivo,Pendiente) -- Indica la calificación final -- Verificar en que proceso se Reprobo
/**tbl.PostulaciónProcesoFormulario (ReferenciaGestionitem) ->  Postulación - Oferta - Proceso - items - Respuesta 
(Algoritmo de validación)
**tbl.MensajeNotificacion -> Oferente,estado,Mensaje
/**tbl.Postulación -> Solicitante,Cod.Postulacion,Oferta,Activo
/**tbl.Solicitante -> Solicitante
Adjuntos -> Proceso - Adjunto - Solcitante	
//-----------------

*Ingresa el oferente en tbl.Oferente
*Crear Oferta en tbl.Oferta
	Opción mostrar procesos existentes en tbl.Proceso
		Opción mostrar formulario de proceso existente tbl.Proceso
	-Debe crear el proceso de inscripción 
		
*Crear Proceso para una oferta en tbl.OfertaProceso
	+ desde tbl.Proceso
	+ o Si es nuevo se guarda en tbl.Proceso , Aqui ya tenemos el formulario creado.

*Ingresa el solicitante en tbl.Solicitante

*Crear postulación        
	-Busca oferta con proceso de inscripción Activo en tbl.OfertaProceso.
		-Se crea la postulación en tbl.Postulación y en tbl.ProcesoPostulación
		-Se crea el proceso para esa postulación en tbl.PostulaciónProcesoFormulario 
		Los dos pasos anteriores se realizan por demanda.(Organizar por turnos)
		
*Activación de Procesos automático
 Un Job busca para las ofertas activas la fecha de activación en tbl.OfertaProceso si es igual a la actual entonces,
	+Si es de inscripción entonces activa el proceso en tbl.OfertaProceso y activa en 
	+Sino entonces revisa en tbl.Postulación las postulaciones activas y para estos crea la asociación al proceso 
	que se activa en tbl.ProcesoPostulación, Luego crear el formulario correspondiente en tbl.PostulaciónProcesoFormulario 
	para almacenar las respuestas.


*Llenar formulario de proceso
	Busca la postulación activa en tbl.Postulación
	Busca el proceso en tbl.ProcesoPostulación activo
	Se carga el formulario del proceso desde tbl.PostulaciónProcesoFormulario
		guarda en tbl.PostulaciónProcesoFormulario
	Si finaliza actualiza en tbl.ProcesoPostulación --  (Una tabla afectada por Oferente y Solicitante 
	y actualización restringida a nivel de columna,sp)
	
	*En la tabla tbl.ProcesoPostulación la columna finaliza indica que ya se ha guardado totalmente el formulario y 
	no se puede modificar. Si esta no esta finalizada el formulario se cargara con los datos anteriores que el solicitante
	ha guardado.

*Calificar postulación
	Busca Oferta, Busca Proceso (Solo permite calificar los procesos que no están finalizados) Ver postulaciones 
	en tbl.ProcesoPostulación y califico el proceso (Calificacion de procesos parametrizados, estados finales 
	que pasen el proceso)
	Si la calificación indica reprobado entonces la postulación tbl.Postulación queda inactiva
	
	Al final btn EnviarNotificaciones envia notificaciones a las postulaciones de tbl.ProcesoPostulación indicando el 
	estado de la calificación del proceso y el estado de la postulación tbl.Postulación 
	
*Consultar estado de la postulación
	Buscar Postulación en tbl.Postulación (Activas e inactivas) mostrar las postulaciones
		Buscar Procesos de esa postulación como un detalle tbl.ProcesoPostulación

*Inactivar oferta
Buscar oferta en tbl.Oferta 
	Inactivarla en tbl.Oferta 
	Buscar los procesos activos asociados a esa oferta tbl.OfertaProceso 
		+Si hay procesos activos entonces se buscan las postulaciones asociadas a ese proceso en tbl.ProcesoPostulación
		finaliza en tbl.ProcesoPostulación e inactiva la postulación en tbl.Postulación
		+ SIno entonces toma el ultimo proceso que tuvo esa oferta, y realiza el procedimiento anterior.
		
	Envía notificaciones a las postulaciones asociadas a esa oferta.
		
*Buscar Oferta 
	Buscar oferta en tbl.Oferta 
	

**Como se finalizará un proceso por parte del oferente
	
Extra
Reutilización de procesos con formulario
Permitir filtrar Candidatos con ciertas respuestas para que no tengan que ver una a una, filtro de calificación.
Permite edición de los formularios temporalmente antes de finalizarlo 
Permite editar un formulario finalizado por Ticket, colocando 0 en finalizado.

*Pendiente configuración de los mensajes según el estado.

Restricciones
Cada proceso debe tener por lo menos un formulario
Todas las ofertas y procesos tendrán un estado finalizado definido por el sistema
---BackUp Cada vez que se termina -- Temas Legales 


Ha implementar

Seguridad Log in
Oferente
	Crear Oferta
	Crear Proceso
	Crear Formulario
	Calificar postulaciones
Solicitante
	Crear postulación
	LLenar formulario de proceso
	Consultar estado de postulación
Adminis
	Inactivar oferta
	Crear oferente 
	Inactivar Oferente
	Inactivar Solicitante (Problemas de seguridad)

*/