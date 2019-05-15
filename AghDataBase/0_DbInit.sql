/* 
# Wymagania

## Jedna opłata za całaość konferencję, ale można wybrać na których dniach uczestnik się pojawi

## Każda ulica ma unikalny zip-code

## 

*/

/* 
# TODOS

## Numer Mieszkania - DONE M.

*/
USE [master]
GO
ALTER DATABASE AghDataBase SET SINGLE_USER WITH ROLLBACK IMMEDIATE
GO

/* Query to Drop Database in SQL Server  */
PRINT('Dropping database...')
DROP DATABASE AghDataBase
GO
CREATE DATABASE AghDataBase