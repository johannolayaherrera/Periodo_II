/*
Apuntes importante


* Se podra tener formularios guardados por los oferentes que puedan ser reutilizados para ello los tenemos en una tabla aparte y los relacionamos
con el proceso como un id, entonces el formulario quedar�a a nivel de oferente.
*Al crear un oferente se le crear�n sus respectivas tablas o base de datos. y una tabla maestra ser� la encargada de 
direccionarlo.


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

	