USE [s16guest19]
GO
/****** Object:  User [s16guest19]    Script Date: 4/29/2016 2:59:40 PM ******/
CREATE USER [s16guest19] FOR LOGIN [s16guest19] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_owner] ADD MEMBER [s16guest19]
GO
/****** Object:  StoredProcedure [dbo].[AddProduct]    Script Date: 4/29/2016 2:59:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[AddProduct]
(
  @ProductName nvarchar(50),
  @Desc nvarchar(50)
)
AS
begin
begin try
insert into Product ([Product Name],[Description])
values (@ProductName, @Desc)
end  try

begin catch

print 'not able to create new product!'
end catch
 end

GO
/****** Object:  StoredProcedure [dbo].[NewFeatureCount]    Script Date: 4/29/2016 2:59:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure [dbo].[NewFeatureCount]
(
  @VersionID int 
  
)
AS
Begin
 declare @NewFeatureReleaseID float
 declare @sum  int
 declare @VersionNum nchar(10)

 set  @NewFeatureReleaseID = (select [Release ID] from Release
 where [Release Type] = 'new features release') 
 
 begin try


      set @VersionNum = (select [Version number] from PVersion 
                     where [Version ID] = @VersionID)

	  set @sum = (select count([Feature ID]) 
               from [dbo].[Version_FeatureID_Release] 
			   where [Release ID] = @NewFeatureReleaseID AND
			         [Version ID] = @VersionID )
			   
			   



	     if @sum >0 
    
            print 'There are ' + (convert(varchar(8), @sum)) + 'new features in the' 
	        + @VersionNum + 'release.'
   
        else print 'It is  bug fix release. There are no new feature.'

end  try

 begin catch
  
  DECLARE
   @ErMessage NVARCHAR(2048),
   @ErSeverity INT,
   @ErState INT
 
 SELECT
   @ErMessage = ERROR_MESSAGE(),
   @ErSeverity = ERROR_SEVERITY(),
   @ErState = ERROR_STATE()
 
 RAISERROR (@ErMessage,
             @ErSeverity,
             @ErState )


end catch

END
GO
/****** Object:  StoredProcedure [dbo].[ProductVersionUpdate]    Script Date: 4/29/2016 2:59:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[ProductVersionUpdate]
(
@ProductName nvarchar(20),
@ProductID int,
@versionID int,
@versionNumber nchar(10)

)
AS
Begin
select @ProductID = [Product ID] from Product where [Product Name] = @ProductName
select @versionID = [Version ID] from Version_Product where [Product ID] = @ProductID
 
update PVersion 
set [Version number] = @versionNumber  where [Version ID] = @versionID 

END;


GO
/****** Object:  StoredProcedure [dbo].[RequestCount]    Script Date: 4/29/2016 2:59:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- procedure to count and report the number of requests with the version ID
create procedure [dbo].[RequestCount] 

 AS  
 begin
    begin TRY
    select  Product.[Product Name], PVersion.[Version number],  month(Request.[Date]) , count(Request.[Customer ID])
    from Request, Product, PVersion, Version_Product 
	group by [Product Name], [Version number], [Date] 
    Order by [Date] , count([Customer ID]) 
    end TRY

  begin catch

  print 'Error'
  end catch

end 

GO
/****** Object:  Table [dbo].[Address]    Script Date: 4/29/2016 2:59:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Address](
	[Address ID] [int] IDENTITY(1,1) NOT NULL,
	[Company ID] [int] NOT NULL,
	[Street number] [nvarchar](50) NOT NULL,
	[City] [nchar](20) NOT NULL,
	[ZipCode] [int] NULL,
	[Country] [nchar](20) NOT NULL,
 CONSTRAINT [PK_Address] PRIMARY KEY CLUSTERED 
(
	[Address ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Branch]    Script Date: 4/29/2016 2:59:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Branch](
	[Branch ID] [int] IDENTITY(1,1) NOT NULL,
	[Release ID] [float] NOT NULL,
 CONSTRAINT [PK_Branch] PRIMARY KEY CLUSTERED 
(
	[Branch ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Company]    Script Date: 4/29/2016 2:59:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Company](
	[Company ID] [int] IDENTITY(1,1) NOT NULL,
	[Company Name] [nchar](50) NOT NULL,
 CONSTRAINT [PK_Company] PRIMARY KEY CLUSTERED 
(
	[Company ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ContactNo]    Script Date: 4/29/2016 2:59:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ContactNo](
	[Contact ID] [int] IDENTITY(1,1) NOT NULL,
	[Country Code] [nchar](5) NOT NULL,
	[Work] [nchar](16) NULL,
	[Cell_Mobile] [nchar](16) NULL,
 CONSTRAINT [PK_Contact No] PRIMARY KEY CLUSTERED 
(
	[Contact ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Customer]    Script Date: 4/29/2016 2:59:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Customer](
	[Customer ID] [int] IDENTITY(1,1) NOT NULL,
	[Last name] [nchar](20) NOT NULL,
	[First name] [nchar](20) NOT NULL,
 CONSTRAINT [PK_Customer] PRIMARY KEY CLUSTERED 
(
	[Customer ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Customer_Company]    Script Date: 4/29/2016 2:59:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Customer_Company](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Customer ID] [int] NOT NULL,
	[Company ID] [int] NOT NULL,
	[Contact ID] [int] NOT NULL,
	[Email] [nchar](50) NOT NULL,
 CONSTRAINT [PK_Customer_Company_1] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Downloadable_version]    Script Date: 4/29/2016 2:59:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Downloadable_version](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Version ID] [int] NOT NULL,
	[Release ID] [float] NOT NULL,
	[Weblink] [nvarchar](max) NOT NULL,
 CONSTRAINT [PK_Downloadable version] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Features]    Script Date: 4/29/2016 2:59:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Features](
	[Feature ID] [int] IDENTITY(1,1) NOT NULL,
	[Feature Name] [nvarchar](50) NOT NULL,
	[Feature Descriptions] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_Features] PRIMARY KEY CLUSTERED 
(
	[Feature ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Iteration]    Script Date: 4/29/2016 2:59:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Iteration](
	[Iteration ID] [int] IDENTITY(1,1) NOT NULL,
	[Iteration Lable] [nvarchar](50) NOT NULL,
	[Version ID] [int] NOT NULL,
 CONSTRAINT [PK_Iteration] PRIMARY KEY CLUSTERED 
(
	[Iteration ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Product]    Script Date: 4/29/2016 2:59:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Product](
	[Product ID] [int] IDENTITY(1,1) NOT NULL,
	[Product Name] [nvarchar](50) NOT NULL,
	[Description] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_Product] PRIMARY KEY CLUSTERED 
(
	[Product ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[PVersion]    Script Date: 4/29/2016 2:59:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PVersion](
	[Version ID] [int] IDENTITY(1,1) NOT NULL,
	[Version number] [nchar](10) NOT NULL,
 CONSTRAINT [PK_PVersion] PRIMARY KEY CLUSTERED 
(
	[Version ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Release]    Script Date: 4/29/2016 2:59:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Release](
	[Release ID] [float] NOT NULL,
	[Release Date] [date] NOT NULL,
	[Release Type] [nchar](50) NOT NULL,
 CONSTRAINT [PK_Release] PRIMARY KEY CLUSTERED 
(
	[Release ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Request]    Script Date: 4/29/2016 2:59:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Request](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Customer ID] [int] NOT NULL,
	[Version ID] [int] NOT NULL,
	[Date] [datetime] NOT NULL,
 CONSTRAINT [PK_Request] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Version_FeatureID_Release]    Script Date: 4/29/2016 2:59:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Version_FeatureID_Release](
	[Release ID] [float] NOT NULL,
	[Version ID] [int] NOT NULL,
	[Feature ID] [int] NOT NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Version_Product]    Script Date: 4/29/2016 2:59:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Version_Product](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Version ID] [int] NOT NULL,
	[Product ID] [int] NOT NULL,
 CONSTRAINT [PK_Version_Product] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
ALTER TABLE [dbo].[Address]  WITH CHECK ADD  CONSTRAINT [FK_Address_Company] FOREIGN KEY([Company ID])
REFERENCES [dbo].[Company] ([Company ID])
GO
ALTER TABLE [dbo].[Address] CHECK CONSTRAINT [FK_Address_Company]
GO
ALTER TABLE [dbo].[Branch]  WITH CHECK ADD  CONSTRAINT [FK_Branch_Release] FOREIGN KEY([Release ID])
REFERENCES [dbo].[Release] ([Release ID])
GO
ALTER TABLE [dbo].[Branch] CHECK CONSTRAINT [FK_Branch_Release]
GO
ALTER TABLE [dbo].[Customer_Company]  WITH CHECK ADD  CONSTRAINT [FK_Customer_Company_Company] FOREIGN KEY([Company ID])
REFERENCES [dbo].[Company] ([Company ID])
GO
ALTER TABLE [dbo].[Customer_Company] CHECK CONSTRAINT [FK_Customer_Company_Company]
GO
ALTER TABLE [dbo].[Customer_Company]  WITH CHECK ADD  CONSTRAINT [FK_Customer_Company_Contact No] FOREIGN KEY([Contact ID])
REFERENCES [dbo].[ContactNo] ([Contact ID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Customer_Company] CHECK CONSTRAINT [FK_Customer_Company_Contact No]
GO
ALTER TABLE [dbo].[Downloadable_version]  WITH CHECK ADD  CONSTRAINT [FK_Downloadable_version_PVersion] FOREIGN KEY([Version ID])
REFERENCES [dbo].[PVersion] ([Version ID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Downloadable_version] CHECK CONSTRAINT [FK_Downloadable_version_PVersion]
GO
ALTER TABLE [dbo].[Downloadable_version]  WITH CHECK ADD  CONSTRAINT [FK_Downloadable_version_Release] FOREIGN KEY([Release ID])
REFERENCES [dbo].[Release] ([Release ID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Downloadable_version] CHECK CONSTRAINT [FK_Downloadable_version_Release]
GO
ALTER TABLE [dbo].[Iteration]  WITH CHECK ADD  CONSTRAINT [FK_Iteration_PVersion] FOREIGN KEY([Version ID])
REFERENCES [dbo].[PVersion] ([Version ID])
GO
ALTER TABLE [dbo].[Iteration] CHECK CONSTRAINT [FK_Iteration_PVersion]
GO
ALTER TABLE [dbo].[Request]  WITH CHECK ADD  CONSTRAINT [FK_Request_Customer] FOREIGN KEY([Customer ID])
REFERENCES [dbo].[Customer] ([Customer ID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Request] CHECK CONSTRAINT [FK_Request_Customer]
GO
ALTER TABLE [dbo].[Request]  WITH CHECK ADD  CONSTRAINT [FK_Request_PVersion] FOREIGN KEY([Version ID])
REFERENCES [dbo].[PVersion] ([Version ID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Request] CHECK CONSTRAINT [FK_Request_PVersion]
GO
ALTER TABLE [dbo].[Version_FeatureID_Release]  WITH CHECK ADD  CONSTRAINT [FK_Version and FeatureID_Features] FOREIGN KEY([Feature ID])
REFERENCES [dbo].[Features] ([Feature ID])
GO
ALTER TABLE [dbo].[Version_FeatureID_Release] CHECK CONSTRAINT [FK_Version and FeatureID_Features]
GO
ALTER TABLE [dbo].[Version_FeatureID_Release]  WITH CHECK ADD  CONSTRAINT [FK_Version and FeatureID_PVersion] FOREIGN KEY([Version ID])
REFERENCES [dbo].[PVersion] ([Version ID])
GO
ALTER TABLE [dbo].[Version_FeatureID_Release] CHECK CONSTRAINT [FK_Version and FeatureID_PVersion]
GO
ALTER TABLE [dbo].[Version_Product]  WITH CHECK ADD  CONSTRAINT [FK_Version_Product_Product] FOREIGN KEY([Product ID])
REFERENCES [dbo].[Product] ([Product ID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Version_Product] CHECK CONSTRAINT [FK_Version_Product_Product]
GO
ALTER TABLE [dbo].[Version_Product]  WITH CHECK ADD  CONSTRAINT [FK_Version_Product_PVersion] FOREIGN KEY([Version ID])
REFERENCES [dbo].[PVersion] ([Version ID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Version_Product] CHECK CONSTRAINT [FK_Version_Product_PVersion]
GO
