SELECT * FROM Usuarios

--Parametricas
SELECT * FROM Oferente
SELECT * FROM Campanas -- (Oferta,Oferente)
SELECT * FROM Procesos --(Los procesos se pueden reutilizar  (Proceso,Oferente,items)  --DESCRIPCI�N DEL PROICESO ETC)
SELECT * FROM CategoriaItem -- (Categorias -- Procesos,Oferta,Activo)
SELECT * FROM Items -- (Items-Oferente) Se puede reusar en campa�as y procesos.. Ventana de items en la app
SELECT * FROM TipoInformItem --TipoControlItem
SELECT * FROM TipoReferenciaItems -- (Campa�a (Oferta) - TipoReferencia (Proceso) - Items)
WHERE IdTipoReferencia = 1 AND IdCampana = 1

SELECT * FROM CalificacionItems
SELECT * FROM Calificacion
SELECT TOP 10 * FROM ReferenciasGestionItem

/*

tbl.Oferente -> Oferente
**tbl.Oferta -> Oferente - Oferta, Activo,Finalizado
-- Formulario ----
**tbl.Proceso -> Oferente - Proceso - items (Formulario) El proceso debe tener un formulario
**tbl.OfertaProceso -> Oferta,Proceso,FechaActivaci�n, Activo,Inscripci�n (Si/No),Finalizado(Cuando ya se calific�)
**tbl.tipoControl -> tipoControl
**tbl.items -> Oferente, items, tipoControl
**tbl.Calificacion -> Calificacion
**tbl.CalificacionItems -> Calificacion - Items
-- Fin Formulario -----
**tbl.ProcesoPostulaci�n ->	Oferta, Proceso, Postulaci�n
,Finalizado (Indica que ya se ha enviado el formulario)
,Estado(Activo,Inactivo,Pendiente) -- Indica la calificaci�n final -- Verificar en que proceso se Reprobo
**tbl.Postulaci�nProcesoFormulario (ReferenciaGestionitem) ->  Postulaci�n - Oferta - Proceso - items - Respuesta 
(Algoritmo de validaci�n)
**tbl.MensajeNotificacion -> Oferente,estado,Mensaje
**tbl.Postulaci�n -> Solicitante,Cod.Postulacion,Oferta,Activo
**tbl.Solicitante -> Solicitante
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



