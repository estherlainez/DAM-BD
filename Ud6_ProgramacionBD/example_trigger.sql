DELIMITER $$
$$

# Creamos el Schema si no existe
CREATE SCHEMA IF NOT EXISTS db_test;

USE db_test;

$$

-- Eliminamos el procedimiento almancenado si existise
DROP PROCEDURE IF EXISTS db_test.procedureTemp;

$$

CREATE PROCEDURE db_test.procedureTemp()
BEGIN
  DECLARE cuenta  INT DEFAULT 0;

  -- Si no existe la tabla de expedientes, la creamos.
  SELECT COUNT(*) INTO cuenta FROM `information_schema`.`tables` WHERE TABLE_SCHEMA='db_test' AND TABLE_NAME='expedientes' LIMIT 1;
  IF (cuenta = 0)  THEN
    CREATE TABLE `expedientes` (
      code             VARCHAR(15)  NOT NULL COMMENT 'Código del expediente',
      state            VARCHAR(20)  COMMENT 'Estado del expediente',
      stateChangedDate DATETIME     COMMENT 'Fecha/Hora en la que se produjo el último cambio de estado',

      PRIMARY KEY `PK_Exp` (code)
    ) ENGINE=InnoDB CHARSET=utf8 collate=utf8_general_ci;
  END IF;

  -- Insertamos algunos expedientes de ejemplo
  DELETE FROM expedientes WHERE code IN ('expediente1','expediente2', 'expediente3');
  INSERT INTO expedientes (code) VALUES ('expediente1');
  INSERT INTO expedientes (code) VALUES ('expediente2');
  INSERT INTO expedientes (code) VALUES ('expediente3');



  -- Si no existe la tabla de cambios de estado la creamos
  SELECT COUNT(*) INTO cuenta FROM `information_schema`.`tables` WHERE TABLE_SCHEMA='db_test' AND TABLE_NAME='expStatusHistory' LIMIT 1;
  IF (cuenta = 0)  THEN
    CREATE TABLE `expStatusHistory` (
      `id`    INT         AUTO_INCREMENT,
      `code`  VARCHAR(15) NOT NULL COMMENT 'Código del expediente',
      `state` VARCHAR(20) NOT NULL COMMENT 'Estado del expediente',
      `date`  TIMESTAMP   DEFAULT CURRENT_TIMESTAMP COMMENT 'Fecha/Hora en la que el expediente pasó a ese estado',
      PRIMARY KEY `PK_ExpHistory` (`id`)
    ) ENGINE=MyISAM CHARSET=utf8 collate=utf8_general_ci;  -- No transacciones => MyISAM
  END IF;

END;

$$

-- Invocamos el procedimiento almacenado
CALL db_test.procedureTemp();

$$
-- Borramos el procedimiento almacenado
DROP PROCEDURE IF EXISTS db_test.procedureTemp;

$$

-- Borramos el Trigger si existise
DROP TRIGGER IF EXISTS StatusChangeDateTrigger;

$$

-- Cremamos un Trigger sobre la tabla expedientes

CREATE TRIGGER StatusChangeDateTrigger
    BEFORE UPDATE ON expedientes FOR EACH ROW
    BEGIN
         -- ¿Ha cambiado el estado?
         IF NEW.state != OLD.state THEN
            -- Actualizamos el campo stateChangedDate a la fecha/hora actual
            SET NEW.stateChangedDate = NOW();

            -- A modo de auditoría, añadimos un registro en la tabla expStatusHistory
            INSERT INTO expStatusHistory (`code`, `state`) VALUES (NEW.code, NEW.state);
         END IF;
    END;
$$

DELIMITER;