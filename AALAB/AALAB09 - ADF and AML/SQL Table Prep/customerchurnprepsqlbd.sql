IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'PredictedChurnCustomer')
DROP TABLE [dbo].[PredictedChurnCustomer];
GO

IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_NAME = 'spOverwritePredictedCustomerChurndata' AND ROUTINE_SCHEMA = 'dbo' AND ROUTINE_TYPE = 'PROCEDURE')
EXEC ('DROP PROCEDURE spOverwritePredictedCustomerChurndata')
GO

IF EXISTS (SELECT * FROM SYS.TYPES WHERE NAME = 'PredictedChurnCustomerDataType ' AND IS_TABLE_TYPE = 1)
DROP TYPE [dbo].[PredictedChurnCustomerDataType];
GO

--Create Type
CREATE TYPE [dbo].PredictedChurnCustomerDataType AS TABLE(
			Age int,
            AnnualIncome int,
            CallDropRate nvarchar(255),
            CallFailureRate nvarchar(255),
			CallingNum nvarchar(255),
			CustomerID nvarchar(255),
            CustomerSuspended nvarchar(255),
            Education nvarchar(255),
            Gender nvarchar(255),
            HomeOwner nvarchar(255),
            MaritalStatus nvarchar(255),
            MonthlyBilledAmount int,
            NoAdditionalLines nvarchar(255),
            NumberOfComplaints int,
            NumberOfMonthUnpaid int,
            NumDaysContractEquipmentPlanExpiring int,
            Occupation nvarchar(255),
            PenaltyToSwitch nvarchar(255),
            [State] nvarchar(255),
            TotalMinsUsedInLastMonth int,
            UnpaidBalance int,
            UsesInternetService nvarchar(255),
            UsesVoiceService nvarchar(255),
            PercentageCallOutsideNetwork nvarchar(255),
            Totalcallduration int,
            AvgCallduration int,
			[ScoredLabel] nvarchar(50),
			[ScoredProbability] float
)
GO

--CREATE STORED PROCEDURE
CREATE PROCEDURE spOverwritePredictedCustomerChurndata @PredictedChurnCustomer [dbo].PredictedChurnCustomerDataType READONLY
AS
BEGIN
    DELETE FROM [dbo].[PredictedChurnCustomer]
    INSERT [dbo].[PredictedChurnCustomer]
	(
		Age,
		AnnualIncome,
		CallDropRate,
		CallFailureRate,
		CallingNum,
		CustomerID,
		CustomerSuspended,
		Education,
		Gender,
		HomeOwner,
		MaritalStatus,
		MonthlyBilledAmount,
		NoAdditionalLines,
		NumberOfComplaints,
		NumberOfMonthUnpaid,
		NumDaysContractEquipmentPlanExpiring,
		Occupation,
		PenaltyToSwitch,
		[State],
		TotalMinsUsedInLastMonth,
		UnpaidBalance,
		UsesInternetService,
		UsesVoiceService,
		PercentageCallOutsideNetwork,
		Totalcallduration,
		AvgCallduration,
		[ScoredLabel],
		[ScoredProbability]
	)
    SELECT * FROM @PredictedChurnCustomer
END
GO

CREATE TABLE [dbo].[PredictedChurnCustomer](
	[ID] [int] IDENTITY(1,1) NOT NULL,
			Age int,
            AnnualIncome int,
            CallDropRate nvarchar(255),
            CallFailureRate nvarchar(255),
			CallingNum nvarchar(255),
			CustomerID nvarchar(255),
            CustomerSuspended nvarchar(255),
            Education nvarchar(255),
            Gender nvarchar(255),
            HomeOwner nvarchar(255),
            MaritalStatus nvarchar(255),
            MonthlyBilledAmount int,
            NoAdditionalLines nvarchar(255),
            NumberOfComplaints int,
            NumberOfMonthUnpaid int,
            NumDaysContractEquipmentPlanExpiring int,
            Occupation nvarchar(255),
            PenaltyToSwitch nvarchar(255),
            [State] nvarchar(255),
            TotalMinsUsedInLastMonth int,
            UnpaidBalance int,
            UsesInternetService nvarchar(255),
            UsesVoiceService nvarchar(255),
            PercentageCallOutsideNetwork nvarchar(255),
            Totalcallduration int,
            AvgCallduration int,
			[ScoredLabel] nvarchar(50),
			[ScoredProbability] float
 CONSTRAINT [PrimaryKey_c1959c67-9750-4fda-a492-66771f90c9c5] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
);
