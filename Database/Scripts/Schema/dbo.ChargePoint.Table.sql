SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ChargePoint](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[UUID] [nvarchar](100) NOT NULL,
	[ParentChargePointID] [int] NULL,
	[DataProviderID] [int] NOT NULL,
	[DataProvidersReference] [nvarchar](100) NULL,
	[OperatorID] [int] NULL,
	[OperatorsReference] [nvarchar](100) NULL,
	[UsageTypeID] [int] NULL,
	[AddressInfoID] [int] NULL,
	[NumberOfPoints] [int] NULL,
	[GeneralComments] [nvarchar](max) NULL,
	[DatePlanned] [smalldatetime] NULL,
	[DateLastConfirmed] [smalldatetime] NULL,
	[StatusTypeID] [int] NULL,
	[DateLastStatusUpdate] [smalldatetime] NULL,
	[DataQualityLevel] [int] NULL,
	[DateCreated] [smalldatetime] NULL,
	[SubmissionStatusTypeID] [int] NULL,
	[UsageCost] [nvarchar](200) NULL,
	[ContributorUserID] [int] NULL,
 CONSTRAINT [PK_ChargePoint] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [IX_ChargePoint] UNIQUE NONCLUSTERED 
(
	[UUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
ALTER TABLE [dbo].[ChargePoint] ADD  CONSTRAINT [DF_ChargePoint_UUID]  DEFAULT (newid()) FOR [UUID]
GO
ALTER TABLE [dbo].[ChargePoint] ADD  CONSTRAINT [DF_ChargePoint_StatusTypeID]  DEFAULT ((0)) FOR [StatusTypeID]
GO
ALTER TABLE [dbo].[ChargePoint] ADD  CONSTRAINT [DF_ChargePoint_DateCreated]  DEFAULT (getdate()) FOR [DateCreated]
GO
ALTER TABLE [dbo].[ChargePoint]  WITH CHECK ADD  CONSTRAINT [FK_ChargePoint_AddressInfo] FOREIGN KEY([AddressInfoID])
REFERENCES [dbo].[AddressInfo] ([ID])
GO
ALTER TABLE [dbo].[ChargePoint] CHECK CONSTRAINT [FK_ChargePoint_AddressInfo]
GO
ALTER TABLE [dbo].[ChargePoint]  WITH CHECK ADD  CONSTRAINT [FK_ChargePoint_ChargePoint] FOREIGN KEY([ParentChargePointID])
REFERENCES [dbo].[ChargePoint] ([ID])
GO
ALTER TABLE [dbo].[ChargePoint] CHECK CONSTRAINT [FK_ChargePoint_ChargePoint]
GO
ALTER TABLE [dbo].[ChargePoint]  WITH CHECK ADD  CONSTRAINT [FK_ChargePoint_DataProvider] FOREIGN KEY([DataProviderID])
REFERENCES [dbo].[DataProvider] ([ID])
GO
ALTER TABLE [dbo].[ChargePoint] CHECK CONSTRAINT [FK_ChargePoint_DataProvider]
GO
ALTER TABLE [dbo].[ChargePoint]  WITH CHECK ADD  CONSTRAINT [FK_ChargePoint_Operator] FOREIGN KEY([OperatorID])
REFERENCES [dbo].[Operator] ([ID])
GO
ALTER TABLE [dbo].[ChargePoint] CHECK CONSTRAINT [FK_ChargePoint_Operator]
GO
ALTER TABLE [dbo].[ChargePoint]  WITH CHECK ADD  CONSTRAINT [FK_ChargePoint_StatusType] FOREIGN KEY([StatusTypeID])
REFERENCES [dbo].[StatusType] ([ID])
GO
ALTER TABLE [dbo].[ChargePoint] CHECK CONSTRAINT [FK_ChargePoint_StatusType]
GO
ALTER TABLE [dbo].[ChargePoint]  WITH CHECK ADD  CONSTRAINT [FK_ChargePoint_SubmissionStatusType] FOREIGN KEY([SubmissionStatusTypeID])
REFERENCES [dbo].[SubmissionStatusType] ([ID])
GO
ALTER TABLE [dbo].[ChargePoint] CHECK CONSTRAINT [FK_ChargePoint_SubmissionStatusType]
GO
ALTER TABLE [dbo].[ChargePoint]  WITH CHECK ADD  CONSTRAINT [FK_ChargePoint_UsageType] FOREIGN KEY([UsageTypeID])
REFERENCES [dbo].[UsageType] ([ID])
GO
ALTER TABLE [dbo].[ChargePoint] CHECK CONSTRAINT [FK_ChargePoint_UsageType]
GO
ALTER TABLE [dbo].[ChargePoint]  WITH CHECK ADD  CONSTRAINT [FK_ChargePoint_User] FOREIGN KEY([ContributorUserID])
REFERENCES [dbo].[User] ([ID])
GO
ALTER TABLE [dbo].[ChargePoint] CHECK CONSTRAINT [FK_ChargePoint_User]
GO
