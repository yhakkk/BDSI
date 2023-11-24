-- Creación de la tabla 'vehiculo'
CREATE TABLE vehiculo (
    codvehiculo INT AUTO_INCREMENT PRIMARY KEY,
    patente VARCHAR(20),
    anyiofabricacion INT,
    nroeje INT,
    cantasientos INT,
    fechaalta DATE
);

-- Creación de la tabla 'revision'
CREATE TABLE revision (
    codrevision INT AUTO_INCREMENT PRIMARY KEY,
    codvehiculo INT,
    codinspector INT,
    fechaalta DATE,
    resultado VARCHAR(50),
    FOREIGN KEY (codvehiculo) REFERENCES vehiculo(codvehiculo)
);

-- Creación de la tabla 'cambioestructuravehiculo'
CREATE TABLE cambioestructuravehiculo (
    codestructura INT AUTO_INCREMENT PRIMARY KEY,
    valorold VARCHAR(50),
    valornew VARCHAR(50),
    codrevision INT,
    codvehic INT,
    fechaalta DATE,
    FOREIGN KEY (codrevision) REFERENCES revision(codrevision),
    FOREIGN KEY (codvehic) REFERENCES vehiculo(codvehiculo)
);

-- se utiliza para separar el final de la definicion del trigger del final del bloque
DELIMITER //

CREATE TRIGGER after_insert_revision
AFTER INSERT ON revision
FOR EACH ROW
BEGIN
    -- El trigger se activa despues de cada insercion en la tabla 'revision'
    -- Inserta una nueva fila en 'cambioestructuravehiculo' con los valores correspondientes
    -- 'valorold' toma el valor anterior de 'resultado' en la tabla 'revision'
    -- 'valornew' toma el valor recien insertado en 'resultado' en la tabla 'revision'
    DECLARE v_valor_anterior VARCHAR(50);
    
    SELECT resultado INTO v_valor_anterior
    FROM revision
    WHERE codrevision = NEW.codrevision - 1;
    -- Toma el valor previo ya que es incremental el codrevision
    
    INSERT INTO cambioestructuravehiculo (valorold, valornew, codrevision, codvehic, fechaalta)
    VALUES (v_valor_anterior, NEW.resultado, NEW.codrevision, NEW.codvehiculo, NEW.fechaalta);
END //
DELIMITER ;




-- Inserciones para la tabla 'vehiculo'
INSERT INTO vehiculo (patente, anyiofabricacion, nroeje, cantasientos, fechaalta) 
VALUES ('ABC123', 2020, 2, 5, '2023-01-15');

-- Inserciones para la tabla 'revision'
INSERT INTO revision (codvehiculo, codinspector, fechaalta, resultado) 
VALUES (1, 101, '2023-03-10', 'Aprobado');

-- Inserciones para la tabla 'cambioestructuravehiculo'
INSERT INTO cambioestructuravehiculo (valorold, valornew, codrevision, codvehic, fechaalta) 
VALUES ('Aprobado', 'Desaprobado', 1, 1, '2023-03-10');
