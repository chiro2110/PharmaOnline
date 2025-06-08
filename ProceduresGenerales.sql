
create proc sp_RegistrarProducto(
@Nombre varchar(100),
@Descripcion varchar(100),
@IdMarca varchar(100),
@IdCategoria varchar(100),
@Precio decimal(10,2),
@Stock int,
@Activo bit,
@Mensaje varchar(500) output,
@Resultado int output
)
as
begin
	SET @Resultado = 0
	IF NOT EXISTS (SELECT * FROM PRODUCTO WHERE Nombre = @Nombre)
	begin
		insert into PRODUCTO(Nombre,Descripcion,IdMarca,IdCategoria,Precio,Stock,Activo) values
		(@Nombre,@Descripcion,@IdMarca,@IdCategoria,@Precio,@Stock,@Activo)

		SET @Resultado = scope_identity()
	end
	else
	 set @Mensaje = 'El producto ya existe'
end

go


create proc sp_EditarProducto(
@IdProducto int,
@Nombre varchar(100),
@Descripcion varchar(100),
@IdMarca varchar(100),
@IdCategoria varchar(100),
@Precio decimal(10,2),
@Stock int,
@Activo bit,
@Mensaje varchar(500) output,
@Resultado bit output
)
as
begin
	SET @Resultado = 0
	IF NOT EXISTS (SELECT * FROM PRODUCTO WHERE Nombre = @Nombre and IdProducto != @IdProducto)
	begin
			
		update PRODUCTO set
		Nombre = @Nombre,
		Descripcion = @Descripcion,
		IdMarca = @IdMarca,
		IdCategoria = @IdCategoria,
		Precio = @Precio,
		Stock = @Stock,
		Activo = @Activo
		where IdProducto = @IdProducto

		SET @Resultado = 1
	end
	else
	 set @Mensaje = 'El producto ya existe'
end

go

create proc sp_EliminarProducto(
@IdProducto int,
@Mensaje varchar(500) output,
@Resultado bit output
)
as
begin
	SET @Resultado = 0
	IF NOT EXISTS (select * from DETALLE_VENTA dv
	inner join PRODUCTO p on p.IdProducto = dv.IdProducto
	where p.IdProducto = @IdProducto)
	begin
		delete top (1) from PRODUCTO where IdProducto = @IdProducto
		SET @Resultado = 1
	end
	else
	 set @Mensaje = 'El producto se encuentra relacionado a una venta'
end

go

Select * from PRODUCTO;

/* ++++++++++++++++++++ PROCEDURES CLIENTES ++++++++++++++++++++++++++ */

create proc sp_RegistrarCliente(
@Nombres varchar(100),
@Apellidos varchar(100),
@Correo varchar(100),
@Clave varchar(100),
@Mensaje varchar(500) output,
@Resultado int output
)
as
begin
	SET @Resultado = 0
	IF NOT EXISTS (SELECT * FROM CLIENTE WHERE Correo = @Correo)
	begin
		insert into CLIENTE(Nombres,Apellidos,Correo,Clave,Reestablecer) values
		(@Nombres,@Apellidos,@Correo,@Clave,0)

		SET @Resultado = scope_identity()
	end
	else
	 set @Mensaje = 'El correo del usuario ya existe'
end

go

/* ++++++++++++++++++++ PROCEDURES CARRITO ++++++++++++++++++++++++++ */

create proc sp_ExisteCarrito(
@IdCliente int,
@IdProducto int,
@Resultado bit output
)
as
begin
    if exists(select * from carrito where idcliente = @IdCliente and idproducto = @IdProducto)
		set @Resultado = 1
    else
		set @Resultado = 0
end

go

create proc sp_OperacionCarrito(
@IdCliente int,
@IdProducto int,
@Sumar bit,
@Mensaje varchar(500) output,
@Resultado bit output
)
as
begin
	set @Resultado = 1
	set @Mensaje = ''

	declare @existecarrito bit = iif(exists(select * from carrito where idcliente = @IdCliente and idproducto = @IdProducto),1,0)
	declare @stockproducto int= (select stock from PRODUCTO where IdProducto = @IdProducto)

	BEGIN TRY

		BEGIN TRANSACTION OPERACION

		if(@Sumar = 1)
		begin

			if(@stockproducto > 0)
			begin
			
				if(@existecarrito = 1)
					update CARRITO set Cantidad = Cantidad + 1 where idcliente = @IdCliente and idproducto = @IdProducto
				else
					insert into CARRITO(IdCliente,IdProducto,Cantidad) values(@IdCliente,@IdProducto,1)

				update PRODUCTO set Stock = Stock - 1 where IdProducto = @IdProducto
			end
			else
			begin
				set @Resultado = 0
				set @Mensaje = 'El producto no cuenta con stock disponible'
			end

		end
		else
		begin
			update CARRITO set Cantidad = Cantidad - 1 where idcliente = @IdCliente and idproducto = @IdProducto
			update PRODUCTO set Stock = Stock + 1 where IdProducto = @IdProducto
		end

		COMMIT TRANSACTION OPERACION


	END TRY
	BEGIN CATCH
		set @Resultado = 0
		set @Mensaje = ERROR_MESSAGE()
		ROLLBACK TRANSACTION OPERACION
	END CATCH


end

go

create FUNCTION fn_obtenerCarritoCliente(
@idcliente int
)
RETURNS TABLE 
AS
RETURN 
(	
	select p.IdProducto,m.Descripcion[DesMarca],p.Nombre,p.Precio,c.Cantidad,p.RutaImagen,p.NombreImagen from CARRITO c
    inner join PRODUCTO p on p.IdProducto = c.IdProducto
    inner join MARCA m on m.IdMarca = p.IdMarca
    where c.IdCliente = @idcliente
)
GO

create proc sp_EliminarCarrito(
@IdCliente int,
@IdProducto int,
@Resultado bit output
)
as
begin

	set @Resultado = 1
	declare @cantidadproducto int = (select Cantidad from CARRITO where IdCliente = @IdCliente and IdProducto = @IdProducto)

	BEGIN TRY

		BEGIN TRANSACTION OPERACION

		update PRODUCTO set Stock = Stock + @cantidadproducto where IdProducto = @IdProducto
		delete top (1) from CARRITO where IdCliente = @IdCliente and IdProducto = @IdProducto

		COMMIT TRANSACTION OPERACION

	END TRY
	BEGIN CATCH
		set @Resultado = 0
		ROLLBACK TRANSACTION OPERACION
	END CATCH

end

GO

/* ++++++++++++++++++++ PROCEDURES VENTA ++++++++++++++++++++++++++ */

CREATE TYPE [dbo].[EDetalle_Venta] AS TABLE(
	[IdProducto] int NULL,
	[Cantidad] int NULL,
	[Total] decimal(18,2) NULL
)


GO


create procedure usp_RegistrarVenta(
@IdCliente int,
@TotalProducto int,
@MontoTotal decimal(18,2),
@Contacto varchar(100),
@IdDistrito varchar(6),
@Telefono varchar(10),
@Direccion varchar(100),
@IdTransaccion varchar(50),
@DetalleVenta [EDetalle_Venta] READONLY,                                      
@Resultado bit output,
@Mensaje varchar(500) output
)
as
begin
	
	begin try

		declare @idventa int = 0
		set @Resultado = 1
		set @Mensaje = ''

		begin  transaction registro

		insert into VENTA(IdCliente,TotalProducto,MontoTotal,Contacto,IdDistrito,Telefono,Direccion,IdTransaccion)
		values(@IdCliente,@TotalProducto,@MontoTotal,@Contacto,@IdDistrito,@Telefono,@Direccion,@IdTransaccion)

		set @idventa = SCOPE_IDENTITY()


		insert into DETALLE_VENTA(IdVenta,IdProducto,Cantidad,Total)
		select @idventa,IdProducto,Cantidad,Total from @DetalleVenta

		DELETE FROM CARRITO WHERE IdCliente = @IdCliente

		commit transaction registro

	end try
	begin catch
		set @Resultado = 0
		set @Mensaje = ERROR_MESSAGE()
		rollback transaction registro
	end catch

end


GO


create FUNCTION fn_ListarCompra(
@idcliente int
)
RETURNS TABLE 
AS
RETURN 
(	
	select p.RutaImagen,p.NombreImagen,p.Nombre,p.Precio,dv.Cantidad,dv.Total,v.IdTransaccion from DETALLE_VENTA dv
	inner join PRODUCTO p on p.IdProducto = dv.IdProducto
	inner join VENTA v on v.IdVenta = dv.IdVenta
	where v.IdCliente = @idcliente
)
GO



GO
/* ++++++++++++++++++++ PROCEDURES REPORTE ++++++++++++++++++++++++++ */


create PROC sp_ReporteVentas(
 @fechainicio varchar(10),
 @fechafin varchar(10),
 @idtransaccion varchar(50)
 )
  as
 begin

  SET DATEFORMAT dmy;

 select convert(char(10),v.fechaVenta,103)[FechaVenta], concat(c.Nombres,' ',c.Apellidos)[Cliente],
 p.Nombre[Producto],p.Precio,dv.Cantidad,dv.Total,v.IdTransaccion 
 from DETALLE_VENTA dv
 inner join PRODUCTO p on p.IdProducto = dv.IdProducto
 inner join VENTA v on v.IdVenta = dv.IdVenta
 inner join CLIENTE c on c.IdCliente = v.IdCliente
 where CONVERT(date,v.fechaVenta) between @fechainicio and @fechafin
 and v.IdTransaccion = iif(@idtransaccion= '',v.IdTransaccion,@idtransaccion)

 end

 go

 create PROC sp_ReporteDashboard
 as
 begin

  select 
 (select count(*) from CLIENTE)[TotalCliente],
 (select ISNULL(sum(Cantidad),0) from DETALLE_VENTA)[TotalVenta],
 (select count(IdProducto) from PRODUCTO)[TotalProducto]

 end

GO


create PROCEDURE sp_ObtenerProductos(
@idMarca int,
@idCategoria int,
@nroPagina int,
@obtenerRegistros int,
@TotalRegistros int output,
@TotalPaginas int output
)
as
begin

	declare @omitirRegistros int = (@nroPagina - 1) * @obtenerRegistros

	select p.IdProducto,p.Nombre,p.Descripcion,
	m.IdMarca,m.Descripcion[DesMarca],
	c.IdCategoria,c.Descripcion[DesCategoria],
	p.Precio,p.Stock,p.RutaImagen,p.NombreImagen,p.Activo
	INTO #tabla_resultado
	from PRODUCTO p
	inner join MARCA m on m.IdMarca = p.IdMarca
	inner join CATEGORIA c on c.IdCategoria = p.IdCategoria

	-- 1.- AÑADIR LA LOGICA DEL FILTRO POR IDMARCA Y IDCATEGORIA
	where m.IdMarca = iif(@idmarca = 0 ,m.IdMarca,@idmarca) 
	and c.IdCategoria = iif(@idcategoria=0,c.IdCategoria,@idcategoria)

	set @TotalRegistros = (select count(*) from #tabla_resultado)

	set @TotalPaginas = CEILING( CONVERT(FLOAT,@TotalRegistros) / @obtenerRegistros )


	-- 2- AÑADIR LA LOGICA PARA PAGINACION
	select * from #tabla_resultado
	order by IdProducto asc
	offset @omitirRegistros rows
	fetch next @obtenerRegistros rows only


	drop table #tabla_resultado

end


Select * from PRODUCTO;

Select * from USUARIO;