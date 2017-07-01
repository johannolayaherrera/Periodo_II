/*
Apuntes importante


* Se podra tener formularios guardados por los oferentes que puedan ser reutilizados para ello los tenemos en una tabla aparte y los relacionamos
con el proceso como un id, entonces el formulario quedaría a nivel de oferente.
*Al crear un oferente se le crearán sus respectivas tablas o base de datos. y una tabla maestra será la encargada de 
direccionarlo.


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

	