select * from CATEGORIA;

create proc sp_RegistrarCategoria(
    @Descripcion varchar(100),
    @Activo bit,
    @Mensaje varchar(500) output,
    @Resultado int output
)
as
begin
    SET @Resultado = 0
    IF NOT EXISTS (SELECT * FROM CATEGORIA WHERE Descripcion = @Descripcion)
    begin
        insert into CATEGORIA(Descripcion, Activo) values
        (@Descripcion, @Activo)

        SET @Resultado = scope_identity()
    end
    else
        set @Mensaje = 'La categoria ya existe'
end


create proc sp_EditarCategoria(
    @IdCategoria int,
    @Descripcion varchar(100),
    @Activo bit,
    @Mensaje varchar(500) output,
    @Resultado bit output
)
as
begin
    SET @Resultado = 0
    IF NOT EXISTS (SELECT * FROM CATEGORIA WHERE Descripcion = @Descripcion and IdCategoria != @IdCategoria)
    begin
        update top (1) CATEGORIA set
            Descripcion = @Descripcion,
            Activo = @Activo
        where IdCategoria = @IdCategoria

        SET @Resultado = 1
    end
    else
        set @Mensaje = 'La categoria ya existe'
end


create proc sp_EliminarCategoria(
    @IdCategoria int,
    @Mensaje varchar(500) output,
    @Resultado bit output
)
as
begin
    SET @Resultado = 0
    IF NOT EXISTS (select * from PRODUCTO p
        inner join CATEGORIA c on c.IdCategoria = p.IdCategoria
        where p.IdCategoria = @IdCategoria)
    begin
        delete top (1) from CATEGORIA where IdCategoria = @IdCategoria
        SET @Resultado = 1
    end
    else
        set @Mensaje = 'La categoria se encuentra relacionada a un producto'
end
