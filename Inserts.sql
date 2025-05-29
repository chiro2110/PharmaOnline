-- *** TABLA: USUARIO ***
-- Insertamos usuarios con contraseñas hasheadas en SHA256
-- Las contraseñas originales (ej. 'Admin123', 'GerentePass') no se almacenan directamente.

-- *** TABLA: USUARIO ***
-- Insertamos usuarios con los nombres solicitados y contraseñas hasheadas en SHA256

Select * From USUARIO;
INSERT INTO USUARIO (Nombres, Apellidos, Correo, Clave, Reestablecer, Activo) VALUES
('Rodrigo', 'Ortiz', 'rodrigo.ortiz@gmail.com', ('PassRodrigo123'), 0, 1),
('Osama', 'Ignacio', 'osama.ignacio@farmacia.com',('OsamaSeguro456'), 0, 1),
('Randy', 'Garcias', 'randy.garcias@farmacia.com', ('RandyFarmacia789'), 0, 1);
GO

drop table USUARIO;
-- *** TABLA: CATEGORIA ***
-- Insertamos 7 categorías de productos para una farmacia.
-- IdCategoria se asignará automáticamente (IDENTITY).

INSERT INTO CATEGORIA (Descripcion, Activo) VALUES
('Medicamentos', 1),
('Vitaminas y Suplementos', 1),
('Cuidado Personal', 1),
('Primeros Auxilios', 1),
('Maternidad y Bebé', 1),
('Dermocosméticos', 1),
('Higiene Oral', 1);
GO

-- *** TABLA: MARCA ***
-- Insertamos 10 marcas principales para productos de farmacia, incluyendo la marca genérica de Farmacias San Pablo.
-- IdMarca se asignará automáticamente (IDENTITY).

INSERT INTO MARCA (Descripcion, Activo) VALUES
('Bayer', 1),
('Pfizer', 1),
('Sanofi', 1),
('Genomma Lab', 1),
('P&G', 1),
('Unilever', 1),
('Nestlé Health Science', 1),
('Roche', 1),
('Nature Made', 1),
('Farmacias San Pablo (Genéricos)', 1); -- Marca genérica específica
GO

-- *** TABLA: DEPARTAMENTO (Conceptualizado como ESTADO/Entidad Federativa en México) ***
-- Insertamos solo la Ciudad de México, ya que la operación se limita a esta entidad.

INSERT INTO DEPARTAMENTO (IdDepartamento, Descripcion) VALUES
('09', 'Ciudad de México'); -- ID oficial INEGI para la Ciudad de México
GO

-- *** TABLA: ENTIDAD (Conceptualizado como ALCALDÍA en la Ciudad de México) ***
-- Insertamos las principales alcaldías de la Ciudad de México.
-- Asegúrate de que el IdDepartamento '09' (Ciudad de México) exista en tu tabla DEPARTAMENTO.

INSERT INTO PROVINCIA (IdProvincia, Descripcion, IdDepartamento) VALUES
('002', 'Azcapotzalco', '09'),      -- Código INEGI para Azcapotzalco
('003', 'Coyoacán', '09'),          -- Código INEGI para Coyoacán
('004', 'Cuajimalpa de Morelos', '09'), -- Código INEGI para Cuajimalpa
('005', 'Gustavo A. Madero', '09'), -- Código INEGI para Gustavo A. Madero
('006', 'Iztacalco', '09'),         -- Código INEGI para Iztacalco
('007', 'Iztapalapa', '09'),        -- Código INEGI para Iztapalapa
('008', 'La Magdalena Contreras', '09'), -- Código INEGI para Magdalena Contreras
('009', 'Milpa Alta', '09'),        -- Código INEGI para Milpa Alta
('010', 'Álvaro Obregón', '09'),    -- Código INEGI para Álvaro Obregón
('011', 'Benito Juárez', '09'),     -- Código INEGI para Benito Juárez
('012', 'Cuauhtémoc', '09'),        -- Código INEGI para Cuauhtémoc
('013', 'Miguel Hidalgo', '09'),    -- Código INEGI para Miguel Hidalgo
('014', 'Tláhuac', '09'),           -- Código INEGI para Tláhuac
('015', 'Tlalpan', '09'),           -- Código INEGI para Tlalpan
('016', 'Xochimilco', '09'),        -- Código INEGI para Xochimilco
('017', 'Venustiano Carranza', '09'); -- Código INEGI para Venustiano Carranza
GO

-- *** TABLA: DELEGACION (Conceptualizado como COLONIA/BARRIO en la Ciudad de México) ***
-- Insertamos algunas colonias representativas para ciertas alcaldías en la Ciudad de México.
-- Asegúrate de que los IdEntidad y IdDepartamento correspondientes existan en sus respectivas tablas.

INSERT INTO DISTRITO (IdDistrito, Descripcion, IdProvincia, IdDepartamento) VALUES
-- Colonias de Coyoacán (IdEntidad: '003', IdDepartamento: '09')
('090301', 'Coyoacán Centro', '003', '09'),
('090302', 'Del Carmen', '003', '09'),
('090303', 'Pedregal de Santo Domingo', '003', '09'),

-- Colonias de Benito Juárez (IdEntidad: '011', IdDepartamento: '09')
('091101', 'Narvarte Poniente', '011', '09'),
('091102', 'Del Valle Centro', '011', '09'),
('091103', 'Portales Norte', '011', '09'),

-- Colonias de Cuauhtémoc (IdEntidad: '012', IdDepartamento: '09')
('091201', 'Roma Norte', '012', '09'),
('091202', 'Condesa', '012', '09'),
('091203', 'Centro Histórico', '012', '09'),

-- Colonias de Miguel Hidalgo (IdEntidad: '013', IdDepartamento: '09')
('091301', 'Polanco Reforma', '013', '09'),
('091302', 'Bosques de las Lomas', '013', '09'),
('091303', 'Anzures', '013', '09'),

-- Colonias de Iztapalapa (IdEntidad: '007', IdDepartamento: '09')
('090701', 'Santa Cruz Meyehualco', '007', '09'),
('090702', 'Desarrollo Urbano Quetzalcóatl', '007', '09'),
('090703', 'San Lorenzo Tezonco', '007', '09');
GO




