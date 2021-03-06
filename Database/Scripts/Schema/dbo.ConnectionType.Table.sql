SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ConnectionType](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](200) NOT NULL,
	[FormalName] [nvarchar](200) NULL,
	[IsDiscontinued] [bit] NULL,
	[IsObsolete] [bit] NULL,
 CONSTRAINT [PK_ConnectionType] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
ALTER TABLE [dbo].[ConnectionType] ADD  CONSTRAINT [DF_ConnectionType_IsDiscontinued]  DEFAULT ((0)) FOR [IsDiscontinued]
GO
ALTER TABLE [dbo].[ConnectionType] ADD  CONSTRAINT [DF_ConnectionType_IsObsolete]  DEFAULT ((0)) FOR [IsObsolete]
GO
