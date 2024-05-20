-- Creation of a test base...

CREATE DATABASE lr2_1;
--
-- База данных: `lr2_1`
--

DELIMITER $$
--
-- Процедуры
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `Proc_Join2Tables` (IN `table_name1` VARCHAR(40), IN `table_name2` VARCHAR(40))  BEGIN
SET @table_name1 = table_name1;
SET @table_name2 = table_name2;
SET @sql_text = concat('SELECT * FROM ', @table_name1, ' cross join ', @table_name2);
PREPARE stmt FROM @sql_text;
EXECUTE stmt;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Proc_SelectLocation` ()  BEGIN
    SET @sql_text ='SELECT * from location';
    PREPARE stmt FROM @sql_text;
    EXECUTE stmt;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Proc_SelectLocationById` (IN `idLocation` INT)  BEGIN
    SET @sql_text =concat('SELECT * from location where id_location = ', idLocation);
    PREPARE stmt FROM @sql_text;
    EXECUTE stmt;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Структура таблицы `location`
--

CREATE TABLE `location` (
  `id_location` int(11) NOT NULL,
  `earth_location` varchar(40) NOT NULL,
  `sun_location` varchar(40) NOT NULL,
  `moon_location` varchar(40) NOT NULL,
  `date_update` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Дамп данных таблицы `location`
--

INSERT INTO `location` (`id_location`, `earth_location`, `sun_location`, `moon_location`, `date_update`) VALUES
(1, 'earth-asdads', '[value-3]', '[value-4]', '2024-05-20 14:07:04');

--
-- Триггеры `location`
--
DELIMITER $$
CREATE TRIGGER `Trigger_OnUpdate_Location` BEFORE UPDATE ON `location` FOR EACH ROW set NEW.date_update = NOW()
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Структура таблицы `natural_object`
--

CREATE TABLE `natural_object` (
  `id_naturalobject` int(11) NOT NULL,
  `type` varchar(20) NOT NULL,
  `galaxy` varchar(30) NOT NULL,
  `accuracy` double NOT NULL,
  `luminous_flow` double NOT NULL,
  `conjugate_objects` text NOT NULL,
  `comment` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Структура таблицы `object`
--

CREATE TABLE `object` (
  `id_object` int(11) NOT NULL,
  `type` varchar(20) NOT NULL,
  `accuracy` double NOT NULL,
  `count` int(11) NOT NULL,
  `time` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `date` date NOT NULL,
  `comment` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Структура таблицы `relations`
--

CREATE TABLE `relations` (
  `id_relation` int(11) NOT NULL,
  `id_sector` int(11) NOT NULL,
  `id_object` int(11) NOT NULL,
  `id_naturalobject` int(11) NOT NULL,
  `id_location` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Структура таблицы `sector`
--

CREATE TABLE `sector` (
  `id_sector` int(11) NOT NULL,
  `coordinates` varchar(40) NOT NULL,
  `luminous_intensity` double NOT NULL,
  `foreign_objects` text NOT NULL,
  `count_spaceobj` int(11) NOT NULL,
  `count_foreignobj` int(11) NOT NULL,
  `count_accurateobj` int(11) NOT NULL,
  `comment` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Индексы сохранённых таблиц
--

--
-- Индексы таблицы `location`
--
ALTER TABLE `location`
  ADD PRIMARY KEY (`id_location`);

--
-- Индексы таблицы `natural_object`
--
ALTER TABLE `natural_object`
  ADD PRIMARY KEY (`id_naturalobject`);

--
-- Индексы таблицы `object`
--
ALTER TABLE `object`
  ADD PRIMARY KEY (`id_object`);

--
-- Индексы таблицы `relations`
--
ALTER TABLE `relations`
  ADD PRIMARY KEY (`id_relation`),
  ADD KEY `id_sector` (`id_sector`),
  ADD KEY `id_object` (`id_object`),
  ADD KEY `id_naturalobject` (`id_naturalobject`),
  ADD KEY `id_location` (`id_location`);

--
-- Индексы таблицы `sector`
--
ALTER TABLE `sector`
  ADD PRIMARY KEY (`id_sector`);

--
-- AUTO_INCREMENT для сохранённых таблиц
--

--
-- AUTO_INCREMENT для таблицы `location`
--
ALTER TABLE `location`
  MODIFY `id_location` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT для таблицы `natural_object`
--
ALTER TABLE `natural_object`
  MODIFY `id_naturalobject` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `object`
--
ALTER TABLE `object`
  MODIFY `id_object` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `relations`
--
ALTER TABLE `relations`
  MODIFY `id_relation` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `sector`
--
ALTER TABLE `sector`
  MODIFY `id_sector` int(11) NOT NULL AUTO_INCREMENT;

--
-- Ограничения внешнего ключа сохраненных таблиц
--

--
-- Ограничения внешнего ключа таблицы `relations`
--
ALTER TABLE `relations`
  ADD CONSTRAINT `relations_ibfk_1` FOREIGN KEY (`id_object`) REFERENCES `object` (`id_object`),
  ADD CONSTRAINT `relations_ibfk_2` FOREIGN KEY (`id_sector`) REFERENCES `sector` (`id_sector`),
  ADD CONSTRAINT `relations_ibfk_3` FOREIGN KEY (`id_naturalobject`) REFERENCES `natural_object` (`id_naturalobject`),
  ADD CONSTRAINT `relations_ibfk_4` FOREIGN KEY (`id_location`) REFERENCES `location` (`id_location`);
COMMIT;
