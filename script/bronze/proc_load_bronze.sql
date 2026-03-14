/*
===================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
===================================================================

Script Purpose:
This stored procedure loads data into the 'bronze' schema from external CSV files.
It performs the following actions:

- Truncates the bronze tables before loading data.
- Uses the `BULK INSERT` command to load data from CSV files to bronze tables.

Parameters:
None.
This stored procedure does not accept any parameters or return any values.

Usage Example:
EXEC bronze.load_bronze;

===================================================================
*/ 
CREATE OR ALTER PROCEDURE bronze.load_bronze
AS
BEGIN 
DECLARE @start_time DATETIME, @end_time  DATETIME,@batch_start_time DATETIME, @batch_end_time DATETIME;
BEGIN TRY 
SET @batch_start_time = GETDATE();
IF OBJECT_ID('bronze.crm_cust_info','U') IS NOT NULL 
		DROP TABLE bronze.crm_cust_info;

	CREATE TABLE bronze.crm_cust_info(
		cst_id INT,
		cst_key NVARCHAR(50),
		cst_firstname NVARCHAR(50),
		cst_lastname NVARCHAR(50),
		cst_marital_status NVARCHAR(50),
		cst_gndr NVARCHAR(50),
		cst_create_date DATE 
		);
	IF OBJECT_ID('bronze.crm_prd_info','U') IS NOT NULL 
		DROP TABLE bronze.crm_prd_info;
	CREATE TABLE bronze.crm_prd_info( 
			prd_info INT,
			prd_key NVARCHAR(50),
			prd_nm NVARCHAR(50),
			prd_cost INT,
			prd_line NVARCHAR(50),
			prd_start_dt DATETIME,
			prd_end_dt DATETIME);

	IF OBJECT_ID('bronze.crm_sales_details','U') IS NOT NULL 
		DROP TABLE bronze.crm_sales_details;
	CREATE TABLE bronze.crm_sales_details( 
		sls_ord_num NVARCHAR(50),
		sls_prd_key NVARCHAR(50),
		sls_cust_id INT,
		sls_order_dt INT,
		sls_ship_dt INT,
		sls_due_dt INT,
		sls_sales INT,
		sls_quantity INT,
		sls_price INT);

		IF OBJECT_ID('bronze.erp_CUST_AZ12','U') IS NOT NULL 
		DROP TABLE bronze.erp_CUST_AZ12;

	CREATE TABLE bronze.erp_CUST_AZ12(
		CID VARCHAR(50),
		BDATE DATE,
		GEN VARCHAR (50));

		IF OBJECT_ID('bronze.erp_LOC_A101','U') IS NOT NULL 
		DROP TABLE bronze.erp_LOC_A101;

	CREATE TABLE bronze.erp_LOC_A101(
		CID VARCHAR(50),
		Cntry VARCHAR (50)); 

		IF OBJECT_ID('bronze.erp_px_cat_glv2','U') IS NOT NULL 
		DROP TABLE bronze.erp_px_cat_glv2;

	CREATE TABLE bronze.erp_px_cat_glv2(
		id VARCHAR(50),
		cat VARCHAR (50),
		subcat VARCHAR (50),
		maintenance varchar(50));  


     PRINT '================================='
	 PRINT 'Loading Bronze layer'
	 PRINT '================================='

	 PRINT '-------------------------------'
	 PRINT 'LOADING CRM TABLES'
	 PRINT '-------------------------------' 

	SET @start_time = GETDATE();
	PRINT '>> TRUNCATING TABLE: bronze.crm_cust_info'
     TRUNCATE TABLE bronze.crm_cust_info;

		PRINT '>> INSERTING DATA INFO : bronze.crm_cust_info'
		BULK INSERT bronze.crm_cust_info
			FROM 'C:\Users\User\OneDrive - MAIT\Desktop\sql data warehouse project\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
			WITH ( 
				FIRSTROW = 2,
				FIELDTERMINATOR = ',',
				TABLOCK
				);
		     SET @end_time = GETDATE();
			 PRINT '>> Time taken to load bronze.crm_cust_info: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';

			SET @start_time = GETDATE();
			PRINT '>> TRUNCATING TABLE: bronze.crm_prd_info'
			TRUNCATE TABLE bronze.crm_prd_info; 

			PRINT '>> INSERTING DATA INFO : bronze.crm_prd_info'
			BULK INSERT bronze.crm_prd_info
			FROM 'C:\Users\User\OneDrive - MAIT\Desktop\sql data warehouse project\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
			WITH ( 
				FIRSTROW = 2,
				FIELDTERMINATOR = ',',
				TABLOCK
				);
				SET @end_time = GETDATE();
				PRINT '>> Time taken to load bronze.crm_prd_info: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';


            SET @start_time = GETDATE(); 
			PRINT '>> TRUNCATING TABLE: bronze.crm_sales_details'
			TRUNCATE TABLE bronze.crm_sales_details;

			PRINT '>> INSERTING DATA INFO : bronze.crm_sales_details'
			BULK INSERT bronze.crm_sales_details
			FROM 'C:\Users\User\OneDrive - MAIT\Desktop\sql data warehouse project\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
			WITH ( 
				FIRSTROW = 2,
				FIELDTERMINATOR = ',',
				TABLOCK
				);
				SET @end_time = GETDATE();
				PRINT '>> Time taken to load bronze.crm_sales_details: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';

		 PRINT '-------------------------------'
		 PRINT 'LOADING ERP TABLES'
		 PRINT '-------------------------------'

		SET @start_time = GETDATE();
		PRINT '>> TRUNCATING TABLE: bronze.erp_CUST_AZ12'
		TRUNCATE TABLE bronze.erp_CUST_AZ12;

			PRINT '>> INSERTING DATA INFO : bronze.erp_CUST_AZ12'	
			BULK INSERT bronze.erp_CUST_AZ12
			FROM 'C:\Users\User\OneDrive - MAIT\Desktop\sql data warehouse project\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
			WITH ( 
				FIRSTROW = 2,
				FIELDTERMINATOR = ',',
				TABLOCK
				);
				SET @end_time = GETDATE();
				PRINT '>> Time taken to load bronze.erp_CUST_AZ12: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';

		SET @start_time = GETDATE();
		PRINT '>> TRUNCATING TABLE: bronze.erp_LOC_A101'
		TRUNCATE TABLE bronze.erp_LOC_A101;
		
			PRINT '>> INSERTING DATA INFO : bronze.erp_LOC_A101'
			BULK INSERT bronze.erp_LOC_A101
			FROM 'C:\Users\User\OneDrive - MAIT\Desktop\sql data warehouse project\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
			WITH ( 
				FIRSTROW = 2,
				FIELDTERMINATOR = ',',
				TABLOCK
				); 
				SET @end_time = GETDATE();
				PRINT '>> Time taken to load bronze.erp_LOC_A101: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';

		SET @start_time = GETDATE();
		PRINT '>> TRUNCATING TABLE: bronze.erp_px_cat_glv2'
		TRUNCATE TABLE bronze.erp_px_cat_glv2;

		PRINT '>> INSERTING DATA INFO : bronze.erp_px_cat_glv2'
		BULK INSERT bronze.erp_px_cat_glv2
			FROM 'C:\Users\User\OneDrive - MAIT\Desktop\sql data warehouse project\sql-data-warehouse-project\datasets\source_erp\px_cat_glv2.csv'
			WITH ( 
				FIRSTROW = 2,
				FIELDTERMINATOR = ',',
				TABLOCK
				);
				SET @end_time = GETDATE();
				PRINT '>> Time taken to load bronze.erp_px_cat_glv2: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
				PRINT '>>------------------------'
				SET @batch_end_time = GETDATE();
				PRINT '============================='
				PRINT '>> Total time taken to load data into bronze layer: ' + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds';
				PRINT '============================='
				END TRY
				BEGIN CATCH
				PRINT '======================================================='
				PRINT 'Error occurred while loading data into bronze layer: '
				PRINT 'Error message' + ERROR_MESSAGE();
				PRINT 'Error message' + CAST(ERROR_NUMBER() AS NVARCHAR);
				PRINT 'Error message' + CAST(ERROR_STATE() AS NVARCHAR);
				PRINT 'Error message' + CAST(ERROR_SEVERITY() AS NVARCHAR);
				PRINT '======================================================='
				END CATCH
				
			END
        GO 
        EXEC bronze.load_bronze;
