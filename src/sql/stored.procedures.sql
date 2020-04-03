DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `AttacksOn`()
BEGIN
    SELECT AttackOn, Count(*) AS Total
    FROM Events
    GROUP BY AttackOn
    ORDER BY Total DESC;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `CivilianDeathsByCategoryAndType`()
BEGIN
    SELECT type, category, SUM(civiliankia) AS CiviliansKilled
    FROM events 
    GROUP BY type, category
    ORDER BY CiviliansKilled DESC;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `CiviliansWoundedByCategoryAndType`()
BEGIN
    SELECT type, category, SUM(civilianwia) AS TotalCivilianWounded
    FROM events 
    GROUP BY type, category
    ORDER BY TotalCivilianWounded DESC; 
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ClassificationCount`()
BEGIN
    SELECT classification, count(*) AS TotalEvents
    FROM events
    GROUP BY classification;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `CollateralMurder`()
BEGIN
    SELECT *
    FROM events 
    WHERE Date(date) = '2007-07-12'
    AND summary LIKE '%helicopter%';
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `CountCategories`()
BEGIN
    SELECT category, COUNT(category) AS Total
    FROM `iraqwarlogs`.events 
    GROUP BY category
    ORDER BY Total DESC;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `CountEventTypes`()
BEGIN
    SELECT type, count(*) AS Total
    FROM events
    GROUP BY type
    ORDER BY Total DESC;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `CountTypesAndCategories`()
BEGIN
    SELECT type, category, COUNT(*) AS Total
    FROM events 
    GROUP BY type, category
    ORDER BY Total DESC;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `DeathsByCategoryAndType`()
BEGIN
    SELECT 
        type, 
        category, 
        affiliation, 
        SUM(civiliankia) AS CivilianKIA, 
        SUM(friendlykia) AS FriendlyKIA, 
        SUM(hostnationkia) AS HostNationKIA, 
        SUM(enemykia) AS EnemyKIA,
        SUM(civiliankia + friendlykia + hostnationkia + enemykia) AS Total
    FROM Events
    GROUP BY type, category, affiliation
    ORDER BY CivilianKIA DESC;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `GeographicDeaths`()
BEGIN
    SELECT 
        date, 
        YEAR(date) AS TheYear, 
        MONTH(date)AS TheMonth, 
        latitude, 
        longitude,
        friendlykia + hostnationkia + civiliankia + enemykia AS Deaths
    FROM events
    HAVING Deaths > 0
    ORDER BY date ASC ;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `GetDataDateRange`()
BEGIN
    SELECT min(date) StartDate, max(date) EndDate
    FROM events ;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `KIABreakdown`()
BEGIN
    SELECT 
        type, 
        category, 
        affiliation, 
        AttackOn,
        SUM(civiliankia) AS CivilianKIA, 
        SUM(friendlykia) AS FriendlyKIA, 
        SUM(hostnationkia) AS HostNationKIA, 
        SUM(enemykia) AS EnemyKIA,
        SUM(civiliankia + friendlykia + hostnationkia + enemykia) AS Total
    FROM Events
    GROUP BY type, category, affiliation, AttackOn
    ORDER BY CivilianKIA DESC;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `KIATotalsByategoryAndType`()
BEGIN
    SELECT 
        type, 
        category, 
        affiliation, 
        SUM(civiliankia) AS CivilianKIA, 
        SUM(friendlykia) AS FriendlyKIA, 
        SUM(hostnationkia) AS HostNationKIA, 
        SUM(enemykia) AS EnemyKIA,
        SUM(civiliankia + friendlykia + hostnationkia + enemykia) AS Total
    FROM Events
    GROUP BY type, category, affiliation
    ORDER BY CivilianKIA DESC;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `KilledWoundedPercentage`()
BEGIN
    SELECT 
        SUM(civiliankia) / (SUM(civiliankia) + SUM(civilianwia)) AS CivilianKIAPercent, 
        SUM(friendlykia) / (SUM(friendlykia) + SUM(friendlywia)) AS FriendlyKIAPercent, 
        SUM(hostnationkia) / (SUM(hostnationkia) + SUM(hostnationwia)) AS HostNationKIAPercent, 
        SUM(enemykia) / ( SUM(enemykia) + SUM(enemywia)) AS EnemyKIAPercent
    FROM events ;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `MonthlyCasualties`()
BEGIN
    SELECT 
        YEAR(date) AS TheYear, MONTH(date)AS TheMonth, 
        SUM(friendlywia) AS friendlywia, 
        SUM(friendlykia) AS friendlykia, 
        SUM(hostnationwia) AS hostnationwia, 
        SUM(hostnationkia) AS hostnationkia, 
        SUM(civilianwia) AS civilianwia, 
        SUM(civiliankia) AS civiliankia, 
        SUM(enemywia) AS enemywia, 
    	SUM(enemykia) AS enemykia, 
        SUM(enemydetained) AS enemydetained
    FROM events 
    GROUP BY TheYear, TheMonth
    
    # These months are missing so I will manually add them
    UNION 
    SELECT
        2004 AS TheYear, 5 AS TheMonth, 
        0 AS friendlywia, 
        0 AS friendlykia, 
        0 AS hostnationwia, 
        0 AS hostnationkia, 
        0 AS civilianwia, 
        0 AS civiliankia, 
        0 AS enemywia, 
    	0 AS enemykia, 
        0 AS enemydetained
    UNION 
	SELECT
        2009 AS TheYear, 3 AS TheMonth, 
        0 AS friendlywia, 
        0 AS friendlykia, 
        0 AS hostnationwia, 
        0 AS hostnationkia, 
        0 AS civilianwia, 
        0 AS civiliankia, 
        0 AS enemywia, 
    	0 AS enemykia, 
        0 AS enemydetained
    ORDER BY TheYear ASC, TheMonth ASC;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `NonSecret`()
BEGIN
    SELECT * 
    FROM iraqwarlogs.events
    WHERE NOT classification LIKE 'SECRET%';
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `TotalCasualties`()
BEGIN
    SELECT SUM(TotalKilled) AS KilledTotal
    FROM 
    (
        SELECT (civiliankia + friendlykia + hostnationkia + enemykia + civilianwia + friendlywia + hostnationwia + enemywia) AS TotalKilled
        FROM events 
    ) AS Killed;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `TotalCivilianWoundedInAction`()
BEGIN
    SELECT SUM(civilianwia) AS CivilianWounded
    FROM `iraqwarlogs`.events; 
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `TotalDeaths`()
BEGIN
    SELECT 
        SUM(civiliankia) AS CivilianKIA, 
        SUM(friendlykia) AS FriendlyKIA, 
        SUM(hostnationkia) AS HostNationKIA, 
        SUM(enemykia) AS EnemyKIA,
        SUM(civiliankia + friendlykia + hostnationkia + enemykia) AS Total
    FROM Events; 
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `TotalDetained`()
BEGIN
    SELECT SUM(enemydetained) AS TotalDetained
    FROM events;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `TotalKilled`()
BEGIN
    SELECT SUM(TotalKilled) AS KilledTotal
    FROM 
    (
        SELECT (civiliankia + friendlykia + hostnationkia + enemykia) AS TotalKilled
        FROM `iraqwarlogs`.events 
    ) AS Killed;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `TotalWoundedInAction`()
BEGIN
    SELECT SUM(TotalWIA) AS WIATotal
    FROM 
    (
        SELECT friendlywia + hostnationwia + enemywia + civilianwia AS TotalWIA
        FROM iraqwarlogs.events 
    ) AS Wounded;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `WIAByCategoryAndTypeWIAByCategoryAndType`()
BEGIN
    SELECT type, category, SUM(friendlywia + hostnationwia + enemywia + civilianwia) AS TotalWIA
    FROM events 
    GROUP BY type, category
    ORDER BY TotalWIA DESC; 
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `WoundedBreakdown`()
BEGIN
    SELECT 
        type, 
        category, 
        affiliation, 
        AttackOn,
        SUM(civilianwia) AS CivilianWIA, 
        SUM(friendlywia) AS FriendlyWIA, 
        SUM(hostnationwia) AS HostNationWIA, 
        SUM(enemywia) AS EnemyWIA,
        SUM(civilianwia + friendlywia + hostnationwia + enemywia) AS Total
    FROM Events
    GROUP BY type, category, affiliation, AttackOn
    ORDER BY CivilianWIA DESC;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `KIATotals`()
BEGIN
    SELECT
        SUM(civiliankia) AS CivilianKIA,
        SUM(friendlykia) AS FriendlyKIA,
        SUM(hostnationkia) AS HostNationKIA,
        SUM(enemykia) AS EnemyKIA,
        SUM(civiliankia + friendlykia + hostnationkia + enemykia) AS Total
    FROM Events;
END$$
DELIMITER ;