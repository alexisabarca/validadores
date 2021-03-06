/****** Object:  Trigger dbo.verif_rut    Script Date: 01/07/03 23:01:09 ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[verif_rut]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [dbo].[verif_rut]
GO


/****** Object:  Trigger dbo.verif_rut    Script Date: 01/07/03 23:01:34 ******/
/*** como se ve en el codigo el rut se saca del atributo rut_cli de la tabla cliente ***/
/*** hay que ingresar el rut completo sin punto y guion (. -)
/*** ejemplo: 12.345.678-9 se ingresaria: 123456789  ***/
/*** ejemplo:  9.876.543-2 se ingresaria: 098765432  (hay que ingresar el 0 ya que siempre son 9 numeros ***/

CREATE TRIGGER verif_rut
ON  [dbo].[cliente]
FOR INSERT
AS
declare @valor int
declare @ruti char(9)
declare @dv char
set @ruti = (select rut_cli from inserted)
set @valor = 0

if (len(@ruti))=9
begin
 set @valor = @valor + convert(int,substring(@ruti,8,1))*2
 set @valor = @valor + convert(int,substring(@ruti,7,1))*3
 set @valor = @valor + convert(int,substring(@ruti,6,1))*4
 set @valor = @valor + convert(int,substring(@ruti,5,1))*5
 set @valor = @valor + convert(int,substring(@ruti,4,1))*6
 set @valor = @valor + convert(int,substring(@ruti,3,1))*7
 set @valor = @valor + convert(int,substring(@ruti,2,1))*2
 set @valor = @valor + convert(int,substring(@ruti,1,1))*3

 set @valor = @valor % 11

 if (@valor = 1)
 begin
   set @dv='k'
 end

 if @valor = 0
 begin
   set @dv='0'
 end

 if @valor>1 and @valor<11
 begin
   set @dv=str(11-@valor,1)
 end

 if @dv<>substring(@ruti,9,1)
 begin
   raiserror('verifique su rut',16,1)
   rollback transaction
 end

end

GO
