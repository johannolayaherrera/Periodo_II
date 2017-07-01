SELECT * FROM Usuarios

--Parametricas
SELECT * FROM Oferente
SELECT * FROM Campanas -- (Oferta,Oferente)
SELECT * FROM Procesos --(Los procesos se pueden reutilizar  (Proceso,Oferente,items)  --DESCRIPCIóN DEL PROICESO ETC)
SELECT * FROM CategoriaItem -- (Categorias -- Procesos,Oferta,Activo)
SELECT * FROM Items -- (Items-Oferente) Se puede reusar en campañas y procesos.. Ventana de items en la app
SELECT * FROM TipoInformItem --TipoControlItem
SELECT * FROM TipoReferenciaItems -- (Campaña (Oferta) - TipoReferencia (Proceso) - Items)
WHERE IdTipoReferencia = 1 AND IdCampana = 1

SELECT * FROM CalificacionItems
SELECT * FROM Calificacion
SELECT TOP 10 * FROM ReferenciasGestionItem

/*

tbl.Oferente -> Oferente
**tbl.Oferta -> Oferente - Oferta, Activo,Finalizado
-- Formulario ----
**tbl.Proceso -> Oferente - Proceso - items (Formulario) El proceso debe tener un formulario
**tbl.OfertaProceso -> Oferta,Proceso,FechaActivación, Activo,Inscripción (Si/No),Finalizado(Cuando ya se calificó)
**tbl.tipoControl -> tipoControl
**tbl.items -> Oferente, items, tipoControl
**tbl.Calificacion -> Calificacion
**tbl.CalificacionItems -> Calificacion - Items
-- Fin Formulario -----
**tbl.ProcesoPostulación ->	Oferta, Proceso, Postulación
,Finalizado (Indica que ya se ha enviado el formulario)
,Estado(Activo,Inactivo,Pendiente) -- Indica la calificación final -- Verificar en que proceso se Reprobo
**tbl.PostulaciónProcesoFormulario (ReferenciaGestionitem) ->  Postulación - Oferta - Proceso - items - Respuesta 
(Algoritmo de validación)
**tbl.MensajeNotificacion -> Oferente,estado,Mensaje
**tbl.Postulación -> Solicitante,Cod.Postulacion,Oferta,Activo
**tbl.Solicitante -> Solicitante
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



