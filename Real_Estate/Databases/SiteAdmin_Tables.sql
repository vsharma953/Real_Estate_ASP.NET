-- ============================================================
--  Agents table  (SiteAdmin > Manage Agents  /  Agent Desk login)
-- ============================================================
IF OBJECT_ID('dbo.Agents', 'U') IS NULL
CREATE TABLE [dbo].[Agents] (
    [AgentID]  INT            IDENTITY (1, 1) NOT NULL,
    [FullName] NVARCHAR (100) NOT NULL,
    [Email]    NVARCHAR (150) NOT NULL,
    [Phone]    NVARCHAR (20)  NOT NULL DEFAULT '',
    [Password] NVARCHAR (100) NOT NULL,
    [Status]   NVARCHAR (20)  NOT NULL DEFAULT 'Active',
    PRIMARY KEY CLUSTERED ([AgentID] ASC)
);
GO

-- ============================================================
--  Also used by the same pages
-- ============================================================

-- Site Admin login (/SiteAdmin/Login.aspx)
IF OBJECT_ID('dbo.SiteAdmins', 'U') IS NULL
CREATE TABLE [dbo].[SiteAdmins] (
    [AdminID]  INT            IDENTITY (1, 1) NOT NULL,
    [Email]    NVARCHAR (150) NOT NULL,
    [Password] NVARCHAR (100) NOT NULL,
    PRIMARY KEY CLUSTERED ([AdminID] ASC)
);
GO

-- links every property to the agent who listed it
IF COL_LENGTH('dbo.Properties', 'AgentID') IS NULL
ALTER TABLE [dbo].[Properties] ADD [AgentID] INT NULL;
GO

-- ============================================================
--  First logins (same as before)
-- ============================================================
IF NOT EXISTS (SELECT * FROM [dbo].[Agents] WHERE Email = 'admin@realestate.luxury')
INSERT INTO [dbo].[Agents] (FullName, Email, Phone, Password, Status)
VALUES ('Julian Vance', 'admin@realestate.luxury', '', 'admin123', 'Active');

IF NOT EXISTS (SELECT * FROM [dbo].[SiteAdmins] WHERE Email = 'siteadmin@realestate.luxury')
INSERT INTO [dbo].[SiteAdmins] (Email, Password)
VALUES ('siteadmin@realestate.luxury', 'siteadmin123');
GO

-- run once: properties that were listed before agents existed go to the first agent
UPDATE [dbo].[Properties] SET AgentID = (SELECT MIN(AgentID) FROM [dbo].[Agents]) WHERE AgentID IS NULL;
GO
