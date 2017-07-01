**tbl.Proceso -> Oferente - Proceso - items (Formulario) El proceso debe tener un formulario

**tbl.tipoControl -> tipoControl
**tbl.items -> Oferente, items, tipoControl
**tbl.Calificacion -> Calificacion
**tbl.CalificacionItems -> Calificacion - Items


/*


DROP TABLE [dbo].[Prue_TipoControl]
DROP TABLE [dbo].[Prue_Item]
DROP TABLE [dbo].[Prue_Respuesta]
DROP TABLE [dbo].[Prue_Proceso]
DROP TABLE [dbo].[Prue_RespuestaFormulario]

DROP PROCEDURE [dbo].[Prue_spInsertarItemsProceso]
*/

	CREATE TABLE [dbo].[Prue_TipoControl](
	[IdTipoControl] [int],
	[TipoControl] [varchar](50),
	[Activo] [tinyint])
	
	CREATE TABLE [dbo].[Prue_Item](
	[IdItem] [int],
	[Item] [varchar](500),
	[IdTipoControl] [int],
	[Activo] [tinyint])
	
	CREATE TABLE [dbo].[Prue_Respuesta](
	[IdRespuesta] [int],
	[IdItem] [int],
	[Respuesta] [varchar](20),
	[Activo] [tinyint])

	CREATE TABLE [dbo].[Prue_Proceso](
	[CodigoProceso] [varchar](20),
	[NombreProceso] [varchar](20),
	[IdItem] [int],
	[Activo] [bit],
	[NTModificacion] [varchar](20),
	[FechaCreacion] [datetime]) 
	
	CREATE TABLE [dbo].[Prue_RespuestaFormulario](
	[CodigoPostulacion] [varchar](20),
	[CodigoProceso] [varchar](20),
	[IdItem] [int],
	[Respuesta] [varchar](20),
	[FechaCreacion] [datetime])

-- Procedimientos


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author: 
-- Create date: 
-- Description: 
-- ==============================================================
-- -------------------------- History ---------------------------
-- Version	Date        Author      Descripcion
-- 01		
-- ==============================================================
CREATE PROCEDURE [dbo].[Prue_spInsertarItemsProceso] 
	@CodigoProceso VARCHAR(20)
	,@identificacion VARCHAR(20)
	,@IdTipoFormulario INT
	,@NumFormularios BIGINT
	,@AnoDeclarado VARCHAR(4)
	,@NtUser VARCHAR(20)
	
		[CodigoProceso] [varchar](20),
	[NombreProceso] [varchar](20),
	[Activo] [bit](1),
	[NTModificacion] [varchar](20),
	[FechaCreacion] [datetime]) 
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @TipoDocumento VARCHAR(10)
	DECLARE @UltimoRegistro INT
	DECLARE @Campana TINYINT

	SELECT @TipoDocumento = IdTipoIdentificacion
	FROM Participantes
	WHERE IdParticipante = @identificacion

	SELECT @Campana = IdCampana
	FROM Solicitud
	WHERE IdSolicitud = @IdSolicitud

	INSERT INTO [DeclaracionRenta] (
		[IdTipoFormulario]
		,[NFormularioDR]
		,[TipoDocumento]
		,[IdCedula]
		,[AnoDeclarado]
		,[FechaCreacion]
		,[NtCreacion]
		,[Activo]
		)
	VALUES (
		@IdTipoFormulario
		,@NumFormularios
		,@TipoDocumento
		,@identificacion
		,@AnoDeclarado
		,GETDATE()
		,@NtUser
		,1
		)

	SET @UltimoRegistro = @@IDENTITY

	INSERT INTO [Referenciacion].[dbo].[DeclaracionRentaSolicitud] (
		[IdSolicitud]
		,[IdCampana]
		,[IdDeclaracionRenta]
		)
	VALUES (
		@IdSolicitud
		,@Campana
		,@UltimoRegistro
		)
END



GO
