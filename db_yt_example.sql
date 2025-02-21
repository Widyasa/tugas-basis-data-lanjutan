-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Feb 21, 2025 at 09:21 PM
-- Server version: 5.7.33
-- PHP Version: 8.3.2

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `db_yt_example`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `AddVideoLike` (IN `videoId` VARCHAR(255), IN `userId` VARCHAR(255))   BEGIN
    IF NOT EXISTS (SELECT 1 FROM VideoLikes WHERE video_id = videoId AND user_id = userId) THEN
        INSERT INTO VideoLikes (video_id, user_id, like_date) 
        VALUES (videoId, userId, NOW());
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetVideoComments` (IN `videoId` VARCHAR(191))   BEGIN
    SELECT COUNT(*) AS total_comments 
    FROM VideoComments 
    WHERE video_id = videoId;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetVideoLikes` (IN `videoId` VARCHAR(191))   BEGIN
    SELECT COUNT(*) AS total_likes 
    FROM videolikes 
    WHERE video_id = videoId;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetVideoViews` (IN `videoId` VARCHAR(191))   BEGIN
    SELECT COUNT(*) AS total_views 
    FROM videoviews 
    WHERE video_id = videoId;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `RemoveVideoLike` (IN `videoId` VARCHAR(255), IN `userId` VARCHAR(255))   BEGIN
    DELETE FROM VideoLikes WHERE video_id = videoId AND user_id = userId;
END$$

--
-- Functions
--
CREATE DEFINER=`root`@`localhost` FUNCTION `GetTotalCommentsByUser` (`userId` VARCHAR(255)) RETURNS INT(11) DETERMINISTIC BEGIN
    DECLARE total_comments INT;
    
    SELECT COUNT(*) INTO total_comments 
    FROM VideoComments 
    WHERE video_id IN (SELECT id FROM Videos WHERE user_id = userId);
    
    RETURN total_comments;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `GetTotalFollowing` (`userId` VARCHAR(191)) RETURNS INT(11) DETERMINISTIC BEGIN
    DECLARE total_following INT;

    SELECT COUNT(*) INTO total_following 
    FROM subscriptions 
    WHERE subscriptions.user_watcher_id = userId;

    RETURN total_following;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `GetTotalSubscribers` (`userId` VARCHAR(191)) RETURNS INT(11) DETERMINISTIC BEGIN
    DECLARE total_subscribers INT;

    SELECT COUNT(*) INTO total_subscribers 
    FROM subscriptions 
    WHERE subscribed_to = userId;

    RETURN total_subscribers;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `GetTotalVideoDurationByUser` (`userId` VARCHAR(191)) RETURNS DECIMAL(10,2) DETERMINISTIC BEGIN
    DECLARE total_duration DECIMAL(10,2);

    SELECT SUM(duration) INTO total_duration 
    FROM videos 
    WHERE user_id = userId;

    RETURN IFNULL(total_duration, 0);
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `GetTotalVideosByUser` (`userId` VARCHAR(191)) RETURNS INT(11) DETERMINISTIC BEGIN
    DECLARE total_videos INT;
    
    SELECT COUNT(*) INTO total_videos 
    FROM videos 
    WHERE user_id = userId;
    
    RETURN total_videos;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `GetUserData` (`userId` VARCHAR(191)) RETURNS JSON DETERMINISTIC BEGIN
    DECLARE userData json;

    SELECT * INTO userData
    FROM users 
    WHERE id = userId;

    RETURN userData;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `commentlikes`
--

CREATE TABLE `commentlikes` (
  `id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `comment_id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `commentlikes`
--

INSERT INTO `commentlikes` (`id`, `comment_id`, `user_id`) VALUES
('cm7f92bv8003xl9xklmvfpz60', 'cm7f92bu4002dl9xkvu6xximd', 'cm7f92brg0000l9xkdq3k9lx5'),
('cm7f92bvb003zl9xk27d1hkpb', 'cm7f92bue002rl9xkwrfdpbut', 'cm7f92bs10005l9xkoj6gl33w'),
('cm7f92bvd0041l9xktu8p9jpz', 'cm7f92bu9002jl9xko99ueitf', 'cm7f92bs30006l9xkv6wxm538'),
('cm7f92bve0043l9xk5xoweulf', 'cm7f92bu7002hl9xknuwcw4y6', 'cm7f92bsa0009l9xkcmvifr8w'),
('cm7f92bvf0045l9xkvxbonfnz', 'cm7f92bu9002jl9xko99ueitf', 'cm7f92brx0003l9xkg5q1bupf'),
('cm7f92bvg0047l9xkomqkxxkj', 'cm7f92bub002nl9xkm7xbelxo', 'cm7f92bsa0009l9xkcmvifr8w'),
('cm7f92bvi0049l9xkcgjuoea8', 'cm7f92bu9002jl9xko99ueitf', 'cm7f92brt0002l9xk1l1mww2w'),
('cm7f92bvj004bl9xkw9q8b857', 'cm7f92bud002pl9xkiojzp0gv', 'cm7f92brz0004l9xkciktdjtp'),
('cm7f92bvk004dl9xkcz31ekq1', 'cm7f92bub002nl9xkm7xbelxo', 'cm7f92bs80008l9xk72w5f1ar'),
('cm7f92bvl004fl9xk6cihwb6d', 'cm7f92bua002ll9xkkjugmnya', 'cm7f92brt0002l9xk1l1mww2w');

-- --------------------------------------------------------

--
-- Table structure for table `commentreplies`
--

CREATE TABLE `commentreplies` (
  `id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `comment_id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `comment` longtext COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `commentreplies`
--

INSERT INTO `commentreplies` (`id`, `comment_id`, `user_id`, `comment`) VALUES
('cm7f92buu003dl9xkpcp53vra', 'cm7f92bu9002jl9xko99ueitf', 'cm7f92brt0002l9xk1l1mww2w', 'Nostrum sui alii cervus. Corrumpo venia laborum tantillus quaerat antea trepide maxime. Adhuc sursum vae defluo consequuntur adulescens cernuus ait.'),
('cm7f92buw003fl9xkvjh41jz0', 'cm7f92bue002rl9xkwrfdpbut', 'cm7f92bsa0009l9xkcmvifr8w', 'Adversus repellat conturbo ventito custodia. Claro cernuus assentator tollo ut cuius utroque aperio credo ustulo. Tendo officiis tam deorsum.'),
('cm7f92buy003hl9xkb4o3u6g8', 'cm7f92bub002nl9xkm7xbelxo', 'cm7f92brq0001l9xkt54701rc', 'Cedo possimus suffragium aureus. Cognomen alii succedo cur sint. Aqua officia armarium sit.'),
('cm7f92buz003jl9xk4da862vn', 'cm7f92bu6002fl9xkf55ufnv9', 'cm7f92brt0002l9xk1l1mww2w', 'Laborum auditor deporto. Perspiciatis patruus curiositas audacia calcar vado praesentium. Aegrotatio confido tego.'),
('cm7f92bv1003ll9xk9ac7atju', 'cm7f92bub002nl9xkm7xbelxo', 'cm7f92bs10005l9xkoj6gl33w', 'Ullam velit tibi suscipio beatus conforto desipio ceno. Temptatio suppono sursum vetus tui turpis socius. Tenuis pauci vesica.'),
('cm7f92bv2003nl9xkw98kx3l0', 'cm7f92bu00029l9xks9nm7sry', 'cm7f92bs10005l9xkoj6gl33w', 'Defendo candidus corpus sperno. Amplexus sit compono talio defessus canonicus eos trado. Deprimo dolorem curis volaticus credo tepesco tamen vesica.'),
('cm7f92bv3003pl9xkvv03m0ie', 'cm7f92bua002ll9xkkjugmnya', 'cm7f92bsa0009l9xkcmvifr8w', 'Sophismata artificiose animi antea speciosus vulnero et arbor. Bonus beatae canis ater dedecor. Curso carcer ut minus dolorum adstringo.'),
('cm7f92bv5003rl9xk0hmprro4', 'cm7f92bu2002bl9xkma58pkvc', 'cm7f92brx0003l9xkg5q1bupf', 'Tempora nulla currus cura. Tabesco amo usus textus bene adficio conturbo. Cornu adaugeo dolores capio curtus curis abbas arma crur.'),
('cm7f92bv6003tl9xk7ktn8uy1', 'cm7f92bu6002fl9xkf55ufnv9', 'cm7f92brt0002l9xk1l1mww2w', 'Adiuvo urbanus creator adaugeo appositus consequatur videlicet molestiae subvenio. Auctor adnuo suggero calco vulgaris suspendo. Coepi combibo approbo.'),
('cm7f92bv7003vl9xkg8xehkv2', 'cm7f92bu00029l9xks9nm7sry', 'cm7f92bs80008l9xk72w5f1ar', 'Aggero contego baiulus totus caelestis adulescens caveo. Aetas subseco absum. Supplanto urbanus caries atque.');

-- --------------------------------------------------------

--
-- Table structure for table `commentreports`
--

CREATE TABLE `commentreports` (
  `id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `comment_id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `reason` longtext COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `commentreports`
--

INSERT INTO `commentreports` (`id`, `comment_id`, `user_id`, `reason`) VALUES
('cm7f92buf002tl9xkdnmgmdqo', 'cm7f92bu00029l9xks9nm7sry', 'cm7f92brq0001l9xkt54701rc', 'Ultra torqueo tabella circumvenio aegrotatio peccatus aeneus surgo. Trans suppono argentum. Ars molestiae eligendi solium tepidus tactus.'),
('cm7f92bui002vl9xk07suhzj0', 'cm7f92bub002nl9xkm7xbelxo', 'cm7f92bsa0009l9xkcmvifr8w', 'Admoveo crapula id clementia tabula vilicus. Varius carpo currus uxor adsidue ventosus culpo. Verbum ait libero peccatus patior temptatio.'),
('cm7f92buj002xl9xkdt9z6nxg', 'cm7f92bud002pl9xkiojzp0gv', 'cm7f92brq0001l9xkt54701rc', 'Denique sufficio vere voluntarius sordeo tero aegrus tempus esse vir. Bellicus tersus articulus aliquid canto vilitas. Conitor taceo depulso ultra depopulo.'),
('cm7f92buk002zl9xk16iaqmgx', 'cm7f92bu2002bl9xkma58pkvc', 'cm7f92bs50007l9xkb5zkr5qy', 'Amplexus degusto una excepturi. Suadeo voluptatibus amitto clibanus venia copia cerno accendo amo. Acquiro facere commemoro labore.'),
('cm7f92bum0031l9xko26xid8k', 'cm7f92bub002nl9xkm7xbelxo', 'cm7f92bs50007l9xkb5zkr5qy', 'Aegrus dolor praesentium avarus corrumpo eos canis. Convoco distinctio ancilla tristis error quae aggero animadverto optio. Suasoria temporibus credo aliqua considero constans vitium audacia ancilla molestiae.'),
('cm7f92bun0033l9xkuz9iald2', 'cm7f92bu2002bl9xkma58pkvc', 'cm7f92brz0004l9xkciktdjtp', 'Adduco trepide caecus neque defaeco libero. Traho sublime adduco quaerat ait sequi. Abstergo suppellex amiculum aro vorax curis calco.'),
('cm7f92buo0035l9xka530roxl', 'cm7f92bua002ll9xkkjugmnya', 'cm7f92brg0000l9xkdq3k9lx5', 'Carbo apparatus facilis. Anser tubineus ancilla solium ocer abeo temeritas. Tollo admoveo ulciscor arbustum supra tenetur verecundia alienus.'),
('cm7f92buq0037l9xkyn33setb', 'cm7f92bu00029l9xks9nm7sry', 'cm7f92brq0001l9xkt54701rc', 'Aro harum arbitro adulescens articulus ascit sortitus accusamus aliqua. Synagoga cimentarius appositus. Tactus officiis deserunt deporto apud defungo vinco cubicularis consequuntur.'),
('cm7f92bur0039l9xkpqxhuxtn', 'cm7f92bu4002dl9xkvu6xximd', 'cm7f92brg0000l9xkdq3k9lx5', 'Debitis repudiandae bonus coadunatio fugit confido tabula. Tracto vomito totus turbo vestrum laudantium pariatur stultus thymum crux. Coepi aliquid centum cohaero urbanus audentia terror voco.'),
('cm7f92bus003bl9xkotz3omaf', 'cm7f92bua002ll9xkkjugmnya', 'cm7f92bs80008l9xk72w5f1ar', 'Altus volva cilicium. Confero taedium sordeo. Crustulum itaque eum bibo tener.');

-- --------------------------------------------------------

--
-- Table structure for table `creatormembers`
--

CREATE TABLE `creatormembers` (
  `id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `member_id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `membership_id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `membership_status` enum('active','inactive') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'active',
  `createdAt` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updatedAt` datetime(3) NOT NULL,
  `deletedAt` datetime(3) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `creatormembers`
--

INSERT INTO `creatormembers` (`id`, `member_id`, `membership_id`, `membership_status`, `createdAt`, `updatedAt`, `deletedAt`) VALUES
('cm7f92c1t00bzl9xkmq92zt5c', 'cm7f92brt0002l9xk1l1mww2w', 'cm7f92bxv007hl9xk21y631e4', 'active', '2025-02-21 20:55:04.577', '2025-02-21 20:55:04.577', NULL),
('cm7f92c1v00c1l9xkqguv0478', 'cm7f92bs10005l9xkoj6gl33w', 'cm7f92bxq0079l9xkio3p5jbr', 'inactive', '2025-02-21 20:55:04.580', '2025-02-21 20:55:04.580', NULL),
('cm7f92c1x00c3l9xkyulvo3ik', 'cm7f92brq0001l9xkt54701rc', 'cm7f92bxk0071l9xkkuq754ve', 'active', '2025-02-21 20:55:04.581', '2025-02-21 20:55:04.581', NULL),
('cm7f92c1y00c5l9xkwa3mido0', 'cm7f92bsa0009l9xkcmvifr8w', 'cm7f92bxi006zl9xkub3a7vu9', 'inactive', '2025-02-21 20:55:04.583', '2025-02-21 20:55:04.583', NULL),
('cm7f92c2000c7l9xkyi23z4h8', 'cm7f92bs50007l9xkb5zkr5qy', 'cm7f92bxs007bl9xkjjh0umpg', 'inactive', '2025-02-21 20:55:04.584', '2025-02-21 20:55:04.584', NULL),
('cm7f92c2100c9l9xk37p4bsiv', 'cm7f92brx0003l9xkg5q1bupf', 'cm7f92bxm0073l9xkvg6vswif', 'inactive', '2025-02-21 20:55:04.586', '2025-02-21 20:55:04.586', NULL),
('cm7f92c2300cbl9xkkz025p2s', 'cm7f92brg0000l9xkdq3k9lx5', 'cm7f92bxi006zl9xkub3a7vu9', 'active', '2025-02-21 20:55:04.587', '2025-02-21 20:55:04.587', NULL),
('cm7f92c2400cdl9xkixdb2hfp', 'cm7f92bs30006l9xkv6wxm538', 'cm7f92bxq0079l9xkio3p5jbr', 'inactive', '2025-02-21 20:55:04.589', '2025-02-21 20:55:04.589', NULL),
('cm7f92c2500cfl9xkpto07h0k', 'cm7f92bs30006l9xkv6wxm538', 'cm7f92bxn0075l9xkdcc0ghvp', 'active', '2025-02-21 20:55:04.590', '2025-02-21 20:55:04.590', NULL),
('cm7f92c2700chl9xkpc1jhvbv', 'cm7f92bsa0009l9xkcmvifr8w', 'cm7f92bxq0079l9xkio3p5jbr', 'active', '2025-02-21 20:55:04.591', '2025-02-21 20:55:04.591', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `membershipbenefits`
--

CREATE TABLE `membershipbenefits` (
  `id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `benefit` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `membership_id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updatedAt` datetime(3) NOT NULL,
  `deletedAt` datetime(3) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `membershipbenefits`
--

INSERT INTO `membershipbenefits` (`id`, `benefit`, `membership_id`, `createdAt`, `updatedAt`, `deletedAt`) VALUES
('cm7f92bxx007jl9xkvdcuf9bm', 'Deorsum caelum amitto causa aiunt stabilis.', 'cm7f92bxq0079l9xkio3p5jbr', '2025-02-21 20:55:04.437', '2025-02-21 20:55:04.437', NULL),
('cm7f92bxz007ll9xkbd7e4rk8', 'Suffragium tamen pecto vulgus vorax socius totus censura credo defaeco.', 'cm7f92bxm0073l9xkvg6vswif', '2025-02-21 20:55:04.439', '2025-02-21 20:55:04.439', NULL),
('cm7f92by0007nl9xk4hx1p1mz', 'Ambitus patrocinor deorsum uter concedo ancilla delibero aestas cernuus.', 'cm7f92bxt007dl9xktmwap7al', '2025-02-21 20:55:04.441', '2025-02-21 20:55:04.441', NULL),
('cm7f92by1007pl9xkg29pkc14', 'Defendo calculus comminor eligendi cresco demitto.', 'cm7f92bxs007bl9xkjjh0umpg', '2025-02-21 20:55:04.442', '2025-02-21 20:55:04.442', NULL),
('cm7f92by3007rl9xkun47pgt9', 'Textilis advoco adipisci quo.', 'cm7f92bxi006zl9xkub3a7vu9', '2025-02-21 20:55:04.443', '2025-02-21 20:55:04.443', NULL),
('cm7f92by4007tl9xkffeomuck', 'Crastinus aiunt infit virtus.', 'cm7f92bxm0073l9xkvg6vswif', '2025-02-21 20:55:04.444', '2025-02-21 20:55:04.444', NULL),
('cm7f92by5007vl9xk8zncqbzo', 'Valetudo cauda celo.', 'cm7f92bxv007hl9xk21y631e4', '2025-02-21 20:55:04.446', '2025-02-21 20:55:04.446', NULL),
('cm7f92by7007xl9xk2wk0kjm2', 'Vulticulus fugiat temporibus arx voluptas verbum incidunt spargo aveho tempore.', 'cm7f92bxq0079l9xkio3p5jbr', '2025-02-21 20:55:04.447', '2025-02-21 20:55:04.447', NULL),
('cm7f92by8007zl9xkk7owj5ze', 'Tenuis sodalitas temperantia sortitus.', 'cm7f92bxu007fl9xka232s6ak', '2025-02-21 20:55:04.448', '2025-02-21 20:55:04.448', NULL),
('cm7f92by90081l9xky5wug2q0', 'Voluptatem tamen agnitio adsidue curo possimus capitulus terra adficio accusamus.', 'cm7f92bxm0073l9xkvg6vswif', '2025-02-21 20:55:04.450', '2025-02-21 20:55:04.450', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `memberships`
--

CREATE TABLE `memberships` (
  `id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `price` int(11) NOT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updatedAt` datetime(3) NOT NULL,
  `deletedAt` datetime(3) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `memberships`
--

INSERT INTO `memberships` (`id`, `user_id`, `name`, `price`, `createdAt`, `updatedAt`, `deletedAt`) VALUES
('cm7f92bxi006zl9xkub3a7vu9', 'cm7f92bs80008l9xk72w5f1ar', 'Gorgeous Aluminum Keyboard', 7293, '2025-02-21 20:55:04.423', '2025-02-21 20:55:04.423', NULL),
('cm7f92bxk0071l9xkkuq754ve', 'cm7f92brz0004l9xkciktdjtp', 'Sleek Wooden Soap', 23784, '2025-02-21 20:55:04.425', '2025-02-21 20:55:04.425', NULL),
('cm7f92bxm0073l9xkvg6vswif', 'cm7f92brq0001l9xkt54701rc', 'Soft Cotton Cheese', 39069, '2025-02-21 20:55:04.427', '2025-02-21 20:55:04.427', NULL),
('cm7f92bxn0075l9xkdcc0ghvp', 'cm7f92brg0000l9xkdq3k9lx5', 'Fantastic Gold Salad', 26523, '2025-02-21 20:55:04.428', '2025-02-21 20:55:04.428', NULL),
('cm7f92bxp0077l9xke8zahgc4', 'cm7f92bs80008l9xk72w5f1ar', 'Intelligent Plastic Pants', 15184, '2025-02-21 20:55:04.429', '2025-02-21 20:55:04.429', NULL),
('cm7f92bxq0079l9xkio3p5jbr', 'cm7f92bsa0009l9xkcmvifr8w', 'Recycled Gold Sausages', 10942, '2025-02-21 20:55:04.431', '2025-02-21 20:55:04.431', NULL),
('cm7f92bxs007bl9xkjjh0umpg', 'cm7f92brx0003l9xkg5q1bupf', 'Fantastic Plastic Chicken', 57605, '2025-02-21 20:55:04.432', '2025-02-21 20:55:04.432', NULL),
('cm7f92bxt007dl9xktmwap7al', 'cm7f92brz0004l9xkciktdjtp', 'Oriental Granite Shirt', 34426, '2025-02-21 20:55:04.433', '2025-02-21 20:55:04.433', NULL),
('cm7f92bxu007fl9xka232s6ak', 'cm7f92brg0000l9xkdq3k9lx5', 'Tasty Bronze Mouse', 26687, '2025-02-21 20:55:04.435', '2025-02-21 20:55:04.435', NULL),
('cm7f92bxv007hl9xk21y631e4', 'cm7f92bs80008l9xk72w5f1ar', 'Fresh Rubber Mouse', 36258, '2025-02-21 20:55:04.436', '2025-02-21 20:55:04.436', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `paymentmethodcategory`
--

CREATE TABLE `paymentmethodcategory` (
  `id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updatedAt` datetime(3) NOT NULL,
  `deletedAt` datetime(3) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `paymentmethodcategory`
--

INSERT INTO `paymentmethodcategory` (`id`, `name`, `createdAt`, `updatedAt`, `deletedAt`) VALUES
('cm7f92byb0082l9xkxbgeiz1n', 'Baby', '2025-02-21 20:55:04.451', '2025-02-21 20:55:04.451', NULL),
('cm7f92byd0083l9xkty0pw1f8', 'Music', '2025-02-21 20:55:04.453', '2025-02-21 20:55:04.453', NULL),
('cm7f92byf0084l9xki1h3vsqh', 'Books', '2025-02-21 20:55:04.455', '2025-02-21 20:55:04.455', NULL),
('cm7f92byg0085l9xkfgioiulh', 'Kids', '2025-02-21 20:55:04.456', '2025-02-21 20:55:04.456', NULL),
('cm7f92byh0086l9xkgo0xl0ws', 'Games', '2025-02-21 20:55:04.457', '2025-02-21 20:55:04.457', NULL),
('cm7f92byi0087l9xklu1g4s8j', 'Computers', '2025-02-21 20:55:04.458', '2025-02-21 20:55:04.458', NULL),
('cm7f92byk0088l9xkv3lkg9dl', 'Toys', '2025-02-21 20:55:04.460', '2025-02-21 20:55:04.460', NULL),
('cm7f92byl0089l9xki4hinskz', 'Computers', '2025-02-21 20:55:04.462', '2025-02-21 20:55:04.462', NULL),
('cm7f92byn008al9xk1cop2cbr', 'Outdoors', '2025-02-21 20:55:04.463', '2025-02-21 20:55:04.463', NULL),
('cm7f92byo008bl9xknbf2isy1', 'Industrial', '2025-02-21 20:55:04.465', '2025-02-21 20:55:04.465', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `paymentmethods`
--

CREATE TABLE `paymentmethods` (
  `id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `category_id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updatedAt` datetime(3) NOT NULL,
  `deletedAt` datetime(3) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `paymentmethods`
--

INSERT INTO `paymentmethods` (`id`, `category_id`, `name`, `createdAt`, `updatedAt`, `deletedAt`) VALUES
('cm7f92byp008dl9xkvxkcxz3n', 'cm7f92byn008al9xk1cop2cbr', 'Modern Cotton Fish', '2025-02-21 20:55:04.466', '2025-02-21 20:55:04.466', NULL),
('cm7f92bys008fl9xkt1yywqzr', 'cm7f92byo008bl9xknbf2isy1', 'Licensed Gold Bike', '2025-02-21 20:55:04.468', '2025-02-21 20:55:04.468', NULL),
('cm7f92byu008hl9xk4yau1e56', 'cm7f92byh0086l9xkgo0xl0ws', 'Handmade Concrete Chicken', '2025-02-21 20:55:04.470', '2025-02-21 20:55:04.470', NULL),
('cm7f92byv008jl9xk9n8u1yo7', 'cm7f92byf0084l9xki1h3vsqh', 'Electronic Steel Soap', '2025-02-21 20:55:04.471', '2025-02-21 20:55:04.471', NULL),
('cm7f92byw008ll9xkua397urw', 'cm7f92byn008al9xk1cop2cbr', 'Soft Plastic Mouse', '2025-02-21 20:55:04.473', '2025-02-21 20:55:04.473', NULL),
('cm7f92byx008nl9xkpju1iixn', 'cm7f92byd0083l9xkty0pw1f8', 'Luxurious Marble Gloves', '2025-02-21 20:55:04.474', '2025-02-21 20:55:04.474', NULL),
('cm7f92byz008pl9xkmpc5px0d', 'cm7f92byd0083l9xkty0pw1f8', 'Elegant Aluminum Fish', '2025-02-21 20:55:04.475', '2025-02-21 20:55:04.475', NULL),
('cm7f92bz0008rl9xkeg7jh5ec', 'cm7f92byl0089l9xki4hinskz', 'Sleek Plastic Towels', '2025-02-21 20:55:04.476', '2025-02-21 20:55:04.476', NULL),
('cm7f92bz1008tl9xk32n0md5c', 'cm7f92byi0087l9xklu1g4s8j', 'Rustic Granite Tuna', '2025-02-21 20:55:04.478', '2025-02-21 20:55:04.478', NULL),
('cm7f92bz2008vl9xks0gp5e2u', 'cm7f92byo008bl9xknbf2isy1', 'Tasty Steel Mouse', '2025-02-21 20:55:04.479', '2025-02-21 20:55:04.479', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `playlistsaved`
--

CREATE TABLE `playlistsaved` (
  `id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `playlist_id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `playlistvideos`
--

CREATE TABLE `playlistvideos` (
  `id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `video_id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `playlist_id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `playlistvideos`
--

INSERT INTO `playlistvideos` (`id`, `video_id`, `playlist_id`) VALUES
('cm7f92bx5006fl9xkdmcknum8', 'cm7f92bt4000zl9xkbw6c39bt', 'cm7f92bx00067l9xkc98259q0'),
('cm7f92bx7006hl9xkmm3plfeh', 'cm7f92bt1000vl9xkzvtyo0aj', 'cm7f92bwt005xl9xkp5jr3iav'),
('cm7f92bx8006jl9xkjxxx3ff1', 'cm7f92bsy000rl9xkt4vcmr8c', 'cm7f92bx3006dl9xkn4wpat5y'),
('cm7f92bxa006ll9xk4a2l7itq', 'cm7f92bsu000nl9xkwnut4907', 'cm7f92bx00067l9xkc98259q0'),
('cm7f92bxb006nl9xkp4ld1qzl', 'cm7f92bt4000zl9xkbw6c39bt', 'cm7f92bwq005vl9xk3jdmlkq2'),
('cm7f92bxc006pl9xk81physw3', 'cm7f92bt0000tl9xkvzfwx16o', 'cm7f92bx2006bl9xk2ysl7x4f'),
('cm7f92bxd006rl9xk4bkrlxva', 'cm7f92bt60011l9xkwkc37y4t', 'cm7f92bx10069l9xkfi74jh10'),
('cm7f92bxe006tl9xkj3qdle90', 'cm7f92bt1000vl9xkzvtyo0aj', 'cm7f92bx2006bl9xk2ysl7x4f'),
('cm7f92bxf006vl9xkq9wtih6h', 'cm7f92bsu000nl9xkwnut4907', 'cm7f92bx00067l9xkc98259q0'),
('cm7f92bxh006xl9xk5vj3yjb5', 'cm7f92bsw000pl9xk27vehlk1', 'cm7f92bwy0065l9xkh8m1t0pd');

-- --------------------------------------------------------

--
-- Table structure for table `premiumpackages`
--

CREATE TABLE `premiumpackages` (
  `id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `price` int(11) NOT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updatedAt` datetime(3) NOT NULL,
  `deletedAt` datetime(3) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `premiumpackages`
--

INSERT INTO `premiumpackages` (`id`, `name`, `price`, `createdAt`, `updatedAt`, `deletedAt`) VALUES
('cm7f92bz4008wl9xk5sym8ieb', 'Elegant Wooden Bacon', 920106, '2025-02-21 20:55:04.480', '2025-02-21 20:55:04.480', NULL),
('cm7f92bz6008xl9xklff52o64', 'Gorgeous Bamboo Mouse', 991107, '2025-02-21 20:55:04.483', '2025-02-21 20:55:04.483', NULL),
('cm7f92bz8008yl9xk6ncwipdi', 'Small Marble Chips', 979951, '2025-02-21 20:55:04.484', '2025-02-21 20:55:04.484', NULL),
('cm7f92bz9008zl9xkil88bsww', 'Luxurious Cotton Bike', 842077, '2025-02-21 20:55:04.485', '2025-02-21 20:55:04.485', NULL),
('cm7f92bza0090l9xkbf73axgk', 'Unbranded Steel Ball', 178218, '2025-02-21 20:55:04.487', '2025-02-21 20:55:04.487', NULL),
('cm7f92bzb0091l9xkgylsrqx5', 'Recycled Bronze Towels', 672075, '2025-02-21 20:55:04.488', '2025-02-21 20:55:04.488', NULL),
('cm7f92bzc0092l9xkk8wdfzm7', 'Awesome Plastic Hat', 151607, '2025-02-21 20:55:04.489', '2025-02-21 20:55:04.489', NULL),
('cm7f92bzd0093l9xke478hnkf', 'Awesome Bamboo Chair', 558747, '2025-02-21 20:55:04.490', '2025-02-21 20:55:04.490', NULL),
('cm7f92bzf0094l9xkkrpy2vuo', 'Incredible Cotton Cheese', 253292, '2025-02-21 20:55:04.491', '2025-02-21 20:55:04.491', NULL),
('cm7f92bzg0095l9xkiubvl7t6', 'Refined Silk Table', 990282, '2025-02-21 20:55:04.492', '2025-02-21 20:55:04.492', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `subscriptions`
--

CREATE TABLE `subscriptions` (
  `id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_creator_id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_watcher_id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `notification_status` enum('true','false') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'false'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `subscriptions`
--

INSERT INTO `subscriptions` (`id`, `user_creator_id`, `user_watcher_id`, `notification_status`) VALUES
('cm7f92c1f00bol9xkss8xntzf', 'cm7f92bs30006l9xkv6wxm538', 'cm7f92bs10005l9xkoj6gl33w', 'false'),
('cm7f92c1i00bpl9xkfzdtlplb', 'cm7f92bsa0009l9xkcmvifr8w', 'cm7f92bs10005l9xkoj6gl33w', 'true'),
('cm7f92c1j00bql9xkwkdyi535', 'cm7f92bs10005l9xkoj6gl33w', 'cm7f92brz0004l9xkciktdjtp', 'false'),
('cm7f92c1k00brl9xkdh8mfphn', 'cm7f92brz0004l9xkciktdjtp', 'cm7f92bsa0009l9xkcmvifr8w', 'false'),
('cm7f92c1m00bsl9xkzcz2mnbz', 'cm7f92bs10005l9xkoj6gl33w', 'cm7f92bs80008l9xk72w5f1ar', 'true'),
('cm7f92c1n00btl9xko1gcweq3', 'cm7f92bs30006l9xkv6wxm538', 'cm7f92bsa0009l9xkcmvifr8w', 'true'),
('cm7f92c1o00bul9xkhjnppwft', 'cm7f92bsa0009l9xkcmvifr8w', 'cm7f92brz0004l9xkciktdjtp', 'false'),
('cm7f92c1p00bvl9xk0p9kfl3i', 'cm7f92bs80008l9xk72w5f1ar', 'cm7f92brq0001l9xkt54701rc', 'true'),
('cm7f92c1q00bwl9xkw4krnh8g', 'cm7f92brt0002l9xk1l1mww2w', 'cm7f92bsa0009l9xkcmvifr8w', 'true'),
('cm7f92c1r00bxl9xk2eq16zby', 'cm7f92brt0002l9xk1l1mww2w', 'cm7f92brx0003l9xkg5q1bupf', 'true');

-- --------------------------------------------------------

--
-- Table structure for table `tags`
--

CREATE TABLE `tags` (
  `id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updatedAt` datetime(3) NOT NULL,
  `deletedAt` datetime(3) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `tags`
--

INSERT INTO `tags` (`id`, `name`, `createdAt`, `updatedAt`, `deletedAt`) VALUES
('cm7f92bvn004gl9xkp1by5qee', 'slipper', '2025-02-21 20:55:04.355', '2025-02-21 20:55:04.355', NULL),
('cm7f92bvp004hl9xkppr9qrdg', 'comparison', '2025-02-21 20:55:04.357', '2025-02-21 20:55:04.357', NULL),
('cm7f92bvr004il9xktbbdscg4', 'adviser', '2025-02-21 20:55:04.359', '2025-02-21 20:55:04.359', NULL),
('cm7f92bvs004jl9xk4qih0bit', 'epic', '2025-02-21 20:55:04.361', '2025-02-21 20:55:04.361', NULL),
('cm7f92bvt004kl9xkayoecovx', 'bowling', '2025-02-21 20:55:04.362', '2025-02-21 20:55:04.362', NULL),
('cm7f92bvu004ll9xkjnbqrw8q', 'plain', '2025-02-21 20:55:04.363', '2025-02-21 20:55:04.363', NULL),
('cm7f92bvw004ml9xkhpmrsye8', 'sanity', '2025-02-21 20:55:04.364', '2025-02-21 20:55:04.364', NULL),
('cm7f92bvx004nl9xkwchva12o', 'antelope', '2025-02-21 20:55:04.365', '2025-02-21 20:55:04.365', NULL),
('cm7f92bvy004ol9xkju4p17bf', 'swim', '2025-02-21 20:55:04.366', '2025-02-21 20:55:04.366', NULL),
('cm7f92bvz004pl9xkwjs1si6f', 'fedora', '2025-02-21 20:55:04.367', '2025-02-21 20:55:04.367', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `trendingvideo`
--

CREATE TABLE `trendingvideo` (
  `id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `video_id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `videoCategory_id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `trendingvideo`
--

INSERT INTO `trendingvideo` (`id`, `video_id`, `videoCategory_id`) VALUES
('cm7f92bwd005bl9xkb94s9ps1', 'cm7f92bsq000ll9xk7ybcikso', 'cm7f92bsk000fl9xkrh77nxgt'),
('cm7f92bwf005dl9xk3frczsug', 'cm7f92bt60011l9xkwkc37y4t', 'cm7f92bsf000bl9xkk5e9p2y7'),
('cm7f92bwh005fl9xkrro1ij3c', 'cm7f92bsy000rl9xkt4vcmr8c', 'cm7f92bsj000el9xkwkrobyo2'),
('cm7f92bwi005hl9xkkq9ufp2u', 'cm7f92bsw000pl9xk27vehlk1', 'cm7f92bsj000el9xkwkrobyo2'),
('cm7f92bwj005jl9xki7mv616b', 'cm7f92bt60011l9xkwkc37y4t', 'cm7f92bsj000el9xkwkrobyo2'),
('cm7f92bwk005ll9xkeo46ne4k', 'cm7f92bt60011l9xkwkc37y4t', 'cm7f92bsk000fl9xkrh77nxgt'),
('cm7f92bwl005nl9xkyj5hr6go', 'cm7f92bsw000pl9xk27vehlk1', 'cm7f92bsk000fl9xkrh77nxgt'),
('cm7f92bwn005pl9xkx8bdjexe', 'cm7f92bsw000pl9xk27vehlk1', 'cm7f92bsn000hl9xkl73lt5m6'),
('cm7f92bwo005rl9xk03aurmqr', 'cm7f92bt4000zl9xkbw6c39bt', 'cm7f92bsi000dl9xkdk0nroyc'),
('cm7f92bwp005tl9xkcq03vtx9', 'cm7f92bsu000nl9xkwnut4907', 'cm7f92bso000il9xkoatpxgvc');

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

CREATE TABLE `user` (
  `id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `google_id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `account_status` enum('free','premium') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'free',
  `avatar_url` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `account_activation` enum('active','inactive') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'active',
  `bio` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `membership_open` enum('true','false') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'false',
  `membership_video_url` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updatedAt` datetime(3) NOT NULL,
  `deletedAt` datetime(3) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `user`
--

INSERT INTO `user` (`id`, `email`, `name`, `google_id`, `account_status`, `avatar_url`, `account_activation`, `bio`, `membership_open`, `membership_video_url`, `createdAt`, `updatedAt`, `deletedAt`) VALUES
('cm7f90zv10000l9so6kz864zs', 'Hiram_Padberg86@gmail.com', 'Nora Tremblay', 'dd4087da-3831-42a7-8ea2-b6bd52d7b988', 'free', 'https://avatars.githubusercontent.com/u/62537363', 'inactive', 'Candidus turpis validus cavus adficio ambitus amplexus vorago spectaculum. Tergeo teneo pariatur canis pecto caries. Caelum adsidue adulatio deserunt considero terminatio complectus.', 'true', 'https://paltry-fraudster.info', '2025-02-21 20:54:02.124', '2025-02-21 20:54:02.124', NULL),
('cm7f90zvg0001l9so9xvlljog', 'Rossie_Labadie69@yahoo.com', 'Sidney Murazik', '280df475-36b6-4879-a08d-ad3f39bb155d', 'premium', 'https://cdn.jsdelivr.net/gh/faker-js/assets-person-portrait/female/512/27.jpg', 'inactive', 'Defetiscor arto angustus apud vociferor verumtamen speciosus voluptatibus. Terror combibo corona demo. Reiciendis consuasor suasoria auxilium desparatus aspernatur comis in.', 'true', 'https://empty-battle.com/', '2025-02-21 20:54:02.140', '2025-02-21 20:54:02.140', NULL),
('cm7f90zvj0002l9so04jxy4ck', 'Buford.OHara@hotmail.com', 'Georgia Fritsch', 'ca873a9f-5b8a-4199-a10e-f58121d33583', 'free', 'https://avatars.githubusercontent.com/u/64082221', 'inactive', 'Totus cornu compono utroque avarus. Ancilla torqueo claustrum. Conqueror officia approbo suppellex altus votum.', 'true', 'https://grave-final.info/', '2025-02-21 20:54:02.143', '2025-02-21 20:54:02.143', NULL),
('cm7f90zvk0003l9sowiigsbb6', 'Kellen.Zemlak@yahoo.com', 'Alfonso Tromp', '23a0b175-6058-4ff7-942e-97a6ca04e34b', 'premium', 'https://avatars.githubusercontent.com/u/23516554', 'active', 'Coruscus argumentum ait. Adaugeo caecus demum perspiciatis utrimque laudantium vos. Vae theologus depopulo abstergo sollers.', 'false', 'https://lonely-legislature.biz', '2025-02-21 20:54:02.145', '2025-02-21 20:54:02.145', NULL),
('cm7f90zvm0004l9sokrc419b5', 'Jewell.Kihn@gmail.com', 'Dr. Ora Wyman', '75027ff8-247c-4552-b7ae-89bf7e9cdb6a', 'premium', 'https://avatars.githubusercontent.com/u/73636324', 'inactive', 'Sponte subito cometes. Vix accusantium barba. Aggredior pecto nobis amissio consequuntur comminor voluptate considero cinis.', 'false', 'https://gaseous-traditionalism.com/', '2025-02-21 20:54:02.147', '2025-02-21 20:54:02.147', NULL),
('cm7f90zvo0005l9soa54kesaf', 'Sage_Buckridge@gmail.com', 'Carla Towne', 'b722b919-416a-4983-a177-7da73050623e', 'premium', 'https://avatars.githubusercontent.com/u/99439129', 'inactive', 'Id vacuus audio universe administratio tondeo communis cena dolorem. Denuo incidunt tamquam. Constans blandior tres ascisco somniculosus avaritia compello utroque adhuc.', 'false', 'https://well-documented-soybean.org', '2025-02-21 20:54:02.149', '2025-02-21 20:54:02.149', NULL),
('cm7f90zvq0006l9sogjtiusxz', 'Rebeka41@gmail.com', 'Al Satterfield', 'fe87e5e1-5e64-4cde-a11f-f5c0ffb9f39b', 'free', 'https://cdn.jsdelivr.net/gh/faker-js/assets-person-portrait/female/512/42.jpg', 'active', 'Coniuratio texo ultio perferendis celo. Aliquam aptus sopor ambulo acer. Vulnus video vado.', 'true', 'https://front-issue.info', '2025-02-21 20:54:02.151', '2025-02-21 20:54:02.151', NULL),
('cm7f90zvs0007l9so5la1qld1', 'Dee_Koepp16@gmail.com', 'Della Von', '46f7f14d-0129-4abb-86a6-9e73e0a0d2f8', 'free', 'https://cdn.jsdelivr.net/gh/faker-js/assets-person-portrait/female/512/13.jpg', 'inactive', 'Totidem torqueo magni attonbitus caelestis infit quod cognatus decretum. Repudiandae absum venia. Pecco curatio conqueror tutis accusator defluo sunt versus.', 'false', 'https://naughty-nougat.info', '2025-02-21 20:54:02.153', '2025-02-21 20:54:02.153', NULL),
('cm7f90zvv0008l9soo94dk5ip', 'Forest65@hotmail.com', 'Marshall Abshire', 'df82d573-d17d-4326-95c0-e16ad4b9868a', 'premium', 'https://cdn.jsdelivr.net/gh/faker-js/assets-person-portrait/female/512/40.jpg', 'inactive', 'Calamitas curto valetudo depromo. Ocer vinum balbus. Cenaculum vorax tepidus comparo succurro cattus.', 'false', 'https://unsteady-translation.com', '2025-02-21 20:54:02.155', '2025-02-21 20:54:02.155', NULL),
('cm7f90zvx0009l9soqlv6cq0c', 'Allan80@hotmail.com', 'Tara Harris', '7cdded0f-01e9-497a-8b52-2776cd96a820', 'free', 'https://cdn.jsdelivr.net/gh/faker-js/assets-person-portrait/male/512/19.jpg', 'inactive', 'Conculco suus tyrannus claustrum. Cognatus totidem vicissitudo textus deprimo asporto. Torrens ab adeptio apud sollers damno combibo.', 'false', 'https://terrible-bench.net', '2025-02-21 20:54:02.157', '2025-02-21 20:54:02.157', NULL),
('cm7f92brg0000l9xkdq3k9lx5', 'Carlos_Kovacek56@hotmail.com', 'Beverly Grimes', 'd2d85d01-931d-45de-84c0-33aeb320073e', 'free', 'https://cdn.jsdelivr.net/gh/faker-js/assets-person-portrait/male/512/6.jpg', 'active', 'Delego corporis vox vinum certe. Eius adstringo capillus tamisium comes pauci. Asporto stella reiciendis textus carus aequitas dens cupiditate confero.', 'true', 'https://favorite-spring.com/', '2025-02-21 20:55:04.204', '2025-02-21 20:55:04.204', NULL),
('cm7f92brq0001l9xkt54701rc', 'Rowena_Mitchell@gmail.com', 'Dr. Lori Zboncak', '34e38680-8ad2-4ffd-a3d1-3b2accfcdda0', 'free', 'https://cdn.jsdelivr.net/gh/faker-js/assets-person-portrait/female/512/9.jpg', 'inactive', 'Terror careo apud vergo. Cruciamentum curtus contabesco suggero succedo uxor adopto quasi decipio tondeo. Atrox perspiciatis accendo basium.', 'false', 'https://clueless-fat.com/', '2025-02-21 20:55:04.214', '2025-02-21 20:55:04.214', NULL),
('cm7f92brt0002l9xk1l1mww2w', 'Conner_Casper36@gmail.com', 'Donnie Buckridge', 'a9be4409-4f4c-42c8-b727-5c5638b42391', 'free', 'https://avatars.githubusercontent.com/u/78282407', 'inactive', 'Voluptate cupressus decumbo demum supra celer defluo. Cruciamentum voluntarius xiphias tenuis. Officiis sit ulciscor adsum ascisco.', 'false', 'https://lost-season.net', '2025-02-21 20:55:04.217', '2025-02-21 20:55:04.217', NULL),
('cm7f92brx0003l9xkg5q1bupf', 'Fleta.Beier@hotmail.com', 'Mr. Franklin King', 'cb4a1329-92ce-4b02-944a-e5b07234f1eb', 'free', 'https://avatars.githubusercontent.com/u/53194840', 'inactive', 'Atrocitas inventore thema aer. Adamo verbera casso curatio vito cetera. Magni cenaculum subiungo uredo aqua desipio.', 'false', 'https://fearless-tune-up.info/', '2025-02-21 20:55:04.221', '2025-02-21 20:55:04.221', NULL),
('cm7f92brz0004l9xkciktdjtp', 'Amani_Ferry21@hotmail.com', 'Clint Gerhold', 'e6e4dde7-86ea-49a9-a6c2-44fc4dceb57f', 'premium', 'https://cdn.jsdelivr.net/gh/faker-js/assets-person-portrait/female/512/75.jpg', 'active', 'Tego fugiat tam volutabrum porro autus rerum alter. Voluptatum capitulus sumptus correptius tollo caries attollo pax adflicto. Cito coaegresco alter accusamus peior pecco abstergo benevolentia alias deinde.', 'false', 'https://quiet-vicinity.name/', '2025-02-21 20:55:04.223', '2025-02-21 20:55:04.223', NULL),
('cm7f92bs10005l9xkoj6gl33w', 'Jared27@gmail.com', 'Pat Price', 'd48ffb96-1eeb-41b3-a1f8-ec2b730f7cda', 'free', 'https://cdn.jsdelivr.net/gh/faker-js/assets-person-portrait/male/512/17.jpg', 'active', 'Caries temptatio atqui veniam architecto vulnero. Velut denuncio tego. Quod decens vicissitudo dolorem ubi provident.', 'false', 'https://scared-pleasure.biz/', '2025-02-21 20:55:04.226', '2025-02-21 20:55:04.226', NULL),
('cm7f92bs30006l9xkv6wxm538', 'June_Fay@gmail.com', 'Sheri Thiel', '2adaeb19-2b0f-4472-9844-a990484a9108', 'premium', 'https://avatars.githubusercontent.com/u/43602180', 'inactive', 'Sono tyrannus surgo voco turpis. Corrumpo cinis cenaculum volo succurro adipisci natus necessitatibus. Assumenda acquiro arbor animus veniam.', 'true', 'https://wordy-taxicab.name/', '2025-02-21 20:55:04.228', '2025-02-21 20:55:04.228', NULL),
('cm7f92bs50007l9xkb5zkr5qy', 'Roma16@yahoo.com', 'Vincent Champlin', 'ba94004b-6d58-43c1-bef0-9fef63306f8f', 'free', 'https://cdn.jsdelivr.net/gh/faker-js/assets-person-portrait/female/512/74.jpg', 'inactive', 'Quas tantum truculenter succurro absconditus vere consectetur videlicet utrimque aureus. Trado adsum angulus decipio vigilo thorax. Cognatus cumque perspiciatis aestivus taedium.', 'true', 'https://lovable-characterization.com/', '2025-02-21 20:55:04.230', '2025-02-21 20:55:04.230', NULL),
('cm7f92bs80008l9xk72w5f1ar', 'Adolph71@gmail.com', 'Miss Emily Bahringer', 'e3b6d655-51eb-4719-b582-cd267bc170df', 'premium', 'https://avatars.githubusercontent.com/u/39728470', 'active', 'Pecto tenax chirographum. Sublime dolorem vicissitudo vicissitudo coma tabgo. Cauda totam ad copia cognatus cognomen deputo totam vel ceno.', 'true', 'https://crafty-heartbeat.net', '2025-02-21 20:55:04.232', '2025-02-21 20:55:04.232', NULL),
('cm7f92bsa0009l9xkcmvifr8w', 'Annie54@hotmail.com', 'Frank Robel', '4472859a-60f5-4439-89ef-e3a394c20b3a', 'premium', 'https://cdn.jsdelivr.net/gh/faker-js/assets-person-portrait/male/512/81.jpg', 'inactive', 'Vesica attollo suppellex totus spoliatio attero antea. Absum adinventitias volaticus umquam stips adstringo. Verumtamen tabgo turbo censura admoveo appello tertius sunt officia.', 'false', 'https://second-hand-drive.org/', '2025-02-21 20:55:04.235', '2025-02-21 20:55:04.235', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `usercommunitypost`
--

CREATE TABLE `usercommunitypost` (
  `id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `content` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` enum('public','private') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'public'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `usercommunitypost`
--

INSERT INTO `usercommunitypost` (`id`, `content`, `status`) VALUES
('cm7f92c0o00aul9xkxo1ki9yo', 'Venia conventus suffoco thermae sufficio. Temeritas valens comptus conforto. Volutabrum suppellex torqueo coniuratio.\nApostolus placeat solium corrupti vilicus causa caritas officiis. Summa callide uterque curatio claudeo deleniti. Adhuc commemoro vestrum ventosus facere consectetur.\nPossimus amita cura teres volup. Aggero sequi abeo. Sit vitae derideo esse suggero sumo custodia tonsor placeat ambulo.', 'public'),
('cm7f92c0q00avl9xk0kuf1kc1', 'Accusantium ascit adipiscor supellex succurro calco paens tamen desparatus. Decumbo volutabrum vesica tepesco ambitus coniecto. Suscipit vorax surculus truculenter dedecor odit velociter.\nAvarus tametsi sublime tumultus clam blanditiis suscipio amplus eligendi. Sopor volva absque. Baiulus stipes beatae despecto antiquus aspernatur tendo cubo.\nVesco una virtus acerbitas. Delectatio aedificium calcar tersus odio averto mollitia cognomen. Nihil supellex demulceo cornu.', 'private'),
('cm7f92c0s00awl9xkp5nextik', 'Conspergo tametsi solum paulatim civitas amoveo quaerat studio. Culpo defungo infit arx universe hic. Avaritia basium temporibus speculum demonstro accusantium.\nNihil atavus conitor annus. Vitae clamo doloremque est. Sponte debilito delibero sub error sursum contigo strues video vos.\nAmplus atque itaque subito cum eveniet. Crebro curto vilis. Cruentus velum voveo fugiat similique conservo curatio cruentus artificiose pauper.', 'private'),
('cm7f92c0t00axl9xkupl2d0l0', 'Summopere subnecto cuius tutis auctus vado causa est casus umerus. Sopor ver defessus abduco. Cumque subseco odio stipes solutio tametsi turbo tertius.\nAter crudelis tener abutor defendo strues tergeo cimentarius totidem callide. Abstergo cunabula audax. Virga succedo sulum cubo celo omnis.\nCrur beneficium tamdiu suffragium apud caritas tabesco uterque calcar candidus. Crepusculum vilitas expedita tepidus crepusculum adamo acerbitas cunabula uter. Alveus valde vindico dedico infit canto temeritas degenero.', 'private'),
('cm7f92c0u00ayl9xkenuccv4i', 'Accendo arbor temeritas sopor. Cuius saepe beatus allatus adnuo coerceo. Patria careo usus.\nSuscipio agnitio bis. Triumphus canto tepidus argumentum molestias clarus avaritia vito arguo. Tristis pecco canonicus voluptatem vado assentator.\nUxor quos cognatus curvo cohibeo tempora similique decerno enim bellum. Concedo sono patior adeo amplitudo stella timidus callide. Assentator calcar aduro adficio cognatus turbo.', 'public'),
('cm7f92c0w00azl9xkha219m6l', 'Laboriosam ventosus arguo accendo cedo sufficio laudantium advoco. Claro sublime aequus candidus. Valetudo ocer dedico vis vereor calcar amissio vulgo subseco.\nRem basium amaritudo ustilo volup. Tripudio argentum apto tener ager quam aperte trucido corona harum. Repudiandae utpote atqui suscipio necessitatibus cresco.\nTergum nesciunt mollitia aperte assentator ater aurum. Crur pecus termes quam ventito versus adulescens validus. Sopor uterque voluptas esse.', 'public'),
('cm7f92c0x00b0l9xkdysx8zo3', 'Suasoria bonus valeo. Non audax adulescens ipsam attero cariosus constans eveniet facilis utique. Vapulus adhuc attero demoror spiritus.\nSurgo veniam vomica cena deinde calco catena eveniet eveniet. Universe placeat censura illum. Harum vulticulus aegrotatio claudeo bellicus.\nVarius curia abduco cohors angulus subiungo defungo depulso. Arcus cultellus uterque viscus varius admitto cunabula curriculum vesper summa. Undique dolor consuasor vulpes depereo barba comedo.', 'public'),
('cm7f92c0y00b1l9xk5s95rewa', 'Brevis cimentarius accendo celer depulso vulnero. Vinitor vinco cubitum adstringo utrimque vulticulus pecus. Adipiscor basium distinctio vulnero vix conatus vulpes canis traho thymum.\nVos veniam vallum eveniet. Vester claro hic dolore ascisco sed aetas turpis. Suppellex suadeo voro quidem comptus delectus cruentus ademptio.\nVoluptatibus villa acies. Certe decens surgo spes. Arto uter amor spargo.', 'public'),
('cm7f92c0z00b2l9xk0k7z8n7q', 'Adimpleo caelestis bis cresco bellicus abeo contabesco. Cruentus quos surgo solitudo peior cariosus curtus. Demens cunctatio vos valens.\nOdit uredo benevolentia virtus versus viduo tempus adsuesco tabesco. Ancilla delectus super defero cupiditate commodi magni atque vinco. Suffragium tergeo nostrum.\nAdsum verbum traho denuo. Consectetur aperiam ter adiuvo apostolus articulus taedium. Sit deripio candidus creta creta conduco amor amor.', 'public'),
('cm7f92c1100b3l9xkw3a8jfhc', 'Addo ipsum sub vorax ceno. Tenuis pecto supra conicio distinctio laudantium. Congregatio cicuta angulus arbitro.\nUtrimque pecus combibo victus solutio perferendis comminor calcar stultus. Repellat eum pauci assumenda unde acerbitas. Trado conculco sono ipsa vero calamitas doloribus quo vergo annus.\nAequitas constans argumentum claudeo adsuesco abstergo deorsum absens. Turpis paens varius cuius tenus. Audacia testimonium omnis vindico cernuus.', 'private');

-- --------------------------------------------------------

--
-- Table structure for table `usermembershiptransactions`
--

CREATE TABLE `usermembershiptransactions` (
  `id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `transaction_id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `membership_id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `price` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `auto_renewal` enum('true','false') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'true',
  `createdAt` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updatedAt` datetime(3) NOT NULL,
  `deletedAt` datetime(3) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `usermembershiptransactions`
--

INSERT INTO `usermembershiptransactions` (`id`, `transaction_id`, `membership_id`, `price`, `auto_renewal`, `createdAt`, `updatedAt`, `deletedAt`) VALUES
('cm7f92c0900abl9xk4g96dhyn', 'cm7f92bzq009jl9xkh7xfg8cp', 'cm7f92bxn0075l9xkdcc0ghvp', '807245', 'true', '2025-02-21 20:55:04.522', '2025-02-21 20:55:04.522', NULL),
('cm7f92c0c00adl9xkehsalycn', 'cm7f92bzt009nl9xk13ldjfsn', 'cm7f92bxq0079l9xkio3p5jbr', '918805', 'true', '2025-02-21 20:55:04.524', '2025-02-21 20:55:04.524', NULL),
('cm7f92c0d00afl9xk2xv2q65t', 'cm7f92bzj0099l9xkt4en89kr', 'cm7f92bxv007hl9xk21y631e4', '465701', 'false', '2025-02-21 20:55:04.526', '2025-02-21 20:55:04.526', NULL),
('cm7f92c0f00ahl9xkxf2m0q3j', 'cm7f92bzt009nl9xk13ldjfsn', 'cm7f92bxi006zl9xkub3a7vu9', '117847', 'true', '2025-02-21 20:55:04.527', '2025-02-21 20:55:04.527', NULL),
('cm7f92c0g00ajl9xk4cic26vn', 'cm7f92bzu009pl9xk58fnbiqs', 'cm7f92bxt007dl9xktmwap7al', '612605', 'false', '2025-02-21 20:55:04.528', '2025-02-21 20:55:04.528', NULL),
('cm7f92c0h00all9xkl4crakwh', 'cm7f92bzo009fl9xkgsnhd8c9', 'cm7f92bxv007hl9xk21y631e4', '310174', 'true', '2025-02-21 20:55:04.529', '2025-02-21 20:55:04.529', NULL),
('cm7f92c0i00anl9xkaxt4ifuf', 'cm7f92bzu009pl9xk58fnbiqs', 'cm7f92bxt007dl9xktmwap7al', '492826', 'false', '2025-02-21 20:55:04.531', '2025-02-21 20:55:04.531', NULL),
('cm7f92c0k00apl9xk6qn3dir9', 'cm7f92bzm009dl9xko5pa1b8f', 'cm7f92bxu007fl9xka232s6ak', '643254', 'true', '2025-02-21 20:55:04.532', '2025-02-21 20:55:04.532', NULL),
('cm7f92c0l00arl9xkq37lvzda', 'cm7f92bzu009pl9xk58fnbiqs', 'cm7f92bxv007hl9xk21y631e4', '825479', 'true', '2025-02-21 20:55:04.533', '2025-02-21 20:55:04.533', NULL),
('cm7f92c0m00atl9xkcum7xjnz', 'cm7f92bzp009hl9xkhqnheafc', 'cm7f92bxi006zl9xkub3a7vu9', '918472', 'false', '2025-02-21 20:55:04.535', '2025-02-21 20:55:04.535', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `usernotificatons`
--

CREATE TABLE `usernotificatons` (
  `id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `video_id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `usernotificatons`
--

INSERT INTO `usernotificatons` (`id`, `user_id`, `video_id`) VALUES
('cm7f92c1200b5l9xk14broicv', 'cm7f92brx0003l9xkg5q1bupf', 'cm7f92bt60011l9xkwkc37y4t'),
('cm7f92c1400b7l9xk4xqx2q7m', 'cm7f92brz0004l9xkciktdjtp', 'cm7f92bt0000tl9xkvzfwx16o'),
('cm7f92c1600b9l9xkb4n2n3ej', 'cm7f92brq0001l9xkt54701rc', 'cm7f92bsu000nl9xkwnut4907'),
('cm7f92c1700bbl9xk9ovgonz0', 'cm7f92brg0000l9xkdq3k9lx5', 'cm7f92bt4000zl9xkbw6c39bt'),
('cm7f92c1900bdl9xkhwhmst1u', 'cm7f92bs80008l9xk72w5f1ar', 'cm7f92bt80013l9xktt76te4f'),
('cm7f92c1a00bfl9xkvwfulem1', 'cm7f92brt0002l9xk1l1mww2w', 'cm7f92bt4000zl9xkbw6c39bt'),
('cm7f92c1b00bhl9xkdrptxe97', 'cm7f92brx0003l9xkg5q1bupf', 'cm7f92bt1000vl9xkzvtyo0aj'),
('cm7f92c1c00bjl9xke75suy51', 'cm7f92bs10005l9xkoj6gl33w', 'cm7f92bsw000pl9xk27vehlk1'),
('cm7f92c1d00bll9xk2506dodg', 'cm7f92bs50007l9xkb5zkr5qy', 'cm7f92bt0000tl9xkvzfwx16o'),
('cm7f92c1e00bnl9xk4kzy449q', 'cm7f92bsa0009l9xkcmvifr8w', 'cm7f92bsy000rl9xkt4vcmr8c');

-- --------------------------------------------------------

--
-- Table structure for table `userplaylist`
--

CREATE TABLE `userplaylist` (
  `id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` enum('public','private') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'public',
  `createdAt` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updatedAt` datetime(3) NOT NULL,
  `deletedAt` datetime(3) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `userplaylist`
--

INSERT INTO `userplaylist` (`id`, `user_id`, `name`, `status`, `createdAt`, `updatedAt`, `deletedAt`) VALUES
('cm7f92bwq005vl9xk3jdmlkq2', 'cm7f92bsa0009l9xkcmvifr8w', 'adipiscor cura', 'private', '2025-02-21 20:55:04.395', '2025-02-21 20:55:04.395', NULL),
('cm7f92bwt005xl9xkp5jr3iav', 'cm7f92brg0000l9xkdq3k9lx5', 'tonsor eligendi', 'private', '2025-02-21 20:55:04.397', '2025-02-21 20:55:04.397', NULL),
('cm7f92bwv005zl9xk1llaoytk', 'cm7f92bs30006l9xkv6wxm538', 'vel advenio', 'public', '2025-02-21 20:55:04.399', '2025-02-21 20:55:04.399', NULL),
('cm7f92bww0061l9xkn5s63o4s', 'cm7f92brx0003l9xkg5q1bupf', 'magni paens', 'private', '2025-02-21 20:55:04.400', '2025-02-21 20:55:04.400', NULL),
('cm7f92bwx0063l9xk9172ur7t', 'cm7f92bs50007l9xkb5zkr5qy', 'cinis acquiro', 'private', '2025-02-21 20:55:04.402', '2025-02-21 20:55:04.402', NULL),
('cm7f92bwy0065l9xkh8m1t0pd', 'cm7f92brt0002l9xk1l1mww2w', 'conor facilis', 'public', '2025-02-21 20:55:04.403', '2025-02-21 20:55:04.403', NULL),
('cm7f92bx00067l9xkc98259q0', 'cm7f92brg0000l9xkdq3k9lx5', 'somnus contra', 'public', '2025-02-21 20:55:04.404', '2025-02-21 20:55:04.404', NULL),
('cm7f92bx10069l9xkfi74jh10', 'cm7f92bs30006l9xkv6wxm538', 'illum cribro', 'public', '2025-02-21 20:55:04.405', '2025-02-21 20:55:04.405', NULL),
('cm7f92bx2006bl9xk2ysl7x4f', 'cm7f92bs80008l9xk72w5f1ar', 'vestigium carus', 'private', '2025-02-21 20:55:04.406', '2025-02-21 20:55:04.406', NULL),
('cm7f92bx3006dl9xkn4wpat5y', 'cm7f92bs10005l9xkoj6gl33w', 'contra laboriosam', 'private', '2025-02-21 20:55:04.408', '2025-02-21 20:55:04.408', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `userpremiumtransactions`
--

CREATE TABLE `userpremiumtransactions` (
  `id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `transaction_id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `premium_package_id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `price` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `auto_renewal` enum('true','false') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'true',
  `createdAt` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updatedAt` datetime(3) NOT NULL,
  `deletedAt` datetime(3) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `userpremiumtransactions`
--

INSERT INTO `userpremiumtransactions` (`id`, `transaction_id`, `premium_package_id`, `price`, `auto_renewal`, `createdAt`, `updatedAt`, `deletedAt`) VALUES
('cm7f92bzv009rl9xk8xzqr5xi', 'cm7f92bzp009hl9xkhqnheafc', 'cm7f92bzg0095l9xkiubvl7t6', '79836', 'true', '2025-02-21 20:55:04.508', '2025-02-21 20:55:04.508', NULL),
('cm7f92bzx009tl9xk4hm394wn', 'cm7f92bzt009nl9xk13ldjfsn', 'cm7f92bz4008wl9xk5sym8ieb', '169953', 'true', '2025-02-21 20:55:04.510', '2025-02-21 20:55:04.510', NULL),
('cm7f92bzz009vl9xkjwyr78qv', 'cm7f92bzu009pl9xk58fnbiqs', 'cm7f92bzg0095l9xkiubvl7t6', '435183', 'true', '2025-02-21 20:55:04.512', '2025-02-21 20:55:04.512', NULL),
('cm7f92c00009xl9xkowmdoz69', 'cm7f92bzt009nl9xk13ldjfsn', 'cm7f92bzd0093l9xke478hnkf', '407632', 'false', '2025-02-21 20:55:04.513', '2025-02-21 20:55:04.513', NULL),
('cm7f92c02009zl9xks1mxkzf4', 'cm7f92bzm009dl9xko5pa1b8f', 'cm7f92bzf0094l9xkkrpy2vuo', '955046', 'false', '2025-02-21 20:55:04.514', '2025-02-21 20:55:04.514', NULL),
('cm7f92c0300a1l9xkv8yp9dnn', 'cm7f92bzr009ll9xk0l1lzhmg', 'cm7f92bzc0092l9xkk8wdfzm7', '953477', 'false', '2025-02-21 20:55:04.515', '2025-02-21 20:55:04.515', NULL),
('cm7f92c0400a3l9xkmav7i7ph', 'cm7f92bzt009nl9xk13ldjfsn', 'cm7f92bzb0091l9xkgylsrqx5', '227151', 'true', '2025-02-21 20:55:04.517', '2025-02-21 20:55:04.517', NULL),
('cm7f92c0600a5l9xkrgoejt0v', 'cm7f92bzp009hl9xkhqnheafc', 'cm7f92bzg0095l9xkiubvl7t6', '533671', 'false', '2025-02-21 20:55:04.518', '2025-02-21 20:55:04.518', NULL),
('cm7f92c0700a7l9xkkbba2dar', 'cm7f92bzj0099l9xkt4en89kr', 'cm7f92bzf0094l9xkkrpy2vuo', '453967', 'false', '2025-02-21 20:55:04.519', '2025-02-21 20:55:04.519', NULL),
('cm7f92c0800a9l9xkpds5zp6r', 'cm7f92bzr009ll9xk0l1lzhmg', 'cm7f92bzb0091l9xkgylsrqx5', '859517', 'false', '2025-02-21 20:55:04.520', '2025-02-21 20:55:04.520', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `usertransactions`
--

CREATE TABLE `usertransactions` (
  `id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `price` int(11) NOT NULL,
  `payment_method_id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updatedAt` datetime(3) NOT NULL,
  `deletedAt` datetime(3) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `usertransactions`
--

INSERT INTO `usertransactions` (`id`, `user_id`, `price`, `payment_method_id`, `createdAt`, `updatedAt`, `deletedAt`) VALUES
('cm7f92bzh0097l9xkrxgqbmjl', 'cm7f92bs10005l9xkoj6gl33w', 410248, 'cm7f92byz008pl9xkmpc5px0d', '2025-02-21 20:55:04.493', '2025-02-21 20:55:04.493', NULL),
('cm7f92bzj0099l9xkt4en89kr', 'cm7f92brz0004l9xkciktdjtp', 915472, 'cm7f92byu008hl9xk4yau1e56', '2025-02-21 20:55:04.496', '2025-02-21 20:55:04.496', NULL),
('cm7f92bzl009bl9xkgcineahs', 'cm7f92bs30006l9xkv6wxm538', 367130, 'cm7f92byu008hl9xk4yau1e56', '2025-02-21 20:55:04.498', '2025-02-21 20:55:04.498', NULL),
('cm7f92bzm009dl9xko5pa1b8f', 'cm7f92brq0001l9xkt54701rc', 741066, 'cm7f92byz008pl9xkmpc5px0d', '2025-02-21 20:55:04.499', '2025-02-21 20:55:04.499', NULL),
('cm7f92bzo009fl9xkgsnhd8c9', 'cm7f92brg0000l9xkdq3k9lx5', 21413, 'cm7f92bz1008tl9xk32n0md5c', '2025-02-21 20:55:04.500', '2025-02-21 20:55:04.500', NULL),
('cm7f92bzp009hl9xkhqnheafc', 'cm7f92brq0001l9xkt54701rc', 491346, 'cm7f92byz008pl9xkmpc5px0d', '2025-02-21 20:55:04.501', '2025-02-21 20:55:04.501', NULL),
('cm7f92bzq009jl9xkh7xfg8cp', 'cm7f92bs30006l9xkv6wxm538', 517270, 'cm7f92byz008pl9xkmpc5px0d', '2025-02-21 20:55:04.502', '2025-02-21 20:55:04.502', NULL),
('cm7f92bzr009ll9xk0l1lzhmg', 'cm7f92brx0003l9xkg5q1bupf', 212465, 'cm7f92bz1008tl9xk32n0md5c', '2025-02-21 20:55:04.504', '2025-02-21 20:55:04.504', NULL),
('cm7f92bzt009nl9xk13ldjfsn', 'cm7f92brx0003l9xkg5q1bupf', 150379, 'cm7f92byz008pl9xkmpc5px0d', '2025-02-21 20:55:04.505', '2025-02-21 20:55:04.505', NULL),
('cm7f92bzu009pl9xk58fnbiqs', 'cm7f92bs10005l9xkoj6gl33w', 955311, 'cm7f92byp008dl9xkvxkcxz3n', '2025-02-21 20:55:04.506', '2025-02-21 20:55:04.506', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `uservideohistories`
--

CREATE TABLE `uservideohistories` (
  `id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `video_id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `duration` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `uservideowatchlater`
--

CREATE TABLE `uservideowatchlater` (
  `id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `video_id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `videocategories`
--

CREATE TABLE `videocategories` (
  `id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updatedAt` datetime(3) NOT NULL,
  `deletedAt` datetime(3) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `videocategories`
--

INSERT INTO `videocategories` (`id`, `name`, `createdAt`, `updatedAt`, `deletedAt`) VALUES
('cm7f90zvy000al9sod617drge', 'topsail', '2025-02-21 20:54:02.159', '2025-02-21 20:54:02.159', NULL),
('cm7f90zw1000bl9so2tq4le2t', 'millet', '2025-02-21 20:54:02.161', '2025-02-21 20:54:02.161', NULL),
('cm7f90zw2000cl9so98mno7yr', 'approach', '2025-02-21 20:54:02.162', '2025-02-21 20:54:02.162', NULL),
('cm7f90zw3000dl9sowy7w6tgs', 'halt', '2025-02-21 20:54:02.163', '2025-02-21 20:54:02.163', NULL),
('cm7f90zw4000el9sorr920run', 'obligation', '2025-02-21 20:54:02.165', '2025-02-21 20:54:02.165', NULL),
('cm7f90zw6000fl9soms6iwfne', 'defendant', '2025-02-21 20:54:02.166', '2025-02-21 20:54:02.166', NULL),
('cm7f90zw7000gl9sor6g7wr79', 'alert', '2025-02-21 20:54:02.167', '2025-02-21 20:54:02.167', NULL),
('cm7f90zw8000hl9so6awc7zm2', 'surface', '2025-02-21 20:54:02.169', '2025-02-21 20:54:02.169', NULL),
('cm7f90zw9000il9sokejyk8r5', 'fireplace', '2025-02-21 20:54:02.170', '2025-02-21 20:54:02.170', NULL),
('cm7f90zwa000jl9sou9kfazwu', 'cafe', '2025-02-21 20:54:02.171', '2025-02-21 20:54:02.171', NULL),
('cm7f92bsc000al9xkkri2ozjd', 'brook', '2025-02-21 20:55:04.237', '2025-02-21 20:55:04.237', NULL),
('cm7f92bsf000bl9xkk5e9p2y7', 'hexagon', '2025-02-21 20:55:04.240', '2025-02-21 20:55:04.240', NULL),
('cm7f92bsh000cl9xkyuqx6357', 'impostor', '2025-02-21 20:55:04.241', '2025-02-21 20:55:04.241', NULL),
('cm7f92bsi000dl9xkdk0nroyc', 'corral', '2025-02-21 20:55:04.242', '2025-02-21 20:55:04.242', NULL),
('cm7f92bsj000el9xkwkrobyo2', 'sonnet', '2025-02-21 20:55:04.244', '2025-02-21 20:55:04.244', NULL),
('cm7f92bsk000fl9xkrh77nxgt', 'nectarine', '2025-02-21 20:55:04.245', '2025-02-21 20:55:04.245', NULL),
('cm7f92bsm000gl9xkpp4s65r4', 'bran', '2025-02-21 20:55:04.246', '2025-02-21 20:55:04.246', NULL),
('cm7f92bsn000hl9xkl73lt5m6', 'reach', '2025-02-21 20:55:04.247', '2025-02-21 20:55:04.247', NULL),
('cm7f92bso000il9xkoatpxgvc', 'apparatus', '2025-02-21 20:55:04.248', '2025-02-21 20:55:04.248', NULL),
('cm7f92bsp000jl9xk8rj7sqna', 'pilot', '2025-02-21 20:55:04.249', '2025-02-21 20:55:04.249', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `videocomments`
--

CREATE TABLE `videocomments` (
  `id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `video_id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `comment` longtext COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `videocomments`
--

INSERT INTO `videocomments` (`id`, `video_id`, `user_id`, `comment`) VALUES
('cm7f92bu00029l9xks9nm7sry', 'cm7f92bt80013l9xktt76te4f', 'cm7f92bs80008l9xk72w5f1ar', 'Testimonium similique tumultus thesaurus color speculum absum avaritia deputo. Officiis decens vitium artificiose. Turbo venio trepide comburo vulariter.'),
('cm7f92bu2002bl9xkma58pkvc', 'cm7f92bt3000xl9xka2uv975k', 'cm7f92bs30006l9xkv6wxm538', 'Sustineo subiungo clamo voluntarius patruus pel. Tabula amet votum debitis cursus clibanus. Usus appello patior vomica sodalitas supellex vestigium incidunt.'),
('cm7f92bu4002dl9xkvu6xximd', 'cm7f92bsy000rl9xkt4vcmr8c', 'cm7f92bs50007l9xkb5zkr5qy', 'Tamquam utrimque subito consequatur admoneo summopere speculum surculus venia. Damno ab volaticus compono. Adulatio tunc venia supra viduo accusamus arcesso cibus coma aut.'),
('cm7f92bu6002fl9xkf55ufnv9', 'cm7f92bsw000pl9xk27vehlk1', 'cm7f92brq0001l9xkt54701rc', 'Suspendo contabesco ventito decens caveo thymbra delectus admitto contabesco atqui. Clam trans accusator at odit arcesso. Umbra tepesco sapiente.'),
('cm7f92bu7002hl9xknuwcw4y6', 'cm7f92bt80013l9xktt76te4f', 'cm7f92bs30006l9xkv6wxm538', 'Velit caelum canonicus vester volup creo laudantium vigilo rerum. Corroboro cognatus carus deporto tollo deleniti vita ultra cibo. Depono adinventitias demonstro nemo iste corpus quod debilito ver.'),
('cm7f92bu9002jl9xko99ueitf', 'cm7f92bsq000ll9xk7ybcikso', 'cm7f92bs30006l9xkv6wxm538', 'Decipio damno theologus audeo curvo animus. Contabesco averto amaritudo. Delinquo claudeo conqueror harum veniam capio libero commemoro alo.'),
('cm7f92bua002ll9xkkjugmnya', 'cm7f92bsw000pl9xk27vehlk1', 'cm7f92bs30006l9xkv6wxm538', 'Umquam vulgivagus tubineus doloribus fuga. Verto spoliatio voluptatum. Totidem claudeo cultellus conventus adamo desino soluta umerus curtus.'),
('cm7f92bub002nl9xkm7xbelxo', 'cm7f92bt1000vl9xkzvtyo0aj', 'cm7f92bsa0009l9xkcmvifr8w', 'Civis arca benigne creo. Blandior advoco surgo damno calco canto stipes suspendo distinctio. Umerus colo reiciendis animadverto ipsum spero acerbitas.'),
('cm7f92bud002pl9xkiojzp0gv', 'cm7f92bt1000vl9xkzvtyo0aj', 'cm7f92bs50007l9xkb5zkr5qy', 'Appositus usitas tollo umbra addo creptio adsuesco carus confero clarus. Utor averto culpa. Conturbo trans teneo alveus capto.'),
('cm7f92bue002rl9xkwrfdpbut', 'cm7f92bt0000tl9xkvzfwx16o', 'cm7f92brt0002l9xk1l1mww2w', 'Veniam alius assumenda vetus talus. Credo abundans damnatio somnus torrens vaco tamdiu viscus curvo. Atque eius suggero ars studio terror pel demens animus.');

-- --------------------------------------------------------

--
-- Table structure for table `videolikes`
--

CREATE TABLE `videolikes` (
  `id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `video_id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `videolikes`
--

INSERT INTO `videolikes` (`id`, `video_id`, `user_id`) VALUES
('cm7f92btn001pl9xkin6aqonj', 'cm7f92bsy000rl9xkt4vcmr8c', 'cm7f92bs10005l9xkoj6gl33w'),
('cm7f92btp001rl9xkjxml5knr', 'cm7f92bt4000zl9xkbw6c39bt', 'cm7f92brt0002l9xk1l1mww2w'),
('cm7f92btq001tl9xku099rxza', 'cm7f92bt80013l9xktt76te4f', 'cm7f92brg0000l9xkdq3k9lx5'),
('cm7f92bts001vl9xkimwnm50g', 'cm7f92bsy000rl9xkt4vcmr8c', 'cm7f92brz0004l9xkciktdjtp'),
('cm7f92btt001xl9xk48ehyfvb', 'cm7f92bt1000vl9xkzvtyo0aj', 'cm7f92brg0000l9xkdq3k9lx5'),
('cm7f92btu001zl9xksec7omz4', 'cm7f92bt4000zl9xkbw6c39bt', 'cm7f92brg0000l9xkdq3k9lx5'),
('cm7f92btv0021l9xk8jkwylv3', 'cm7f92bt1000vl9xkzvtyo0aj', 'cm7f92bs50007l9xkb5zkr5qy'),
('cm7f92btx0023l9xkv7xadrae', 'cm7f92bt3000xl9xka2uv975k', 'cm7f92bs80008l9xk72w5f1ar'),
('cm7f92bty0025l9xke2p6bjk6', 'cm7f92bsy000rl9xkt4vcmr8c', 'cm7f92brt0002l9xk1l1mww2w'),
('cm7f92btz0027l9xkkzy6gr0y', 'cm7f92bsu000nl9xkwnut4907', 'cm7f92brq0001l9xkt54701rc');

-- --------------------------------------------------------

--
-- Table structure for table `videoreport`
--

CREATE TABLE `videoreport` (
  `id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `video_id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `videos`
--

CREATE TABLE `videos` (
  `id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `thumbnail_img` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `video_status` enum('public','private','membership') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'public',
  `video_category_id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `monetized_status` enum('green_dollar','yellow_dollar','red_dollar','not_monetized') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'not_monetized',
  `video_type` enum('short','content','live') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'content',
  `createdAt` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updatedAt` datetime(3) NOT NULL,
  `deletedAt` datetime(3) DEFAULT NULL,
  `video_url` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `videos`
--

INSERT INTO `videos` (`id`, `name`, `description`, `thumbnail_img`, `video_status`, `video_category_id`, `monetized_status`, `video_type`, `createdAt`, `updatedAt`, `deletedAt`, `video_url`) VALUES
('cm7f90zwd000ll9souvi4bm6p', 'angulus constans charisma', 'Sumptus occaecati tepesco pariatur. Casus non tyrannus voluptas velut nesciunt. Collum undique exercitationem ratione perferendis.', 'https://loremflickr.com/937/482?lock=5958202329777595', 'private', 'cm7f90zw7000gl9sor6g7wr79', 'not_monetized', 'content', '2025-02-21 20:54:02.173', '2025-02-21 20:54:02.173', NULL, 'https://watery-corral.info'),
('cm7f90zwg000nl9sonp5yofdd', 'vulariter ante omnis', 'Corroboro templum vilicus cohibeo valeo auctor crudelis verbum acerbitas. Desolo magnam consuasor cupiditas. Victoria ver angustus contra asper quibusdam urbanus.', 'https://loremflickr.com/1684/2526?lock=7445340056145844', 'private', 'cm7f90zw2000cl9so98mno7yr', 'yellow_dollar', 'content', '2025-02-21 20:54:02.176', '2025-02-21 20:54:02.176', NULL, 'https://sudden-sundae.com'),
('cm7f90zwi000pl9sobmho2coq', 'virgo ipsum aurum', 'Usque circumvenio averto. Abstergo conor artificiose in allatus sapiente tredecim civitas. Abeo creta cuppedia crapula vinco vos cicuta.', 'https://loremflickr.com/3272/347?lock=8508957436697510', 'private', 'cm7f90zw6000fl9soms6iwfne', 'red_dollar', 'content', '2025-02-21 20:54:02.178', '2025-02-21 20:54:02.178', NULL, 'https://considerate-wheel.info/'),
('cm7f90zwj000rl9so8rpknw0g', 'avaritia hic demoror', 'Defero studio illum adversus cruciamentum. Terror tutamen eaque vomito pecto vitae eos. Videlicet cernuus rerum totidem arca.', 'https://loremflickr.com/371/2425?lock=4015537978845992', 'membership', 'cm7f90zw3000dl9sowy7w6tgs', 'yellow_dollar', 'short', '2025-02-21 20:54:02.180', '2025-02-21 20:54:02.180', NULL, 'https://spiffy-giant.biz'),
('cm7f92bsq000ll9xk7ybcikso', 'speculum appello commodi', 'Libero vinitor angulus clamo traho accendo tondeo cibo voluptatem aperte. Tum auditor dignissimos ut vos. Color tonsor animi campana venustas quisquam eum tres colligo apostolus.', 'https://loremflickr.com/3353/1774?lock=7890417344651927', 'private', 'cm7f92bsc000al9xkkri2ozjd', 'red_dollar', 'content', '2025-02-21 20:55:04.251', '2025-02-21 20:55:04.251', NULL, 'https://squiggly-chainstay.biz/'),
('cm7f92bsu000nl9xkwnut4907', 'synagoga xiphias aeneus', 'Fugit ut deficio nesciunt libero. Benevolentia defero derelinquo voluptates. Cultura acquiro cunctatio.', 'https://loremflickr.com/1698/230?lock=3946038542369842', 'membership', 'cm7f92bsc000al9xkkri2ozjd', 'yellow_dollar', 'content', '2025-02-21 20:55:04.254', '2025-02-21 20:55:04.254', NULL, 'https://curly-linseed.com/'),
('cm7f92bsw000pl9xk27vehlk1', 'cuppedia voluptas ustilo', 'Vulnero cauda delicate confugo vilis sordeo. Nesciunt acervus vespillo. Corpus desparatus saepe argumentum adhaero asperiores statim tubineus.', 'https://picsum.photos/seed/5LVQV5MBPY/2534/363', 'public', 'cm7f92bsm000gl9xkpp4s65r4', 'green_dollar', 'content', '2025-02-21 20:55:04.257', '2025-02-21 20:55:04.257', NULL, 'https://favorable-manner.name'),
('cm7f92bsy000rl9xkt4vcmr8c', 'arcus colligo tabgo', 'Explicabo libero audeo tui ipsam angustus texo. Unus depono rem. Deleniti depulso voluptatibus excepturi video cariosus.', 'https://picsum.photos/seed/kYpvH/3649/3615', 'private', 'cm7f92bsp000jl9xk8rj7sqna', 'yellow_dollar', 'short', '2025-02-21 20:55:04.258', '2025-02-21 20:55:04.258', NULL, 'https://noted-object.info/'),
('cm7f92bt0000tl9xkvzfwx16o', 'sequi tametsi canonicus', 'Terror sodalitas crur avarus tabgo sufficio supra arbustum calco. Amo umquam spargo deficio sequi spiculum sit abscido thalassinus. Tantum chirographum tui ducimus.', 'https://loremflickr.com/2123/1319?lock=3946874285699039', 'private', 'cm7f92bsj000el9xkwkrobyo2', 'yellow_dollar', 'live', '2025-02-21 20:55:04.260', '2025-02-21 20:55:04.260', NULL, 'https://grouchy-unblinking.com/'),
('cm7f92bt1000vl9xkzvtyo0aj', 'adfero cursus usus', 'Cuius decens a comis vestigium vespillo agnosco animadverto denego aperiam. Caecus tabernus trucido civis currus amita cubicularis socius vaco sollers. Custodia appositus basium derideo occaecati.', 'https://loremflickr.com/1915/2036?lock=3516804248612172', 'membership', 'cm7f92bsn000hl9xkl73lt5m6', 'yellow_dollar', 'short', '2025-02-21 20:55:04.262', '2025-02-21 20:55:04.262', NULL, 'https://whirlwind-alb.org/'),
('cm7f92bt3000xl9xka2uv975k', 'trepide comminor aestivus', 'Demergo defero annus tempus auditor tyrannus tabesco sollicito. Trans atavus stabilis ducimus ad nam cubitum vereor confero. Ultra temperantia adsidue vulariter omnis aegre terra.', 'https://picsum.photos/seed/ZCVjmuMl/2049/3441', 'public', 'cm7f92bsh000cl9xkyuqx6357', 'red_dollar', 'short', '2025-02-21 20:55:04.263', '2025-02-21 20:55:04.263', NULL, 'https://orderly-best-seller.org'),
('cm7f92bt4000zl9xkbw6c39bt', 'apparatus ducimus astrum', 'A tactus suasoria abstergo arca attonbitus textilis delinquo. Comes acsi caries vociferor compono ver tabella tibi canonicus hic. Suscipio sol adeptio.', 'https://picsum.photos/seed/IYZIT/3208/3083', 'membership', 'cm7f92bsp000jl9xk8rj7sqna', 'not_monetized', 'content', '2025-02-21 20:55:04.265', '2025-02-21 20:55:04.265', NULL, 'https://dental-video.com/'),
('cm7f92bt60011l9xkwkc37y4t', 'dens adulescens sequi', 'Coniuratio cunae deludo tersus. Arcesso adfectus saepe cattus adulescens aestivus sol vicinus animi villa. Tero suppellex vinco tollo vado laborum.', 'https://picsum.photos/seed/nE6s2cKjq/142/2631', 'private', 'cm7f92bsp000jl9xk8rj7sqna', 'yellow_dollar', 'short', '2025-02-21 20:55:04.266', '2025-02-21 20:55:04.266', NULL, 'https://made-up-safe.biz'),
('cm7f92bt80013l9xktt76te4f', 'anser vobis ambitus', 'Vulnero ceno torrens utpote thermae tamquam possimus ademptio. Casus cibo usque vaco pectus. Tabesco condico ultio verbum consuasor thorax crinis.', 'https://picsum.photos/seed/TFaLAFCc/416/3603', 'private', 'cm7f92bsp000jl9xk8rj7sqna', 'not_monetized', 'content', '2025-02-21 20:55:04.268', '2025-02-21 20:55:04.268', NULL, 'https://burdensome-slime.com/');

-- --------------------------------------------------------

--
-- Table structure for table `videotags`
--

CREATE TABLE `videotags` (
  `id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `video_id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `tag_id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `videotags`
--

INSERT INTO `videotags` (`id`, `video_id`, `tag_id`) VALUES
('cm7f92bw1004rl9xk67haxgcl', 'cm7f92bsw000pl9xk27vehlk1', 'cm7f92bvy004ol9xkju4p17bf'),
('cm7f92bw3004tl9xkonj18ulc', 'cm7f92bsw000pl9xk27vehlk1', 'cm7f92bvy004ol9xkju4p17bf'),
('cm7f92bw4004vl9xkm268alze', 'cm7f92bt0000tl9xkvzfwx16o', 'cm7f92bvy004ol9xkju4p17bf'),
('cm7f92bw5004xl9xkmdvfdxn2', 'cm7f92bt1000vl9xkzvtyo0aj', 'cm7f92bvt004kl9xkayoecovx'),
('cm7f92bw6004zl9xkwrzqsjv8', 'cm7f92bt1000vl9xkzvtyo0aj', 'cm7f92bvr004il9xktbbdscg4'),
('cm7f92bw70051l9xk9lbpd556', 'cm7f92bt3000xl9xka2uv975k', 'cm7f92bvu004ll9xkjnbqrw8q'),
('cm7f92bw80053l9xkqaq23f47', 'cm7f92bt80013l9xktt76te4f', 'cm7f92bvw004ml9xkhpmrsye8'),
('cm7f92bw90055l9xks1ygwlzl', 'cm7f92bsu000nl9xkwnut4907', 'cm7f92bvr004il9xktbbdscg4'),
('cm7f92bwb0057l9xkdd7iuvey', 'cm7f92bsy000rl9xkt4vcmr8c', 'cm7f92bvt004kl9xkayoecovx'),
('cm7f92bwc0059l9xk7zyttsdf', 'cm7f92bt1000vl9xkzvtyo0aj', 'cm7f92bvn004gl9xkp1by5qee');

-- --------------------------------------------------------

--
-- Table structure for table `videoviews`
--

CREATE TABLE `videoviews` (
  `id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `video_id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `videoviews`
--

INSERT INTO `videoviews` (`id`, `video_id`, `user_id`) VALUES
('cm7f92bt90015l9xk92s4yjic', 'cm7f92bsy000rl9xkt4vcmr8c', 'cm7f92brx0003l9xkg5q1bupf'),
('cm7f92btc0017l9xkbivcp4i6', 'cm7f92bsw000pl9xk27vehlk1', 'cm7f92brg0000l9xkdq3k9lx5'),
('cm7f92btd0019l9xkm1qybuqd', 'cm7f92bt0000tl9xkvzfwx16o', 'cm7f92bs50007l9xkb5zkr5qy'),
('cm7f92bte001bl9xku4wiift3', 'cm7f92bsw000pl9xk27vehlk1', 'cm7f92brz0004l9xkciktdjtp'),
('cm7f92btf001dl9xkw9l073jm', 'cm7f92bt80013l9xktt76te4f', 'cm7f92bs50007l9xkb5zkr5qy'),
('cm7f92bth001fl9xk5g7r49jq', 'cm7f92bt1000vl9xkzvtyo0aj', 'cm7f92bs10005l9xkoj6gl33w'),
('cm7f92bti001hl9xkg3umk58p', 'cm7f92bt3000xl9xka2uv975k', 'cm7f92bsa0009l9xkcmvifr8w'),
('cm7f92btj001jl9xketiiea7o', 'cm7f92bt1000vl9xkzvtyo0aj', 'cm7f92bs80008l9xk72w5f1ar'),
('cm7f92btk001ll9xkv9unpok2', 'cm7f92bt0000tl9xkvzfwx16o', 'cm7f92bsa0009l9xkcmvifr8w'),
('cm7f92btm001nl9xk5gabfjs0', 'cm7f92bt60011l9xkwkc37y4t', 'cm7f92bs50007l9xkb5zkr5qy');

-- --------------------------------------------------------

--
-- Table structure for table `_prisma_migrations`
--

CREATE TABLE `_prisma_migrations` (
  `id` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `checksum` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `finished_at` datetime(3) DEFAULT NULL,
  `migration_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `logs` text COLLATE utf8mb4_unicode_ci,
  `rolled_back_at` datetime(3) DEFAULT NULL,
  `started_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `applied_steps_count` int(10) UNSIGNED NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `_prisma_migrations`
--

INSERT INTO `_prisma_migrations` (`id`, `checksum`, `finished_at`, `migration_name`, `logs`, `rolled_back_at`, `started_at`, `applied_steps_count`) VALUES
('4e63aa03-4d92-48df-a837-4b6fe1947c62', '3f62301ed47e1a8a1f08d544499790e72269cf838f6c59fa7449b64619db07c9', '2025-02-21 20:42:17.221', '20250221204217_update', NULL, NULL, '2025-02-21 20:42:17.191', 1),
('61845f30-a29d-415a-9d3a-e42be09176b5', '67d59fbe4f556682d69af5371e1405b1c13bd7b65d9ec19446c92a6e656f2ab8', '2025-02-21 20:38:02.503', '20250129054856_add_migration', NULL, NULL, '2025-02-21 20:38:02.460', 1),
('6749a9be-f61e-4e2c-9bf5-654144e276d8', 'cdb35e1f4ff91533c82f0d693a101d12fe3bef2632bf204dce1e521f64186345', '2025-02-21 20:38:11.836', '20250221203809_init', NULL, NULL, '2025-02-21 20:38:09.778', 1),
('763c57c7-4dc8-49bd-b061-3d83ab890681', '48915314074890f0f53092afb3f994be968994ebf73c28c1ac604a2d6169ab18', '2025-02-21 20:54:54.260', '20250221205454_update', NULL, NULL, '2025-02-21 20:54:54.225', 1);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `commentlikes`
--
ALTER TABLE `commentlikes`
  ADD PRIMARY KEY (`id`),
  ADD KEY `CommentLikes_comment_id_fkey` (`comment_id`),
  ADD KEY `CommentLikes_user_id_fkey` (`user_id`);

--
-- Indexes for table `commentreplies`
--
ALTER TABLE `commentreplies`
  ADD PRIMARY KEY (`id`),
  ADD KEY `CommentReplies_comment_id_fkey` (`comment_id`),
  ADD KEY `CommentReplies_user_id_fkey` (`user_id`);

--
-- Indexes for table `commentreports`
--
ALTER TABLE `commentreports`
  ADD PRIMARY KEY (`id`),
  ADD KEY `CommentReports_comment_id_fkey` (`comment_id`),
  ADD KEY `CommentReports_user_id_fkey` (`user_id`);

--
-- Indexes for table `creatormembers`
--
ALTER TABLE `creatormembers`
  ADD PRIMARY KEY (`id`),
  ADD KEY `CreatorMembers_member_id_fkey` (`member_id`),
  ADD KEY `CreatorMembers_membership_id_fkey` (`membership_id`);

--
-- Indexes for table `membershipbenefits`
--
ALTER TABLE `membershipbenefits`
  ADD PRIMARY KEY (`id`),
  ADD KEY `MembershipBenefits_membership_id_fkey` (`membership_id`);

--
-- Indexes for table `memberships`
--
ALTER TABLE `memberships`
  ADD PRIMARY KEY (`id`),
  ADD KEY `Memberships_user_id_fkey` (`user_id`);

--
-- Indexes for table `paymentmethodcategory`
--
ALTER TABLE `paymentmethodcategory`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `paymentmethods`
--
ALTER TABLE `paymentmethods`
  ADD PRIMARY KEY (`id`),
  ADD KEY `PaymentMethods_category_id_fkey` (`category_id`);

--
-- Indexes for table `playlistsaved`
--
ALTER TABLE `playlistsaved`
  ADD PRIMARY KEY (`id`),
  ADD KEY `PlaylistSaved_playlist_id_fkey` (`playlist_id`),
  ADD KEY `PlaylistSaved_user_id_fkey` (`user_id`);

--
-- Indexes for table `playlistvideos`
--
ALTER TABLE `playlistvideos`
  ADD PRIMARY KEY (`id`),
  ADD KEY `PlaylistVideos_video_id_fkey` (`video_id`),
  ADD KEY `PlaylistVideos_playlist_id_fkey` (`playlist_id`);

--
-- Indexes for table `premiumpackages`
--
ALTER TABLE `premiumpackages`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `subscriptions`
--
ALTER TABLE `subscriptions`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tags`
--
ALTER TABLE `tags`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `trendingvideo`
--
ALTER TABLE `trendingvideo`
  ADD PRIMARY KEY (`id`),
  ADD KEY `TrendingVideo_video_id_fkey` (`video_id`),
  ADD KEY `TrendingVideo_videoCategory_id_fkey` (`videoCategory_id`);

--
-- Indexes for table `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `usercommunitypost`
--
ALTER TABLE `usercommunitypost`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `usermembershiptransactions`
--
ALTER TABLE `usermembershiptransactions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `UserMembershipTransactions_transaction_id_fkey` (`transaction_id`),
  ADD KEY `UserMembershipTransactions_membership_id_fkey` (`membership_id`);

--
-- Indexes for table `usernotificatons`
--
ALTER TABLE `usernotificatons`
  ADD PRIMARY KEY (`id`),
  ADD KEY `UserNotificatons_user_id_fkey` (`user_id`),
  ADD KEY `UserNotificatons_video_id_fkey` (`video_id`);

--
-- Indexes for table `userplaylist`
--
ALTER TABLE `userplaylist`
  ADD PRIMARY KEY (`id`),
  ADD KEY `UserPlaylist_user_id_fkey` (`user_id`);

--
-- Indexes for table `userpremiumtransactions`
--
ALTER TABLE `userpremiumtransactions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `UserPremiumTransactions_transaction_id_fkey` (`transaction_id`),
  ADD KEY `UserPremiumTransactions_premium_package_id_fkey` (`premium_package_id`);

--
-- Indexes for table `usertransactions`
--
ALTER TABLE `usertransactions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `Usertransactions_user_id_fkey` (`user_id`),
  ADD KEY `Usertransactions_payment_method_id_fkey` (`payment_method_id`);

--
-- Indexes for table `uservideohistories`
--
ALTER TABLE `uservideohistories`
  ADD PRIMARY KEY (`id`),
  ADD KEY `UserVideoHistories_video_id_fkey` (`video_id`),
  ADD KEY `UserVideoHistories_user_id_fkey` (`user_id`);

--
-- Indexes for table `uservideowatchlater`
--
ALTER TABLE `uservideowatchlater`
  ADD PRIMARY KEY (`id`),
  ADD KEY `UserVideoWatchLater_video_id_fkey` (`video_id`),
  ADD KEY `UserVideoWatchLater_user_id_fkey` (`user_id`);

--
-- Indexes for table `videocategories`
--
ALTER TABLE `videocategories`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `videocomments`
--
ALTER TABLE `videocomments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `VideoComments_video_id_fkey` (`video_id`),
  ADD KEY `VideoComments_user_id_fkey` (`user_id`);

--
-- Indexes for table `videolikes`
--
ALTER TABLE `videolikes`
  ADD PRIMARY KEY (`id`),
  ADD KEY `VideoLikes_video_id_fkey` (`video_id`),
  ADD KEY `VideoLikes_user_id_fkey` (`user_id`);

--
-- Indexes for table `videoreport`
--
ALTER TABLE `videoreport`
  ADD PRIMARY KEY (`id`),
  ADD KEY `videoReport_video_id_fkey` (`video_id`),
  ADD KEY `videoReport_user_id_fkey` (`user_id`);

--
-- Indexes for table `videos`
--
ALTER TABLE `videos`
  ADD PRIMARY KEY (`id`),
  ADD KEY `Videos_video_category_id_fkey` (`video_category_id`);

--
-- Indexes for table `videotags`
--
ALTER TABLE `videotags`
  ADD PRIMARY KEY (`id`),
  ADD KEY `videoTags_video_id_fkey` (`video_id`),
  ADD KEY `videoTags_tag_id_fkey` (`tag_id`);

--
-- Indexes for table `videoviews`
--
ALTER TABLE `videoviews`
  ADD PRIMARY KEY (`id`),
  ADD KEY `VideoViews_video_id_fkey` (`video_id`),
  ADD KEY `VideoViews_user_id_fkey` (`user_id`);

--
-- Indexes for table `_prisma_migrations`
--
ALTER TABLE `_prisma_migrations`
  ADD PRIMARY KEY (`id`);

--
-- Constraints for dumped tables
--

--
-- Constraints for table `commentlikes`
--
ALTER TABLE `commentlikes`
  ADD CONSTRAINT `CommentLikes_comment_id_fkey` FOREIGN KEY (`comment_id`) REFERENCES `videocomments` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `CommentLikes_user_id_fkey` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `commentreplies`
--
ALTER TABLE `commentreplies`
  ADD CONSTRAINT `CommentReplies_comment_id_fkey` FOREIGN KEY (`comment_id`) REFERENCES `videocomments` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `CommentReplies_user_id_fkey` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `commentreports`
--
ALTER TABLE `commentreports`
  ADD CONSTRAINT `CommentReports_comment_id_fkey` FOREIGN KEY (`comment_id`) REFERENCES `videocomments` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `CommentReports_user_id_fkey` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `creatormembers`
--
ALTER TABLE `creatormembers`
  ADD CONSTRAINT `CreatorMembers_member_id_fkey` FOREIGN KEY (`member_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `CreatorMembers_membership_id_fkey` FOREIGN KEY (`membership_id`) REFERENCES `memberships` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `membershipbenefits`
--
ALTER TABLE `membershipbenefits`
  ADD CONSTRAINT `MembershipBenefits_membership_id_fkey` FOREIGN KEY (`membership_id`) REFERENCES `memberships` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `memberships`
--
ALTER TABLE `memberships`
  ADD CONSTRAINT `Memberships_user_id_fkey` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `paymentmethods`
--
ALTER TABLE `paymentmethods`
  ADD CONSTRAINT `PaymentMethods_category_id_fkey` FOREIGN KEY (`category_id`) REFERENCES `paymentmethodcategory` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `playlistsaved`
--
ALTER TABLE `playlistsaved`
  ADD CONSTRAINT `PlaylistSaved_playlist_id_fkey` FOREIGN KEY (`playlist_id`) REFERENCES `userplaylist` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `PlaylistSaved_user_id_fkey` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `playlistvideos`
--
ALTER TABLE `playlistvideos`
  ADD CONSTRAINT `PlaylistVideos_playlist_id_fkey` FOREIGN KEY (`playlist_id`) REFERENCES `userplaylist` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `PlaylistVideos_video_id_fkey` FOREIGN KEY (`video_id`) REFERENCES `videos` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `trendingvideo`
--
ALTER TABLE `trendingvideo`
  ADD CONSTRAINT `TrendingVideo_videoCategory_id_fkey` FOREIGN KEY (`videoCategory_id`) REFERENCES `videocategories` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `TrendingVideo_video_id_fkey` FOREIGN KEY (`video_id`) REFERENCES `videos` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `usermembershiptransactions`
--
ALTER TABLE `usermembershiptransactions`
  ADD CONSTRAINT `UserMembershipTransactions_membership_id_fkey` FOREIGN KEY (`membership_id`) REFERENCES `memberships` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `UserMembershipTransactions_transaction_id_fkey` FOREIGN KEY (`transaction_id`) REFERENCES `usertransactions` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `usernotificatons`
--
ALTER TABLE `usernotificatons`
  ADD CONSTRAINT `UserNotificatons_user_id_fkey` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `UserNotificatons_video_id_fkey` FOREIGN KEY (`video_id`) REFERENCES `videos` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `userplaylist`
--
ALTER TABLE `userplaylist`
  ADD CONSTRAINT `UserPlaylist_user_id_fkey` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `userpremiumtransactions`
--
ALTER TABLE `userpremiumtransactions`
  ADD CONSTRAINT `UserPremiumTransactions_premium_package_id_fkey` FOREIGN KEY (`premium_package_id`) REFERENCES `premiumpackages` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `UserPremiumTransactions_transaction_id_fkey` FOREIGN KEY (`transaction_id`) REFERENCES `usertransactions` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `usertransactions`
--
ALTER TABLE `usertransactions`
  ADD CONSTRAINT `Usertransactions_payment_method_id_fkey` FOREIGN KEY (`payment_method_id`) REFERENCES `paymentmethods` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `Usertransactions_user_id_fkey` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `uservideohistories`
--
ALTER TABLE `uservideohistories`
  ADD CONSTRAINT `UserVideoHistories_user_id_fkey` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `UserVideoHistories_video_id_fkey` FOREIGN KEY (`video_id`) REFERENCES `videos` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `uservideowatchlater`
--
ALTER TABLE `uservideowatchlater`
  ADD CONSTRAINT `UserVideoWatchLater_user_id_fkey` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `UserVideoWatchLater_video_id_fkey` FOREIGN KEY (`video_id`) REFERENCES `videos` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `videocomments`
--
ALTER TABLE `videocomments`
  ADD CONSTRAINT `VideoComments_user_id_fkey` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `VideoComments_video_id_fkey` FOREIGN KEY (`video_id`) REFERENCES `videos` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `videolikes`
--
ALTER TABLE `videolikes`
  ADD CONSTRAINT `VideoLikes_user_id_fkey` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `VideoLikes_video_id_fkey` FOREIGN KEY (`video_id`) REFERENCES `videos` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `videoreport`
--
ALTER TABLE `videoreport`
  ADD CONSTRAINT `videoReport_user_id_fkey` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `videoReport_video_id_fkey` FOREIGN KEY (`video_id`) REFERENCES `videos` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `videos`
--
ALTER TABLE `videos`
  ADD CONSTRAINT `Videos_video_category_id_fkey` FOREIGN KEY (`video_category_id`) REFERENCES `videocategories` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `videotags`
--
ALTER TABLE `videotags`
  ADD CONSTRAINT `videoTags_tag_id_fkey` FOREIGN KEY (`tag_id`) REFERENCES `tags` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `videoTags_video_id_fkey` FOREIGN KEY (`video_id`) REFERENCES `videos` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `videoviews`
--
ALTER TABLE `videoviews`
  ADD CONSTRAINT `VideoViews_user_id_fkey` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `VideoViews_video_id_fkey` FOREIGN KEY (`video_id`) REFERENCES `videos` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
