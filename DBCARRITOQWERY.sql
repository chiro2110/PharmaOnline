create database DBCARRITO
Go
Use DBCARRITO 

Go

Create table CATEGORIA(
IdCategoria int primary key identity,
Descripcion varchar(100),
Activo bit default 1, 
FechaRegistro datetime default getdate()
)
go

CREATE TABLE MARCA(
    IdMarca int primary key identity,
    Descripcion varchar(100),
    Activo bit default 1,
    FechaRegistro datetime default getdate()
)
go

CREATE TABLE PRODUCTO(
    IdProducto int primary key identity,
    Nombre varchar(500),
    Descripcion varchar(500),
    IdMarca int references Marca(IdMarca),
    IdCategoria int references Categoria(IdCategoria),
    Precio decimal(10,2) default 0,
    Stock int,
    RutaImagen varchar(100),
    NombreImagen varchar(100),
    Activo bit default 1,
    FechaRegistro datetime default getdate()
)
Go

CREATE TABLE CLIENTE(
    IdCliente int primary key identity,
    Nombres varchar(100),
    Apellidos varchar(100),
    Correo varchar(100),
    Clave varchar(150),
    Reestablecer bit default 0,
    FechaRegistro datetime default getdate()
)
GO

CREATE TABLE CARRITO(
    IdCarrito int primary key identity,
    IdCliente int references CLIENTE(IdCliente),
    IdProducto int references PRODUCTO(IdProducto),
    Cantidad int
)
Go

CREATE TABLE VENTA(
    IdVenta int primary key identity,
    IdCliente int references CLIENTE(IdCliente),
    TotalProducto int,
    MontoTotal decimal(10,2),
    Contacto varchar(50),
    IdDistrito varchar(10),
    Telefono varchar(50),
    Direccion varchar(500),
    IdTransaccion varchar(50),
    FechaVenta datetime default getdate()
)
go

CREATE TABLE DETALLE_VENTA(
    IdDetalleVenta int primary key identity,
    IdVenta int references VENTA(IdVenta),
    IdProducto int references PRODUCTO(IdProducto),
    Cantidad int,
    Total decimal(10,2)
)
Go
CREATE TABLE USUARIO(
IdUsuario int primary key identity,
Nombres varchar(100),
Apellidos varchar(100),
Correo varchar(100),
Clave varchar(150),
Reestablecer bit default 1,
Activo bit default 1,
FechaRegistro datetime default getdate()
)
GO

CREATE TABLE DEPARTAMENTO (
IdDepartamento varchar(2) NOT NULL,
Descripcion varchar(45) NOT NULL
)
go

CREATE TABLE PROVINCIA (
IdProvincia varchar(4) NOT NULL,
Descripcion varchar(45) NOT NULL,
IdDepartamento varchar(2) NOT NULL
)

go

CREATE TABLE DISTRITO (
IdDistrito varchar(6) NOT NULL,
Descripcion varchar(45) NOT NULL,
IdProvincia varchar(4) NOT NULL,
IdDepartamento varchar(2) NOT NULL
)

Select * from DISTRITO;
Select * from USUARIO;