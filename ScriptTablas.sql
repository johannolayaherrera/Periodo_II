USE [Referenciacion]
GO


CREATE TABLE [dbo].[Prue_Usuarios](
	[CedulaUsuario] [varchar](20),
	[IdPerfil] [int],
	[Nombre1] [varchar](50),
	[Nombre2] [varchar](50),
	[Apellido1] [varchar](50),
	[Apellido2] [varchar](50),
	[Email] [varchar](100),
	[FechaCreacion] [smalldatetime],
	[NtUserCreacion] [varchar](20),
	[FechaModificacion] [smalldatetime],
	[CedulaModificacion] [varchar](20),
	[Activo] [tinyint]
)
GO

CREATE TABLE [dbo].[Prue_Oferente](
	[CodigoOferente] [varchar](20),
	[NombreOferente] [varchar](20),
	[Activo] [tinyint]
)
GO

CREATE TABLE [dbo].[Prue_Oferta](
	[CodigoOferta] [varchar](20),
	[CodigoOferente] [varchar](20),
	[NombreOferta] [varchar](20),
	[Activo] [tinyint],
	[Finalizado] [bit]
)
GO



SELECT * FROM Campanas


