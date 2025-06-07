create proc sp_RegistrarMarca
@Descripcion varchar(100),
@Activo bit,
@Mensaje varchar(500) output,
@Resultado int output
as
begin
    SET @Resultado = 0
    IF NOT EXISTS (SELECT * FROM MARCA WHERE Descripcion = @Descripcion)
    begin
        insert into MARCA(Descripcion,Activo) values
        (@Descripcion,@Activo)

        SET @Resultado = scope_identity()
    end
    else
        set @Mensaje = 'La marca ya existe'
end

create proc sp_EditarMarca(
@IdMarca int,
@Descripcion varchar(100),
@Activo bit,
@Mensaje varchar(500) output,
@Resultado bit output
)
as
begin
    SET @Resultado = 0
    IF NOT EXISTS (SELECT * FROM MARCA WHERE Descripcion = @Descripcion and IdMarca != @IdMarca)
    begin
        update top (1) MARCA set
            Descripcion = @Descripcion,
            Activo = @Activo
        where IdMarca = @IdMarca

        SET @Resultado = 1
    end
    else
        set @Mensaje = 'La marca ya existe'
end


create proc sp_EliminarMarca(
@IdMarca int,
@Mensaje varchar(500) output,
@Resultado bit output
)
as
begin
    SET @Resultado = 0
    IF NOT EXISTS (select * from PRODUCTO p
    inner join MARCA m on m.IdMarca = p.IdMarca
    where p.IdMarca = @IdMarca)
    begin
        delete top (1) from MARCA where IdMarca = @IdMarca
        SET @Resultado = 1
    end
    else
        set @Mensaje = 'La marca se encuentra relacionada a un producto'
end


git add