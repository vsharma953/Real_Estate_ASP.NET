CREATE TABLE [dbo].[Users] (
    [UserID]   INT            IDENTITY (1, 1) NOT NULL,
    [FullName] NVARCHAR (100) NOT NULL,
    [Email]    NVARCHAR (150) NOT NULL,
    [Phone]    NVARCHAR (20)  NOT NULL,
    [Password] NVARCHAR (100) NOT NULL,
    PRIMARY KEY CLUSTERED ([UserID] ASC)
);

