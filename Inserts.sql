-- *** TABLA: USUARIO ***
-- Insertamos usuarios con contrase�as hasheadas en SHA256
-- Las contrase�as originales (ej. 'Admin123', 'GerentePass') no se almacenan directamente.

-- *** TABLA: USUARIO ***
-- Insertamos usuarios con los nombres solicitados y contrase�as hasheadas en SHA256

Select * From USUARIO;
INSERT INTO USUARIO (Nombres, Apellidos, Correo, Clave, Reestablecer, Activo) VALUES
('Rodrigo', 'Ortiz', 'rodrigo.ortiz@gmail.com', ('PassRodrigo123'), 0, 1),
('Osama', 'Ignacio', 'osama.ignacio@farmacia.com',('OsamaSeguro456'), 0, 1),
('Randy', 'Garcias', 'randy.garcias@farmacia.com', ('RandyFarmacia789'), 0, 1);
GO

drop table USUARIO;
-- *** TABLA: CATEGORIA ***
-- Insertamos 7 categor�as de productos para una farmacia.
-- IdCategoria se asignar� autom�ticamente (IDENTITY).

INSERT INTO CATEGORIA (Descripcion, Activo) VALUES
('Medicamentos', 1),
('Vitaminas y Suplementos', 1),
('Cuidado Personal', 1),
('Primeros Auxilios', 1),
('Maternidad y Beb�', 1),
('Dermocosm�ticos', 1),
('Higiene Oral', 1);
GO

-- *** TABLA: MARCA ***
-- Insertamos 10 marcas principales para productos de farmacia, incluyendo la marca gen�rica de Farmacias San Pablo.
-- IdMarca se asignar� autom�ticamente (IDENTITY).

INSERT INTO MARCA (Descripcion, Activo) VALUES
('Bayer', 1),
('Pfizer', 1),
('Sanofi', 1),
('Genomma Lab', 1),
('P&G', 1),
('Unilever', 1),
('Nestl� Health Science', 1),
('Roche', 1),
('Nature Made', 1),
('Farmacias San Pablo (Gen�ricos)', 1); -- Marca gen�rica espec�fica
GO

-- *** TABLA: DEPARTAMENTO (Conceptualizado como ESTADO/Entidad Federativa en M�xico) ***
-- Insertamos solo la Ciudad de M�xico, ya que la operaci�n se limita a esta entidad.

INSERT INTO DEPARTAMENTO (IdDepartamento, Descripcion) VALUES
('09', 'Ciudad de M�xico'); -- ID oficial INEGI para la Ciudad de M�xico
GO

-- *** TABLA: ENTIDAD (Conceptualizado como ALCALD�A en la Ciudad de M�xico) ***
-- Insertamos las principales alcald�as de la Ciudad de M�xico.
-- Aseg�rate de que el IdDepartamento '09' (Ciudad de M�xico) exista en tu tabla DEPARTAMENTO.

INSERT INTO PROVINCIA (IdProvincia, Descripcion, IdDepartamento) VALUES
('002', 'Azcapotzalco', '09'),      -- C�digo INEGI para Azcapotzalco
('003', 'Coyoac�n', '09'),          -- C�digo INEGI para Coyoac�n
('004', 'Cuajimalpa de Morelos', '09'), -- C�digo INEGI para Cuajimalpa
('005', 'Gustavo A. Madero', '09'), -- C�digo INEGI para Gustavo A. Madero
('006', 'Iztacalco', '09'),         -- C�digo INEGI para Iztacalco
('007', 'Iztapalapa', '09'),        -- C�digo INEGI para Iztapalapa
('008', 'La Magdalena Contreras', '09'), -- C�digo INEGI para Magdalena Contreras
('009', 'Milpa Alta', '09'),        -- C�digo INEGI para Milpa Alta
('010', '�lvaro Obreg�n', '09'),    -- C�digo INEGI para �lvaro Obreg�n
('011', 'Benito Ju�rez', '09'),     -- C�digo INEGI para Benito Ju�rez
('012', 'Cuauht�moc', '09'),        -- C�digo INEGI para Cuauht�moc
('013', 'Miguel Hidalgo', '09'),    -- C�digo INEGI para Miguel Hidalgo
('014', 'Tl�huac', '09'),           -- C�digo INEGI para Tl�huac
('015', 'Tlalpan', '09'),           -- C�digo INEGI para Tlalpan
('016', 'Xochimilco', '09'),        -- C�digo INEGI para Xochimilco
('017', 'Venustiano Carranza', '09'); -- C�digo INEGI para Venustiano Carranza
GO

-- *** TABLA: DELEGACION (Conceptualizado como COLONIA/BARRIO en la Ciudad de M�xico) ***
-- Insertamos algunas colonias representativas para ciertas alcald�as en la Ciudad de M�xico.
-- Aseg�rate de que los IdEntidad y IdDepartamento correspondientes existan en sus respectivas tablas.

INSERT INTO DISTRITO (IdDistrito, Descripcion, IdProvincia, IdDepartamento) VALUES
-- Colonias de Coyoac�n (IdEntidad: '003', IdDepartamento: '09')
('090301', 'Coyoac�n Centro', '003', '09'),
('090302', 'Del Carmen', '003', '09'),
('090303', 'Pedregal de Santo Domingo', '003', '09'),

-- Colonias de Benito Ju�rez (IdEntidad: '011', IdDepartamento: '09')
('091101', 'Narvarte Poniente', '011', '09'),
('091102', 'Del Valle Centro', '011', '09'),
('091103', 'Portales Norte', '011', '09'),

-- Colonias de Cuauht�moc (IdEntidad: '012', IdDepartamento: '09')
('091201', 'Roma Norte', '012', '09'),
('091202', 'Condesa', '012', '09'),
('091203', 'Centro Hist�rico', '012', '09'),

-- Colonias de Miguel Hidalgo (IdEntidad: '013', IdDepartamento: '09')
('091301', 'Polanco Reforma', '013', '09'),
('091302', 'Bosques de las Lomas', '013', '09'),
('091303', 'Anzures', '013', '09'),

-- Colonias de Iztapalapa (IdEntidad: '007', IdDepartamento: '09')
('090701', 'Santa Cruz Meyehualco', '007', '09'),
('090702', 'Desarrollo Urbano Quetzalc�atl', '007', '09'),
('090703', 'San Lorenzo Tezonco', '007', '09');
GO




