USE [master]
GO
/* For security reasons the login is created disabled and with a random password. */
/****** Object:  Login [admin]    Script Date: 10/04/2025 15:13:45 ******/
CREATE LOGIN [admin] WITH PASSWORD=N'Nl5Tu/wwSDuVBOKEfh8HH1GYnNvO74kfOPq4fiKNjrk=', DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[Français], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO
ALTER LOGIN [admin] DISABLE
GO
ALTER SERVER ROLE [dbcreator] ADD MEMBER [admin]
GO
USE [AP4]
GO
/****** Object:  User [admin]    Script Date: 10/04/2025 15:13:45 ******/
CREATE USER [admin] FOR LOGIN [admin] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_owner] ADD MEMBER [admin]
GO
/****** Object:  UserDefinedFunction [dbo].[VerifLoginPassword]    Script Date: 10/04/2025 15:13:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[VerifLoginPassword](@Login VARCHAR(50), @Password VARCHAR(128)) RETURNS BIT
AS
BEGIN
	DECLARE @estValide BIT = 0;
	--DECLARE @hashedPassword VARCHAR(128) = CONVERT(VARCHAR(128),HASHBYTES('SHA2_512',@Password),2)

	IF EXISTS (SELECT 1 FROM Adherents WHERE mail = @Login AND password = CONVERT(VARCHAR(128),HASHBYTES('SHA2_512',@Password)))

	BEGIN
		SET @estValide = 1;
	END
	RETURN @estValide;
END;
GO
/****** Object:  Table [dbo].[Adherents]    Script Date: 10/04/2025 15:13:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Adherents](
	[idAdherents] [int] IDENTITY(1,1) NOT NULL,
	[nom] [varchar](50) NULL,
	[prenom] [varchar](50) NULL,
	[mail] [varchar](50) NULL,
	[adresse] [varchar](50) NULL,
	[dateAdhesion] [date] NULL,
	[age] [int] NULL,
	[NbEvenement] [int] NULL,
	[password] [varchar](128) NULL,
 CONSTRAINT [PK__Adherent__AF5420A03ED1E0F8] PRIMARY KEY CLUSTERED 
(
	[idAdherents] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Evenements]    Script Date: 10/04/2025 15:13:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Evenements](
	[idEvenement] [int] IDENTITY(1,1) NOT NULL,
	[dateEvenement] [date] NULL,
	[idEquipe] [int] NULL,
	[nomEvenement] [varchar](50) NULL,
	[descriptionEvenement] [varchar](100) NULL,
	[idLieu] [int] NOT NULL,
	[idType] [int] NOT NULL,
	[heureDebut] [time](7) NULL,
	[heureFin] [time](7) NULL,
PRIMARY KEY CLUSTERED 
(
	[idEvenement] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Appel]    Script Date: 10/04/2025 15:13:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Appel](
	[idAdherents] [int] NOT NULL,
	[idEvenement] [int] NOT NULL,
	[presence] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[idAdherents] ASC,
	[idEvenement] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[EvenementsPersonnesPresentes]    Script Date: 10/04/2025 15:13:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[EvenementsPersonnesPresentes]
AS
SELECT dbo.Evenements.idEvenement, dbo.Evenements.nomEvenement, dbo.Evenements.dateEvenement, dbo.Adherents.idAdherents, dbo.Adherents.nom AS NomAdherent, dbo.Adherents.prenom AS PrenomAdherent, 
                  dbo.Appel.presence
FROM     dbo.Evenements INNER JOIN
                  dbo.Appel ON dbo.Evenements.idEvenement = dbo.Appel.idEvenement INNER JOIN
                  dbo.Adherents ON dbo.Appel.idAdherents = dbo.Adherents.idAdherents
WHERE  (dbo.Appel.presence = 1)
GO
/****** Object:  Table [dbo].[Joueur]    Script Date: 10/04/2025 15:13:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Joueur](
	[idAdherents] [int] NOT NULL,
	[post] [varchar](50) NULL,
	[jeu] [varchar](50) NULL,
	[salaire] [money] NULL,
	[contrat] [varchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[idAdherents] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[dirigeant]    Script Date: 10/04/2025 15:13:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[dirigeant](
	[idAdherents] [int] NOT NULL,
	[role] [varchar](50) NULL,
	[jeu] [varchar](50) NULL,
	[salaire] [money] NULL,
	[contrat] [varchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[idAdherents] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[ListeAdherents]    Script Date: 10/04/2025 15:13:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[ListeAdherents]
AS
SELECT dbo.Adherents.idAdherents, dbo.Adherents.nom, dbo.Adherents.prenom, CASE WHEN Dirigeant.idAdherents IS NOT NULL THEN 'Organisateur' WHEN Joueur.idAdherents IS NOT NULL 
                  THEN 'Joueur' ELSE 'Invité' END AS RoleAdherent
FROM     dbo.Adherents LEFT OUTER JOIN
                  dbo.dirigeant ON dbo.Adherents.idAdherents = dbo.dirigeant.idAdherents LEFT OUTER JOIN
                  dbo.Joueur ON dbo.Adherents.idAdherents = dbo.Joueur.idAdherents
GO
/****** Object:  Table [dbo].[Aborder]    Script Date: 10/04/2025 15:13:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Aborder](
	[idReunion] [int] NOT NULL,
	[idSujet] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[idReunion] ASC,
	[idSujet] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AdherentsPresents]    Script Date: 10/04/2025 15:13:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AdherentsPresents](
	[idAdherents] [int] NOT NULL,
	[idReunion] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[idAdherents] ASC,
	[idReunion] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[contenuMessage]    Script Date: 10/04/2025 15:13:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[contenuMessage](
	[idAdherents] [int] NOT NULL,
	[idMessage] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[idAdherents] ASC,
	[idMessage] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Equipe]    Script Date: 10/04/2025 15:13:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Equipe](
	[idEquipe] [int] IDENTITY(1,1) NOT NULL,
	[nomEquipe] [varchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[idEquipe] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[HistoAdh]    Script Date: 10/04/2025 15:13:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HistoAdh](
	[IdHisto] [int] IDENTITY(1,1) NOT NULL,
	[dateHisto] [datetime] NULL,
	[nom] [varchar](50) NULL,
	[prenom] [varchar](50) NULL,
	[mail] [varchar](320) NULL,
	[adresse] [varchar](50) NULL,
	[dateAdhesion] [datetime] NULL,
	[age] [int] NULL,
	[nbEvenement] [int] NULL,
 CONSTRAINT [PK_HistoAdh] PRIMARY KEY CLUSTERED 
(
	[IdHisto] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Lieux]    Script Date: 10/04/2025 15:13:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Lieux](
	[idLieu] [int] IDENTITY(1,1) NOT NULL,
	[nomLieu] [varchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[idLieu] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Message]    Script Date: 10/04/2025 15:13:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Message](
	[idMessage] [int] IDENTITY(1,1) NOT NULL,
	[contenuMessage] [varchar](100) NULL,
PRIMARY KEY CLUSTERED 
(
	[idMessage] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Remplacant]    Script Date: 10/04/2025 15:13:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Remplacant](
	[idAdherents] [int] NOT NULL,
	[post] [varchar](50) NULL,
	[jeu] [varchar](50) NULL,
	[salaire] [money] NULL,
	[contrat] [varchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[idAdherents] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[rencontreEquipe]    Script Date: 10/04/2025 15:13:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[rencontreEquipe](
	[idEvenement] [int] NOT NULL,
	[idEquipe] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[idEvenement] ASC,
	[idEquipe] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Reunion]    Script Date: 10/04/2025 15:13:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Reunion](
	[idReunion] [int] IDENTITY(1,1) NOT NULL,
	[nomReunion] [varchar](50) NULL,
	[idAdhrents] [int] NULL,
	[dateReunion] [date] NULL,
PRIMARY KEY CLUSTERED 
(
	[idReunion] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Sujet]    Script Date: 10/04/2025 15:13:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Sujet](
	[idSujet] [int] IDENTITY(1,1) NOT NULL,
	[typeDeSujet] [varchar](50) NULL,
	[description] [varchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[idSujet] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[type]    Script Date: 10/04/2025 15:13:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[type](
	[idType] [int] IDENTITY(1,1) NOT NULL,
	[nomType] [varchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[idType] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
INSERT [dbo].[Aborder] ([idReunion], [idSujet]) VALUES (1, 1)
GO
INSERT [dbo].[Aborder] ([idReunion], [idSujet]) VALUES (1, 2)
GO
SET IDENTITY_INSERT [dbo].[Adherents] ON 
GO
INSERT [dbo].[Adherents] ([idAdherents], [nom], [prenom], [mail], [adresse], [dateAdhesion], [age], [NbEvenement], [password]) VALUES (1, N'DUPONT', N'jean', N'dupont.jean@gmail.com', N'34 rue ', CAST(N'2025-04-03' AS Date), 23, 2, N'´r²hÿµþ*JàÛK†(. O±X½PÐCÈJG"£û…¢30èfÈ×xj›¸žA4 K/š‹cEÎ:–')
GO
INSERT [dbo].[Adherents] ([idAdherents], [nom], [prenom], [mail], [adresse], [dateAdhesion], [age], [NbEvenement], [password]) VALUES (2, N'MARTIN', N'louis', N'martin.louis@gmail.com', N'10 avenue', CAST(N'2025-04-03' AS Date), 19, 1, N'Ô5HKÊšéÒ:WpÚ" TåÎ¦I#Â\9àí)4~Ÿ
¶½•i4\[aþDãŠÁ^©3…®clæÁ[óßË§¦™g!±')
GO
INSERT [dbo].[Adherents] ([idAdherents], [nom], [prenom], [mail], [adresse], [dateAdhesion], [age], [NbEvenement], [password]) VALUES (3, N'ROGER', N'joris', N'roger.joris@gmail.com', N'71 rue', CAST(N'2025-04-03' AS Date), 18, 0, N'N‡%´4ñ¿oERÛ©‰wÝ*Ú cÐÖS\–Ž|Çu»°ô½òÍÅîÂÛ¦¹–Ž<S­tJùí¿ nÝ')
GO
INSERT [dbo].[Adherents] ([idAdherents], [nom], [prenom], [mail], [adresse], [dateAdhesion], [age], [NbEvenement], [password]) VALUES (4, N'DUBOIS', N'thomas', N'dubois.thomas@gmail.com', N'23 rue charle de gaule', CAST(N'2025-04-03' AS Date), 19, 1, N'Å)ÂØ„Jªî¶ Ò§ž% ‹¾ÝÙp´«ï)ƒÎ<ß=^ËŸfÿàd¥gj²ñqõíšˆÿ¶äÍÄ\¸H')
GO
INSERT [dbo].[Adherents] ([idAdherents], [nom], [prenom], [mail], [adresse], [dateAdhesion], [age], [NbEvenement], [password]) VALUES (5, N'FRANÇOIS', N'tibo', N'françois.tibo@gmail.com', N'6 rue monmartre', CAST(N'2025-04-03' AS Date), 29, 0, N'ÔÀ&3Ù ãô­
ƒÙ}¬ò¦?Q"ˆ6@š˜ˆÄpÒ‹š1ø›«r~ÏÀg£×Ö€h:2§êúæh')
GO
INSERT [dbo].[Adherents] ([idAdherents], [nom], [prenom], [mail], [adresse], [dateAdhesion], [age], [NbEvenement], [password]) VALUES (6, N'ANDRÉ', N'luc', N'andré.luc@gmail.com', NULL, CAST(N'2025-04-03' AS Date), NULL, 0, N'®O
OmY:·.‹Ö²(uvæPgàìx÷â1?ò Î­–ÝùÌúÚÍºÚ”Æ+ýã”‚¨‘ùíD­ØÄìUÍ')
GO
INSERT [dbo].[Adherents] ([idAdherents], [nom], [prenom], [mail], [adresse], [dateAdhesion], [age], [NbEvenement], [password]) VALUES (17, N'test', N'test', N'test@test.fr', NULL, CAST(N'2025-04-03' AS Date), NULL, 0, N'î&°ÝJ÷çIªŽãÁ
é’?a‰€w.G?ˆ¥Ô”
²zÁ…ø áÕøOˆ¼ˆÖ{72ÃÌ_©­ŽoWõ (¨ÿ')
GO
INSERT [dbo].[Adherents] ([idAdherents], [nom], [prenom], [mail], [adresse], [dateAdhesion], [age], [NbEvenement], [password]) VALUES (18, N'test2', N'test2', N'Invite@test2.fr', N'', CAST(N'2025-04-03' AS Date), NULL, 0, N'm îïµ‰°Žðg-¬‚5=½šÙžBÈ:óÖG¼Ê 2WµèóÜsûì„û\yÖâg{ù''è#¥Nx‘@Ù')
GO
INSERT [dbo].[Adherents] ([idAdherents], [nom], [prenom], [mail], [adresse], [dateAdhesion], [age], [NbEvenement], [password]) VALUES (26, N'aze', N'aze', N'Joueur@aze.fr', N'aze', CAST(N'2025-04-03' AS Date), 1, 0, N'”ÎWÓô	(Æ=iË
ƒ5G-P£e`ïDšI”ÌÚ{tù”äNŽÆ]{YØ[
dý¶m7À#%8—f')
GO
INSERT [dbo].[Adherents] ([idAdherents], [nom], [prenom], [mail], [adresse], [dateAdhesion], [age], [NbEvenement], [password]) VALUES (27, N'ok', N'ok', N'Dirigeant@ok.fr', N'ok', CAST(N'2025-04-03' AS Date), 1, 0, N'Ÿ»»Z2Ÿ—‚â5o¤‰Ï›6”2|“Mjò©ß-“lè7ûQ1–¤ÎUHGÍq4Â®™³ÃW¼«²êü{›up')
GO
INSERT [dbo].[Adherents] ([idAdherents], [nom], [prenom], [mail], [adresse], [dateAdhesion], [age], [NbEvenement], [password]) VALUES (29, N'zer', N'zer', NULL, NULL, CAST(N'2025-04-03' AS Date), NULL, 0, N'ÇÁò l~%§‚="ö~áUµWÚ.c	¾%öh àãå4LÏY|,Á0©}#C¯´œ‘ÂÈ¡»†M«òWÖÉ?')
GO
INSERT [dbo].[Adherents] ([idAdherents], [nom], [prenom], [mail], [adresse], [dateAdhesion], [age], [NbEvenement], [password]) VALUES (30, N'esfs', N'fs', NULL, NULL, CAST(N'2025-04-03' AS Date), NULL, 0, N'’j}fÒäÖà÷³ô¾+4’³º‡:=ù{¢Ù`_¥´0f?òƒ^Ôô
¼oV[ÿQa‹$A[vÒ/xÊÀ4:;Â')
GO
INSERT [dbo].[Adherents] ([idAdherents], [nom], [prenom], [mail], [adresse], [dateAdhesion], [age], [NbEvenement], [password]) VALUES (31, N'esfvx', N'esx', NULL, NULL, CAST(N'2025-04-03' AS Date), NULL, 0, N'ÅìÃnß3ÓÄÿu[ÝTÜou:{S¦Å˜`a	îÊ¨"oßXÄ`ü¤°pzRvl.¹v6&ó?¶Ù²''X')
GO
INSERT [dbo].[Adherents] ([idAdherents], [nom], [prenom], [mail], [adresse], [dateAdhesion], [age], [NbEvenement], [password]) VALUES (32, N'seF', NULL, NULL, NULL, CAST(N'2025-04-03' AS Date), NULL, 0, N'xùoìýç7Ÿ°êB²pˆ;ÁÕÎJÀÃãÿooR ÐÿQLŸœÓˆ¯†''
˜CÑ‘èÎÑ Â†ÂÎ[')
GO
INSERT [dbo].[Adherents] ([idAdherents], [nom], [prenom], [mail], [adresse], [dateAdhesion], [age], [NbEvenement], [password]) VALUES (33, N'sef', NULL, NULL, NULL, CAST(N'2025-04-03' AS Date), NULL, 0, N'8c†(†ãyÀ°‘"&-!ôež|‘~.˜âåaá´­l÷W)|aìŽl‘%8ß7ôþ”‰`ÜnáôüqA: l´Œ_')
GO
INSERT [dbo].[Adherents] ([idAdherents], [nom], [prenom], [mail], [adresse], [dateAdhesion], [age], [NbEvenement], [password]) VALUES (34, N'evx', NULL, NULL, NULL, CAST(N'2025-04-03' AS Date), NULL, 0, N'ÌµýI"’$Þ„§\?ÆË ˜Žb€ÀëÎE{I=zd™6”æçn‘žØŠX©TxœC:Õ¢RÝÒ''')
GO
INSERT [dbo].[Adherents] ([idAdherents], [nom], [prenom], [mail], [adresse], [dateAdhesion], [age], [NbEvenement], [password]) VALUES (35, N'gynft', NULL, NULL, NULL, CAST(N'2025-04-03' AS Date), NULL, 0, N'`–HL
øE
L¢î ÎÂ„àxšç[ï~w!ûõ¢ žCd  ÑN/ÿioîzfýÈ¾ÌBùžÄ.àYgü;Ø')
GO
INSERT [dbo].[Adherents] ([idAdherents], [nom], [prenom], [mail], [adresse], [dateAdhesion], [age], [NbEvenement], [password]) VALUES (36, N'ynftbdvytg', NULL, NULL, NULL, CAST(N'2025-04-03' AS Date), NULL, 0, N'åøH
Òa¤ð5åœ1:Éì†uYÿí¹ÖuT X¬Äêß‘=Ux:¾7†>F pã¡Ù•ÅhWÐ')
GO
INSERT [dbo].[Adherents] ([idAdherents], [nom], [prenom], [mail], [adresse], [dateAdhesion], [age], [NbEvenement], [password]) VALUES (37, N'rfgd', NULL, NULL, NULL, CAST(N'2025-04-03' AS Date), NULL, 0, N'ëÌX‚Þ1¡;=\– ßhUàÊ»6òH ·šüa|,NŒ7Ýô¤“Tèã'' ºŠ…Hí§=ŠÊdÊ}Ö
&®')
GO
INSERT [dbo].[Adherents] ([idAdherents], [nom], [prenom], [mail], [adresse], [dateAdhesion], [age], [NbEvenement], [password]) VALUES (38, N'rfgf', NULL, NULL, NULL, CAST(N'2025-04-03' AS Date), NULL, 0, N'îH''¼™’ èìÙt³[›T‚A2PþåÇkÆº#x¿''µP·=#H@²iÍ„‹}êõ@†rŽ@»ß¶PwÂG')
GO
INSERT [dbo].[Adherents] ([idAdherents], [nom], [prenom], [mail], [adresse], [dateAdhesion], [age], [NbEvenement], [password]) VALUES (39, N'dgf', NULL, NULL, NULL, CAST(N'2025-04-03' AS Date), NULL, 0, N'ûZ¡¤ëÊ ë¶„ó9sx‰x¬EXo˜ dZ*g,qiÙ8‚{šÊlñ¶´Å%ìrtˆ
ÑtôúTã«öZND>Ý')
GO
INSERT [dbo].[Adherents] ([idAdherents], [nom], [prenom], [mail], [adresse], [dateAdhesion], [age], [NbEvenement], [password]) VALUES (40, N'hgfd', NULL, NULL, NULL, CAST(N'2025-04-03' AS Date), NULL, 0, N'3¶Øqâ:ë3è :ºðáQß?].?”Ã0ò:§ã55­x=¬Kppéã}E|éøe»”j¦NÖK°6àN¹Õ')
GO
INSERT [dbo].[Adherents] ([idAdherents], [nom], [prenom], [mail], [adresse], [dateAdhesion], [age], [NbEvenement], [password]) VALUES (41, N'hfg', NULL, NULL, NULL, CAST(N'2025-04-03' AS Date), NULL, 0, N'àÃ÷ô§Ø].DVe’l
°Ôä¬q%ÌÒÛút±Æl&6åùžã$Dì‹V
*“­€h¶ÜLèÔ&¢$í©VÑÂææ')
GO
INSERT [dbo].[Adherents] ([idAdherents], [nom], [prenom], [mail], [adresse], [dateAdhesion], [age], [NbEvenement], [password]) VALUES (42, N'drfhg', NULL, NULL, NULL, CAST(N'2025-04-03' AS Date), NULL, 0, N'àˆ©µþæ¨ízcõG¹PÇî 4š?‰žF¥8•3ý]×E¸Þ*ªÕ7þ^÷	YÊävÃ-U£ D)EcüÓÝü')
GO
INSERT [dbo].[Adherents] ([idAdherents], [nom], [prenom], [mail], [adresse], [dateAdhesion], [age], [NbEvenement], [password]) VALUES (43, N'thgf', N'a', N'a@a.fe', N'a', CAST(N'2025-04-03' AS Date), 1, 0, N'Ž»þ›2;`ÌéÒ¾õ¢™Ùip‰¢06Ê
~Þi¬ÉÜjóÑ;œvOÊ¦¹!;@¤vV±''çóu¶Þ«	äc')
GO
SET IDENTITY_INSERT [dbo].[Adherents] OFF
GO
INSERT [dbo].[AdherentsPresents] ([idAdherents], [idReunion]) VALUES (1, 1)
GO
INSERT [dbo].[AdherentsPresents] ([idAdherents], [idReunion]) VALUES (2, 1)
GO
INSERT [dbo].[AdherentsPresents] ([idAdherents], [idReunion]) VALUES (3, 1)
GO
INSERT [dbo].[Appel] ([idAdherents], [idEvenement], [presence]) VALUES (1, 3, 1)
GO
INSERT [dbo].[Appel] ([idAdherents], [idEvenement], [presence]) VALUES (1, 5, 1)
GO
INSERT [dbo].[Appel] ([idAdherents], [idEvenement], [presence]) VALUES (2, 7, 1)
GO
INSERT [dbo].[Appel] ([idAdherents], [idEvenement], [presence]) VALUES (4, 5, 1)
GO
INSERT [dbo].[contenuMessage] ([idAdherents], [idMessage]) VALUES (1, 1)
GO
INSERT [dbo].[contenuMessage] ([idAdherents], [idMessage]) VALUES (4, 2)
GO
INSERT [dbo].[dirigeant] ([idAdherents], [role], [jeu], [salaire], [contrat]) VALUES (2, N'coach', N'rl', 3566.0000, N'CDI')
GO
INSERT [dbo].[dirigeant] ([idAdherents], [role], [jeu], [salaire], [contrat]) VALUES (5, N'staff', N'lol', 3456.0000, N'CDD')
GO
INSERT [dbo].[dirigeant] ([idAdherents], [role], [jeu], [salaire], [contrat]) VALUES (27, NULL, NULL, NULL, NULL)
GO
SET IDENTITY_INSERT [dbo].[Equipe] ON 
GO
INSERT [dbo].[Equipe] ([idEquipe], [nomEquipe]) VALUES (1, N'M8')
GO
INSERT [dbo].[Equipe] ([idEquipe], [nomEquipe]) VALUES (2, N'BDS')
GO
INSERT [dbo].[Equipe] ([idEquipe], [nomEquipe]) VALUES (3, N'Vita')
GO
SET IDENTITY_INSERT [dbo].[Equipe] OFF
GO
SET IDENTITY_INSERT [dbo].[Evenements] ON 
GO
INSERT [dbo].[Evenements] ([idEvenement], [dateEvenement], [idEquipe], [nomEvenement], [descriptionEvenement], [idLieu], [idType], [heureDebut], [heureFin]) VALUES (3, CAST(N'2013-04-23' AS Date), 1, N'cup', N'oui', 2, 4, CAST(N'10:30:00' AS Time), CAST(N'11:30:00' AS Time))
GO
INSERT [dbo].[Evenements] ([idEvenement], [dateEvenement], [idEquipe], [nomEvenement], [descriptionEvenement], [idLieu], [idType], [heureDebut], [heureFin]) VALUES (5, CAST(N'2013-04-22' AS Date), 3, N'scrim', N'c''est cooll', 3, 2, CAST(N'09:45:00' AS Time), CAST(N'12:00:00' AS Time))
GO
INSERT [dbo].[Evenements] ([idEvenement], [dateEvenement], [idEquipe], [nomEvenement], [descriptionEvenement], [idLieu], [idType], [heureDebut], [heureFin]) VALUES (7, CAST(N'2013-04-22' AS Date), 1, N'test', NULL, 2, 4, CAST(N'09:45:00' AS Time), CAST(N'12:00:00' AS Time))
GO
SET IDENTITY_INSERT [dbo].[Evenements] OFF
GO
SET IDENTITY_INSERT [dbo].[HistoAdh] ON 
GO
INSERT [dbo].[HistoAdh] ([IdHisto], [dateHisto], [nom], [prenom], [mail], [adresse], [dateAdhesion], [age], [nbEvenement]) VALUES (1, CAST(N'2024-12-05T09:21:36.263' AS DateTime), N'TEST', N'oia', N'test.ok@gmail.com', N'34 rue test', CAST(N'2024-12-05T00:00:00.000' AS DateTime), 45, 0)
GO
INSERT [dbo].[HistoAdh] ([IdHisto], [dateHisto], [nom], [prenom], [mail], [adresse], [dateAdhesion], [age], [nbEvenement]) VALUES (2, CAST(N'2024-12-05T10:44:21.133' AS DateTime), N'TEST', N'pl', N'test.pl@gmail.com', NULL, NULL, NULL, 0)
GO
SET IDENTITY_INSERT [dbo].[HistoAdh] OFF
GO
INSERT [dbo].[Joueur] ([idAdherents], [post], [jeu], [salaire], [contrat]) VALUES (2, N'top', N'lol', 245243.0000, N'CDD')
GO
INSERT [dbo].[Joueur] ([idAdherents], [post], [jeu], [salaire], [contrat]) VALUES (4, N'mid', N'lol', 345.0000, N'stagiaire')
GO
INSERT [dbo].[Joueur] ([idAdherents], [post], [jeu], [salaire], [contrat]) VALUES (26, N'test', NULL, NULL, NULL)
GO
SET IDENTITY_INSERT [dbo].[Lieux] ON 
GO
INSERT [dbo].[Lieux] ([idLieu], [nomLieu]) VALUES (1, N'paris')
GO
INSERT [dbo].[Lieux] ([idLieu], [nomLieu]) VALUES (2, N'lyon')
GO
INSERT [dbo].[Lieux] ([idLieu], [nomLieu]) VALUES (3, N'lille')
GO
INSERT [dbo].[Lieux] ([idLieu], [nomLieu]) VALUES (4, N'marseille')
GO
SET IDENTITY_INSERT [dbo].[Lieux] OFF
GO
SET IDENTITY_INSERT [dbo].[Message] ON 
GO
INSERT [dbo].[Message] ([idMessage], [contenuMessage]) VALUES (1, N'coolll')
GO
INSERT [dbo].[Message] ([idMessage], [contenuMessage]) VALUES (2, N'superrr')
GO
INSERT [dbo].[Message] ([idMessage], [contenuMessage]) VALUES (3, N'nullll')
GO
SET IDENTITY_INSERT [dbo].[Message] OFF
GO
INSERT [dbo].[Remplacant] ([idAdherents], [post], [jeu], [salaire], [contrat]) VALUES (2, N'top', N'lol', 2355.0000, N'CDD')
GO
INSERT [dbo].[rencontreEquipe] ([idEvenement], [idEquipe]) VALUES (3, 2)
GO
INSERT [dbo].[rencontreEquipe] ([idEvenement], [idEquipe]) VALUES (5, 3)
GO
SET IDENTITY_INSERT [dbo].[Reunion] ON 
GO
INSERT [dbo].[Reunion] ([idReunion], [nomReunion], [idAdhrents], [dateReunion]) VALUES (1, N'réunion staff', 2, CAST(N'2024-01-01' AS Date))
GO
SET IDENTITY_INSERT [dbo].[Reunion] OFF
GO
SET IDENTITY_INSERT [dbo].[Sujet] ON 
GO
INSERT [dbo].[Sujet] ([idSujet], [typeDeSujet], [description]) VALUES (1, N'discution world', N'on a fait ça')
GO
INSERT [dbo].[Sujet] ([idSujet], [typeDeSujet], [description]) VALUES (2, N'recrutement', N'c''est cool')
GO
SET IDENTITY_INSERT [dbo].[Sujet] OFF
GO
SET IDENTITY_INSERT [dbo].[type] ON 
GO
INSERT [dbo].[type] ([idType], [nomType]) VALUES (1, N'officiel')
GO
INSERT [dbo].[type] ([idType], [nomType]) VALUES (2, N'cup')
GO
INSERT [dbo].[type] ([idType], [nomType]) VALUES (3, N'world')
GO
INSERT [dbo].[type] ([idType], [nomType]) VALUES (4, N'Entraînement')
GO
SET IDENTITY_INSERT [dbo].[type] OFF
GO
ALTER TABLE [dbo].[Adherents] ADD  CONSTRAINT [DF_Adherents_NbEvenement]  DEFAULT ((0)) FOR [NbEvenement]
GO
ALTER TABLE [dbo].[Aborder]  WITH CHECK ADD FOREIGN KEY([idReunion])
REFERENCES [dbo].[Reunion] ([idReunion])
GO
ALTER TABLE [dbo].[Aborder]  WITH CHECK ADD FOREIGN KEY([idSujet])
REFERENCES [dbo].[Sujet] ([idSujet])
GO
ALTER TABLE [dbo].[AdherentsPresents]  WITH CHECK ADD  CONSTRAINT [FK__Adherents__idAdh__5CD6CB2B] FOREIGN KEY([idAdherents])
REFERENCES [dbo].[Adherents] ([idAdherents])
GO
ALTER TABLE [dbo].[AdherentsPresents] CHECK CONSTRAINT [FK__Adherents__idAdh__5CD6CB2B]
GO
ALTER TABLE [dbo].[AdherentsPresents]  WITH CHECK ADD FOREIGN KEY([idReunion])
REFERENCES [dbo].[Reunion] ([idReunion])
GO
ALTER TABLE [dbo].[Appel]  WITH CHECK ADD  CONSTRAINT [FK__Appel__idAdheren__5535A963] FOREIGN KEY([idAdherents])
REFERENCES [dbo].[Adherents] ([idAdherents])
GO
ALTER TABLE [dbo].[Appel] CHECK CONSTRAINT [FK__Appel__idAdheren__5535A963]
GO
ALTER TABLE [dbo].[Appel]  WITH CHECK ADD FOREIGN KEY([idEvenement])
REFERENCES [dbo].[Evenements] ([idEvenement])
GO
ALTER TABLE [dbo].[contenuMessage]  WITH CHECK ADD  CONSTRAINT [FK__contenuMe__idAdh__5165187F] FOREIGN KEY([idAdherents])
REFERENCES [dbo].[Adherents] ([idAdherents])
GO
ALTER TABLE [dbo].[contenuMessage] CHECK CONSTRAINT [FK__contenuMe__idAdh__5165187F]
GO
ALTER TABLE [dbo].[contenuMessage]  WITH CHECK ADD FOREIGN KEY([idMessage])
REFERENCES [dbo].[Message] ([idMessage])
GO
ALTER TABLE [dbo].[dirigeant]  WITH CHECK ADD  CONSTRAINT [FK__dirigeant__idAdh__45F365D3] FOREIGN KEY([idAdherents])
REFERENCES [dbo].[Adherents] ([idAdherents])
GO
ALTER TABLE [dbo].[dirigeant] CHECK CONSTRAINT [FK__dirigeant__idAdh__45F365D3]
GO
ALTER TABLE [dbo].[Evenements]  WITH CHECK ADD FOREIGN KEY([idLieu])
REFERENCES [dbo].[Lieux] ([idLieu])
GO
ALTER TABLE [dbo].[Evenements]  WITH CHECK ADD FOREIGN KEY([idType])
REFERENCES [dbo].[type] ([idType])
GO
ALTER TABLE [dbo].[Joueur]  WITH CHECK ADD  CONSTRAINT [FK__Joueur__idAdhere__4316F928] FOREIGN KEY([idAdherents])
REFERENCES [dbo].[Adherents] ([idAdherents])
GO
ALTER TABLE [dbo].[Joueur] CHECK CONSTRAINT [FK__Joueur__idAdhere__4316F928]
GO
ALTER TABLE [dbo].[Remplacant]  WITH CHECK ADD FOREIGN KEY([idAdherents])
REFERENCES [dbo].[Joueur] ([idAdherents])
GO
ALTER TABLE [dbo].[rencontreEquipe]  WITH CHECK ADD FOREIGN KEY([idEquipe])
REFERENCES [dbo].[Equipe] ([idEquipe])
GO
ALTER TABLE [dbo].[rencontreEquipe]  WITH CHECK ADD FOREIGN KEY([idEvenement])
REFERENCES [dbo].[Evenements] ([idEvenement])
GO
/****** Object:  StoredProcedure [dbo].[AdherentsRenouveles]    Script Date: 10/04/2025 15:13:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AdherentsRenouveles]
as
    SELECT nom, prenom, dateAdhesion
    FROM Adherents
    WHERE YEAR(dateAdhesion) = YEAR(Getdate());

GO
/****** Object:  StoredProcedure [dbo].[EvenementsParAdherent]    Script Date: 10/04/2025 15:13:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[EvenementsParAdherent](@adherentID INT)
as
    SELECT nom, prenom, nomEvenement,descriptionEvenement, presence
    FROM Adherents 
    JOIN Appel  ON Adherents.idAdherents = Appel.idAdherents
    JOIN Evenements  ON Appel.idEvenement = Evenements.idEvenement
    WHERE Adherents.idAdherents = @adherentID;
GO
/****** Object:  StoredProcedure [dbo].[HeuresEntrainementParJoueur]    Script Date: 10/04/2025 15:13:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[HeuresEntrainementParJoueur]
as
    SELECT nom, prenom, sum(datediff(minute, heureDebut, heureFin)) AS totalMinutes
    FROM Adherents 
    JOIN Appel  ON Adherents.idAdherents = Appel.idAdherents
    JOIN Evenements  ON Appel.idEvenement = Evenements.idEvenement
	JOIN type ON Evenements.idType = type.idType
    WHERE type.nomType  LIKE '%Entraînement'
	GROUP by nom,prenom;
GO
/****** Object:  StoredProcedure [dbo].[NbEvenementsParJoueur]    Script Date: 10/04/2025 15:13:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[NbEvenementsParJoueur](@joueurID INT, @dateDebut DATE, @dateFin DATE)
as
    SELECT COUNT(*) AS nombreEvenements
    FROM Appel 
    JOIN Evenements  ON Appel.idEvenement = Evenements.idEvenement
    WHERE Appel.idAdherents = @joueurID AND Appel.presence = 1
    AND Evenements.dateEvenement BETWEEN @dateDebut AND @dateFin;
GO
/****** Object:  StoredProcedure [dbo].[PointsTraiterReunion]    Script Date: 10/04/2025 15:13:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PointsTraiterReunion](@dateReunion date)
AS
    SELECT nomReunion, typeDeSujet, Sujet.description
    FROM Reunion 
    JOIN Aborder  ON Reunion.idReunion = Aborder.idReunion
    JOIN Sujet  ON Aborder.idSujet = Sujet.idSujet
    WHERE Reunion.dateReunion = @dateReunion;
GO
/****** Object:  Trigger [dbo].[DateAdhesion]    Script Date: 10/04/2025 15:13:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[DateAdhesion]
ON [dbo].[Adherents]
AFTER INSERT
AS


    -- Met à jour la colonne Email avec le format nom.prenom@gmail.com
		UPDATE Adherents
		SET dateAdhesion = GETDATE()
		FROM Adherents ;
GO
ALTER TABLE [dbo].[Adherents] ENABLE TRIGGER [DateAdhesion]
GO
/****** Object:  Trigger [dbo].[GenerateEmail]    Script Date: 10/04/2025 15:13:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[GenerateEmail]
ON [dbo].[Adherents]
AFTER INSERT
AS


    -- Met à jour la colonne Email avec le format nom.prenom@gmail.com
		UPDATE Adherents
		SET mail = LOWER(nom) + '.' + LOWER(prenom) + '@gmail.com'
		FROM Adherents ;
GO
ALTER TABLE [dbo].[Adherents] DISABLE TRIGGER [GenerateEmail]
GO
/****** Object:  Trigger [dbo].[HashPassword]    Script Date: 10/04/2025 15:13:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[HashPassword]
ON [dbo].[Adherents]
AFTER INSERT , UPDATE
AS
    -- Met à jour les mots de passe insérés ou modifiés avec leur version hachée
    UPDATE Adherents
    SET password =  CONVERT(VARCHAR(128), HASHBYTES('SHA2_512', inserted.nom))
    FROM Adherents , inserted 
	where Adherents.idAdherents = inserted.idAdherents;
  
GO
ALTER TABLE [dbo].[Adherents] ENABLE TRIGGER [HashPassword]
GO
/****** Object:  Trigger [dbo].[HistoAdherents]    Script Date: 10/04/2025 15:13:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[HistoAdherents]
ON [dbo].[Adherents]
FOR DELETE
AS
INSERT INTO HistoAdh (DateHisto, nom, prenom, mail, adresse, dateAdhesion,age,nbEvenement)
SELECT GetDate(),nom, prenom, mail, adresse, dateAdhesion,age,nbEvenement
FROM deleted
GO
ALTER TABLE [dbo].[Adherents] DISABLE TRIGGER [HistoAdherents]
GO
/****** Object:  Trigger [dbo].[NomEnMaj]    Script Date: 10/04/2025 15:13:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[NomEnMaj]
ON [dbo].[Adherents]
FOR INSERT
AS
UPDATE Adherents
SET nom = UPPER(inserted.nom)
FROM Adherents, inserted
WHERE Adherents.nom = inserted.nom
GO
ALTER TABLE [dbo].[Adherents] DISABLE TRIGGER [NomEnMaj]
GO
/****** Object:  Trigger [dbo].[NbEvenementsParAdherent]    Script Date: 10/04/2025 15:13:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[NbEvenementsParAdherent]
ON [dbo].[Appel]
FOR UPDATE 
AS
    -- Met à jour une colonne 'nbEvenements' (à ajouter dans Adherents si nécessaire)
    UPDATE Adherents
    SET NbEvenement = (SELECT COUNT(*) 
                        FROM Appel 
                        WHERE presence = 1 and Appel.idAdherents = Adherents.idAdherents );
    
GO
ALTER TABLE [dbo].[Appel] ENABLE TRIGGER [NbEvenementsParAdherent]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Evenements"
            Begin Extent = 
               Top = 7
               Left = 48
               Bottom = 170
               Right = 290
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Appel"
            Begin Extent = 
               Top = 7
               Left = 338
               Bottom = 148
               Right = 532
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Adherents"
            Begin Extent = 
               Top = 7
               Left = 580
               Bottom = 170
               Right = 774
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'EvenementsPersonnesPresentes'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'EvenementsPersonnesPresentes'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Adherents"
            Begin Extent = 
               Top = 7
               Left = 48
               Bottom = 170
               Right = 242
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "dirigeant"
            Begin Extent = 
               Top = 7
               Left = 290
               Bottom = 170
               Right = 484
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Joueur"
            Begin Extent = 
               Top = 7
               Left = 532
               Bottom = 170
               Right = 726
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1176
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1356
         SortOrder = 1416
         GroupBy = 1350
         Filter = 1356
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'ListeAdherents'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'ListeAdherents'
GO
