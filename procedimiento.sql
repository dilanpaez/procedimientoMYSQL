create database AirSensePro;
use AirSensePro;

create table AgentesC(idagentesC int primary key, nombreac varchar(20));
create table Empresa(idempresa int primary key, nombreEmp varchar(50), Nitempresa int, DireccionE varchar(50), 
telefono varchar(20));
create table Usuario(idusuario int primary key, nombreU varchar(20), correo varchar(70), contraseña varchar(20), idempresa int);
create table Dependencia(iddepe int primary key, nombredepe varchar(50), idempresa int);
create table Sensores(idsensor int primary key, iddepe int);
create table TomaInfo(idtoma int primary key, tomaA float, fecha datetime, idagentesC int, idsensor int);
create table Mantenimiento(idmant int primary key, Tipomant varchar(50), Responsable varchar(20), fechamant date, Obser varchar(50), idsensor int);
create table Meteoro(idmeteoro int primary key, tipoMeteoro varchar(20));
create table TomaMeteoro(idtomameteoro int primary key, tomaM float, fechaM datetime, idmeteoro int, idsensor int);

Alter table Usuario add foreign key (idempresa) references Empresa(idempresa);
Alter table Dependencia add foreign key (idempresa) references Empresa(idempresa);
Alter table Sensores add foreign key (iddepe) references Dependencia(iddepe);
Alter table TomaInfo add foreign key (idagentesC) references AgentesC(idagentesC);
Alter table TomaInfo add foreign key (idsensor) references Sensores(idsensor);
Alter table Mantenimiento add foreign key (idsensor) references Sensores(idsensor);
Alter table TomaMeteoro add foreign key (idmeteoro) references Meteoro(idmeteoro);
Alter table TomaMeteoro add foreign key (idsensor) references Sensores(idsensor);

DELIMITER //
CREATE FUNCTION VerificarEstadoMantenimiento(id_sensor INT) RETURNS VARCHAR(50)
BEGIN
    DECLARE estado VARCHAR(50);
    DECLARE fecha_ult_mantenimiento DATE;
    
    -- Obtener la fecha del último mantenimiento para el sensor dado
    SELECT fechamant INTO fecha_ult_mantenimiento
    FROM Mantenimiento
    WHERE idsensor = id_sensor
    ORDER BY fechamant DESC
    LIMIT 1;
    
    -- Calcular la fecha límite para el próximo mantenimiento (por ejemplo, 6 meses después del último mantenimiento)
    SET fecha_limite = DATE_ADD(fecha_ult_mantenimiento, INTERVAL 6 MONTH);
    
    -- Verificar el estado de mantenimiento
    IF fecha_limite <= CURDATE() THEN
        SET estado = 'Requiere mantenimiento';
    ELSE
        SET estado = 'En buen estado';
    END IF;
    
    RETURN estado;
END //
DELIMITER ;
SELECT VerificarEstadoMantenimiento(1);
En esta función:

Declaramos una variable estado para almacenar el estado de mantenimiento.
Obtenemos la fecha del último mantenimiento para el sensor dado.
Calculamos la fecha límite para el próximo mantenimiento (en este ejemplo, 6 meses después del último mantenimiento).
Usamos un condicional IF para verificar si la fecha límite para el próximo mantenimiento es menor o igual a la fecha actual. Si es así, establecemos el estado en "Requiere mantenimiento"; de lo contrario, lo establecemos en "En buen estado".
La función devuelve el estado de mantenimiento.