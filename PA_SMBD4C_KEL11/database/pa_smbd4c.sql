-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: May 26, 2023 at 03:32 PM
-- Server version: 10.4.21-MariaDB
-- PHP Version: 8.0.11

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `pa_smbd4c`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `DelArtikel` (IN `ida` INT(100))  BEGIN
	DELETE FROM artikel WHERE id = ida;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_pelanggan` (IN `pelanggan_id` INT(100))  BEGIN
  DELETE FROM pelanggan WHERE id_pelanggan = pelanggan_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `DelKereta` (IN `idk` INT(100))  BEGIN
	DELETE FROM kereta WHERE id = idk;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `InsertArtikel` (IN `id` INT(100), IN `$judul` VARCHAR(255), IN `$isi` TEXT)  BEGIN
    INSERT INTO artikel VALUES(NULL, $judul, $isi, CURDATE());
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `insert_gerbong_kursi` (IN `newTrainId` INT(100))  BEGIN
    DECLARE i INT DEFAULT 0;
    DECLARE j INT DEFAULT 0;
    DECLARE posKursi INT DEFAULT 1;
    DECLARE posG CHAR(1);
    DECLARE idG INT;

    DECLARE cekidG CURSOR FOR
        SELECT id FROM gerbong WHERE posisi_gerbong = posG AND id_kereta = newTrainId;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET idG = NULL;

    SET posG = 'A';
    
    WHILE i < 5 DO
        INSERT INTO gerbong VALUES(NULL, posG, newTrainId);

        OPEN cekidG;
        FETCH cekidG INTO idG;
        CLOSE cekidG;
        
        SET j = 0;
        SET posKursi = 1;
        
        WHILE j < 10 DO
            INSERT INTO kursi VALUES(NULL, posKursi, 'tersedia', NULL, idG, NULL);
            SET posKursi = posKursi + 1;
            SET j = j + 1;
        END WHILE;
        
        SET posG = CHAR(ASCII(posG) + 1);
        SET i = i + 1;
    END WHILE;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `TambahKereta` (IN `id` INT(100), IN `nama_kereta` VARCHAR(400), IN `kelas` VARCHAR(50), IN `tanggal` DATE, IN `jam_berangkat` VARCHAR(5), IN `jam_tiba` VARCHAR(5), IN `tarif_dewasa` DECIMAL(22,2), IN `tarif_anak` DECIMAL(22,2), IN `status` VARCHAR(50))  BEGIN
    INSERT INTO kereta (id, nama_kereta, kelas, tanggal, jam_berangkat, jam_tiba, tarif_dewasa, tarif_anak, status)
    VALUES (id, nama_kereta, kelas, tanggal, jam_berangkat, jam_tiba, tarif_dewasa, tarif_anak, status);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `UpdateContact` (IN `p_no_telp` VARCHAR(255), IN `p_email` VARCHAR(255))  BEGIN
    DECLARE v_count INT;
    
    START TRANSACTION;
    
    SELECT COUNT(*) INTO v_count FROM kontak_us;
    
    IF v_count = 0 AND p_email IS NOT NULL AND p_no_telp IS NOT NULL THEN
        INSERT INTO KONTAK_US (no_telp, email) VALUES (p_no_telp, p_email);
    ELSEIF p_no_telp IS NOT NULL AND p_email IS NOT NULL THEN
        UPDATE KONTAK_US SET no_telp = p_no_telp, email = p_email;
    ELSEIF p_email IS NULL AND p_no_telp IS NOT NULL THEN
        UPDATE KONTAK_US SET no_telp = p_no_telp;
    ELSEIF p_no_telp IS NULL AND p_email IS NOT NULL THEN
        UPDATE KONTAK_US SET email = p_email;
    ELSE
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Data Kontak Kosong';
    END IF;
    
    IF ROW_COUNT() > 0 THEN
        COMMIT;
        SELECT 'Data Kontak berhasil disimpan!' AS message;
    ELSE
        ROLLBACK;
    END IF;
    
    END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `update_pass` (IN `admin_id` INT(100), IN `old_password` VARCHAR(255), IN `new_password` VARCHAR(255))  BEGIN
  DECLARE pass VARCHAR(255);

  -- Cek apakah password lama sesuai
  SELECT password INTO pass FROM admin WHERE id = admin_id;

  IF pass IS NOT NULL AND pass = old_password THEN
    -- Update password baru
    UPDATE admin SET password = new_password WHERE id = admin_id;
    SELECT 'Password berhasil diperbarui.' AS Message;
  ELSE
    SELECT 'Password lama tidak sesuai.' AS Message;
  END IF;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `admin`
--

CREATE TABLE `admin` (
  `id` int(2) NOT NULL,
  `username` varchar(13) NOT NULL,
  `password` varchar(12) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `admin`
--

INSERT INTO `admin` (`id`, `username`, `password`) VALUES
(1, 'admin', 'KEL11PA');

--
-- Triggers `admin`
--
DELIMITER $$
CREATE TRIGGER `after_update_admin_password` AFTER UPDATE ON `admin` FOR EACH ROW BEGIN
    -- Cek apakah kolom password diupdate
    IF NEW.password = OLD.password THEN
        -- Menampilkan pesan setelah password diupdate
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Password admin tidak berhasil diperbarui.';
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `artikel`
--

CREATE TABLE `artikel` (
  `id` int(11) NOT NULL,
  `judul` text NOT NULL,
  `isi` text NOT NULL,
  `tanggal` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `artikel`
--

INSERT INTO `artikel` (`id`, `judul`, `isi`, `tanggal`) VALUES
(2, 'Mengapa Memilih SIKAT?', 'Anda harus memilih website Sistem Informasi Kereta Api Terbaik ini karena memiliki beberapa keunggulan yang akan meningkatkan pengalaman Anda dalam merencanakan perjalanan kereta api. Pertama, website ini menyediakan informasi yang lengkap mengenai jadwal kereta api, rute perjalanan, tarif, dan ketersediaan tiket. Dengan informasi yang lengkap ini, Anda dapat dengan mudah mencari dan membandingkan opsi perjalanan yang tersedia tanpa harus mencari-cari di berbagai sumber. Selain itu, keakuratan dan keandalan informasi yang disediakan oleh website ini juga menjadi alasan untuk memilihnya. Informasi yang diberikan berasal dari sumber resmi, sehingga Anda dapat mengandalkan informasi tersebut untuk merencanakan perjalanan dengan percaya diri. \r\n\r\nSelain itu, website ini juga memiliki antarmuka pengguna yang intuitif dan mudah digunakan. Dengan antarmuka pengguna yang baik, Anda dapat dengan cepat menemukan informasi yang Anda butuhkan, melakukan pencarian dengan mudah, dan membeli tiket kereta api dengan simpel. Fitur pencarian yang canggih juga disediakan, memungkinkan Anda untuk mengatur preferensi perjalanan dan menemukan opsi perjalanan yang sesuai dengan kebutuhan Anda. \r\n\r\nKeunggulan lainnya adalah pembaruan informasi secara real-time yang disediakan oleh website ini. Anda dapat dengan mudah melihat perubahan jadwal, penundaan, atau pembatalan kereta api yang terjadi secara langsung. Informasi ini sangat berharga dalam mengatur perjalanan Anda agar tetap terinformasi dan dapat menghindari ketidaknyamanan yang tidak diinginkan. \r\n\r\nTerakhir, layanan pelanggan yang responsif juga menjadi alasan penting untuk memilih website ini. Jika Anda memiliki pertanyaan atau masalah terkait pemesanan tiket atau informasi perjalanan, tim dukungan pelanggan yang responsif akan siap membantu Anda dengan cepat dan efisien. \r\n\r\nDengan memilih website Sistem Informasi Kereta Api Terbaik ini, Anda akan mendapatkan pengalaman yang nyaman, efisien, dan dapat diandalkan dalam merencanakan perjalanan kereta api Anda.', '2023-05-19');

-- --------------------------------------------------------

--
-- Stand-in structure for view `artikel_view`
-- (See below for the actual view)
--
CREATE TABLE `artikel_view` (
`id` int(11)
,`judul` text
,`isi` text
,`tanggal` date
);

-- --------------------------------------------------------

--
-- Table structure for table `asal`
--

CREATE TABLE `asal` (
  `id` int(11) NOT NULL,
  `nama_asal` text NOT NULL,
  `id_kereta` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `asal`
--

INSERT INTO `asal` (`id`, `nama_asal`, `id_kereta`) VALUES
(49, 'Surabaya - Stasiun Semut', 34),
(50, 'Surabaya - Stasiun Semut', 35),
(53, 'Surabaya - Stasiun Semut', 36),
(54, 'Bandung - Stasiun Hall', 43),
(56, 'Surabaya - Stasiun Semut', 45),
(58, 'Bandung - Stasiun Hall', 47),
(59, 'Malang - Stasiun Malang Kotabaru', 48),
(60, 'Bandung - Stasiun Hall', 49),
(62, 'Bandung - Stasiun Hall', 51);

-- --------------------------------------------------------

--
-- Table structure for table `gerbong`
--

CREATE TABLE `gerbong` (
  `id` int(11) NOT NULL,
  `posisi_gerbong` varchar(2) NOT NULL,
  `id_kereta` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `gerbong`
--

INSERT INTO `gerbong` (`id`, `posisi_gerbong`, `id_kereta`) VALUES
(181, 'A', 34),
(182, 'B', 34),
(183, 'C', 34),
(184, 'D', 34),
(185, 'E', 34),
(186, 'A', 35),
(187, 'B', 35),
(188, 'C', 35),
(189, 'D', 35),
(190, 'E', 35),
(193, 'A', 36),
(194, 'B', 36),
(195, 'C', 36),
(196, 'D', 36),
(197, 'E', 36),
(198, 'A', 43),
(199, 'B', 43),
(200, 'C', 43),
(201, 'D', 43),
(202, 'E', 43),
(203, 'A', 45),
(204, 'B', 45),
(205, 'C', 45),
(206, 'D', 45),
(207, 'E', 45),
(213, 'A', 47),
(214, 'B', 47),
(215, 'C', 47),
(216, 'D', 47),
(217, 'E', 47),
(218, 'A', 48),
(219, 'B', 48),
(220, 'C', 48),
(221, 'D', 48),
(222, 'E', 48),
(223, 'A', 49),
(224, 'B', 49),
(225, 'C', 49),
(226, 'D', 49),
(227, 'E', 49),
(233, 'A', 51),
(234, 'B', 51),
(235, 'C', 51),
(236, 'D', 51),
(237, 'E', 51);

-- --------------------------------------------------------

--
-- Table structure for table `kereta`
--

CREATE TABLE `kereta` (
  `id` int(11) NOT NULL,
  `nama_kereta` varchar(400) NOT NULL,
  `kelas` varchar(50) NOT NULL,
  `tanggal` date NOT NULL,
  `jam_berangkat` varchar(5) NOT NULL,
  `jam_tiba` varchar(5) NOT NULL,
  `tarif_dewasa` decimal(22,2) NOT NULL,
  `tarif_anak` decimal(22,2) NOT NULL,
  `status` varchar(200) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `kereta`
--

INSERT INTO `kereta` (`id`, `nama_kereta`, `kelas`, `tanggal`, `jam_berangkat`, `jam_tiba`, `tarif_dewasa`, `tarif_anak`, `status`) VALUES
(34, 'Kereta Api Argo Bromo Anggrek', 'Eksekutif', '2023-05-24', '14:17', '20:23', '24000.00', '18000.00', 'Berangkat'),
(35, 'Kereta Api Logawa', 'Eksekutif', '2023-05-23', '14:21', '20:22', '24000.00', '17000.00', 'Berangkat'),
(36, 'Kereta Api Brantas', 'Ekonomi', '2023-05-21', '16:30', '23:59', '24000.00', '19000.00', 'Berangkat'),
(43, 'Kereta Api Argo Lawu', 'Eksekutif', '2023-05-21', '16:30', '23:00', '20000.00', '15000.00', 'Berangkat'),
(45, 'Kereta Api Argo Lawu Express', 'Eksekutif', '2023-05-22', '12:00', '17:17', '23500.00', '18000.00', 'Berangkat'),
(47, 'Kereta Api Waluya', 'Eksekutif', '2023-05-24', '16:37', '22:38', '10000.00', '24000.00', 'Berangkat'),
(48, 'Kereta Api Logawa Express', 'Eksekutif', '2023-05-24', '16:44', '22:45', '10000.00', '20000.00', 'Berangkat'),
(49, 'Kereta Sumpah Pemuda', 'Eksekutif', '2023-05-24', '16:47', '22:47', '10000.00', '24000.00', 'Berangkat'),
(51, 'Kereta Api Bandoeng', 'Bisnis', '2023-05-29', '12:00', '22:59', '29000.00', '19000.00', 'Belum berangkat');

--
-- Triggers `kereta`
--
DELIMITER $$
CREATE TRIGGER `after_delete_kereta` AFTER DELETE ON `kereta` FOR EACH ROW BEGIN
    -- Hapus data terkait di tabel asal
    DELETE FROM asal WHERE id_kereta = OLD.id;

    -- Hapus data terkait di tabel tujuan
    DELETE FROM tujuan WHERE id_kereta = OLD.id;

END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `cek_status_belum_berangkat` BEFORE DELETE ON `kereta` FOR EACH ROW BEGIN
    IF OLD.status = 'Belum berangkat' THEN
        SIGNAL SQLSTATE '45000' 
            SET MESSAGE_TEXT = 'Tidak dapat menghapus data dari Tabel Kereta. Status masih "Belum berangkat".';
    END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `cek_waktu_sekarang` BEFORE INSERT ON `kereta` FOR EACH ROW BEGIN
    DECLARE waktu_sekarang TIMESTAMP;
    SET waktu_sekarang = NOW();
    
    IF NEW.tanggal < DATE(waktu_sekarang) OR (NEW.tanggal = DATE(waktu_sekarang) AND NEW.jam_berangkat < TIME(waktu_sekarang)) THEN
        SIGNAL SQLSTATE '45000' 
            SET MESSAGE_TEXT = 'Tidak dapat menambahkan ke dalam Tabel Kereta. Tanggal dan jam harus di atas atau sama dengan waktu saat ini.';
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `kontak_us`
--

CREATE TABLE `kontak_us` (
  `no_telp` varchar(14) NOT NULL,
  `email` varchar(400) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `kontak_us`
--

INSERT INTO `kontak_us` (`no_telp`, `email`) VALUES
('082326052023', 'kelompok11pa@smbd.4c');

--
-- Triggers `kontak_us`
--
DELIMITER $$
CREATE TRIGGER `KONTAK` BEFORE UPDATE ON `kontak_us` FOR EACH ROW BEGIN
SET NEW.email = LOWER(NEW.email);
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `kursi`
--

CREATE TABLE `kursi` (
  `id` int(255) NOT NULL,
  `posisi_kursi` varchar(4) NOT NULL,
  `status` varchar(8) NOT NULL,
  `kd_booking` varchar(10) DEFAULT NULL,
  `id_gerbong` int(11) NOT NULL,
  `id_pelanggan` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `kursi`
--

INSERT INTO `kursi` (`id`, `posisi_kursi`, `status`, `kd_booking`, `id_gerbong`, `id_pelanggan`) VALUES
(1651, '1', 'tersedia', NULL, 181, NULL),
(1652, '2', 'tersedia', NULL, 181, NULL),
(1653, '3', 'tersedia', NULL, 181, NULL),
(1654, '4', 'tersedia', NULL, 181, NULL),
(1655, '5', 'tersedia', NULL, 181, NULL),
(1656, '6', 'tersedia', NULL, 181, NULL),
(1657, '7', 'tersedia', NULL, 181, NULL),
(1658, '8', 'tersedia', NULL, 181, NULL),
(1659, '9', 'tersedia', NULL, 181, NULL),
(1660, '10', 'tersedia', NULL, 181, NULL),
(1661, '11', 'tersedia', NULL, 182, NULL),
(1662, '12', 'tersedia', NULL, 182, NULL),
(1663, '13', 'tersedia', NULL, 182, NULL),
(1664, '14', 'tersedia', NULL, 182, NULL),
(1665, '15', 'tersedia', NULL, 182, NULL),
(1666, '16', 'tersedia', NULL, 182, NULL),
(1667, '17', 'tersedia', NULL, 182, NULL),
(1668, '18', 'tersedia', NULL, 182, NULL),
(1669, '19', 'tersedia', NULL, 182, NULL),
(1670, '20', 'tersedia', NULL, 182, NULL),
(1671, '21', 'tersedia', NULL, 183, NULL),
(1672, '22', 'tersedia', NULL, 183, NULL),
(1673, '23', 'tersedia', NULL, 183, NULL),
(1674, '24', 'tersedia', NULL, 183, NULL),
(1675, '25', 'tersedia', NULL, 183, NULL),
(1676, '26', 'tersedia', NULL, 183, NULL),
(1677, '27', 'tersedia', NULL, 183, NULL),
(1678, '28', 'tersedia', NULL, 183, NULL),
(1679, '29', 'tersedia', NULL, 183, NULL),
(1680, '30', 'tersedia', NULL, 183, NULL),
(1681, '31', 'tersedia', NULL, 184, NULL),
(1682, '32', 'tersedia', NULL, 184, NULL),
(1683, '33', 'tersedia', NULL, 184, NULL),
(1684, '34', 'tersedia', NULL, 184, NULL),
(1685, '35', 'tersedia', NULL, 184, NULL),
(1686, '36', 'tersedia', NULL, 184, NULL),
(1687, '37', 'tersedia', NULL, 184, NULL),
(1688, '38', 'tersedia', NULL, 184, NULL),
(1689, '39', 'tersedia', NULL, 184, NULL),
(1690, '40', 'tersedia', NULL, 184, NULL),
(1691, '41', 'tersedia', NULL, 185, NULL),
(1692, '42', 'tersedia', NULL, 185, NULL),
(1693, '43', 'tersedia', NULL, 185, NULL),
(1694, '44', 'tersedia', NULL, 185, NULL),
(1695, '45', 'tersedia', NULL, 185, NULL),
(1696, '46', 'tersedia', NULL, 185, NULL),
(1697, '47', 'tersedia', NULL, 185, NULL),
(1698, '48', 'tersedia', NULL, 185, NULL),
(1699, '49', 'tersedia', NULL, 185, NULL),
(1700, '50', 'tersedia', NULL, 185, NULL),
(1701, '1', 'tersedia', NULL, 186, NULL),
(1702, '2', 'tersedia', NULL, 186, NULL),
(1703, '3', 'tersedia', NULL, 186, NULL),
(1704, '4', 'tersedia', NULL, 186, NULL),
(1705, '5', 'tersedia', NULL, 186, NULL),
(1706, '6', 'tersedia', NULL, 186, NULL),
(1707, '7', 'tersedia', NULL, 186, NULL),
(1708, '8', 'tersedia', NULL, 186, NULL),
(1709, '9', 'tersedia', NULL, 186, NULL),
(1710, '10', 'tersedia', NULL, 186, NULL),
(1711, '11', 'tersedia', NULL, 187, NULL),
(1712, '12', 'tersedia', NULL, 187, NULL),
(1713, '13', 'tersedia', NULL, 187, NULL),
(1714, '14', 'tersedia', NULL, 187, NULL),
(1715, '15', 'tersedia', NULL, 187, NULL),
(1716, '16', 'tersedia', NULL, 187, NULL),
(1717, '17', 'tersedia', NULL, 187, NULL),
(1718, '18', 'tersedia', NULL, 187, NULL),
(1719, '19', 'tersedia', NULL, 187, NULL),
(1720, '20', 'tersedia', NULL, 187, NULL),
(1721, '21', 'tersedia', NULL, 188, NULL),
(1722, '22', 'tersedia', NULL, 188, NULL),
(1723, '23', 'tersedia', NULL, 188, NULL),
(1724, '24', 'tersedia', NULL, 188, NULL),
(1725, '25', 'tersedia', NULL, 188, NULL),
(1726, '26', 'tersedia', NULL, 188, NULL),
(1727, '27', 'tersedia', NULL, 188, NULL),
(1728, '28', 'tersedia', NULL, 188, NULL),
(1729, '29', 'tersedia', NULL, 188, NULL),
(1730, '30', 'tersedia', NULL, 188, NULL),
(1731, '31', 'tersedia', NULL, 189, NULL),
(1732, '32', 'tersedia', NULL, 189, NULL),
(1733, '33', 'tersedia', NULL, 189, NULL),
(1734, '34', 'tersedia', NULL, 189, NULL),
(1735, '35', 'tersedia', NULL, 189, NULL),
(1736, '36', 'tersedia', NULL, 189, NULL),
(1737, '37', 'tersedia', NULL, 189, NULL),
(1738, '38', 'tersedia', NULL, 189, NULL),
(1739, '39', 'tersedia', NULL, 189, NULL),
(1740, '40', 'tersedia', NULL, 189, NULL),
(1741, '41', 'tersedia', NULL, 190, NULL),
(1742, '42', 'tersedia', NULL, 190, NULL),
(1743, '43', 'tersedia', NULL, 190, NULL),
(1744, '44', 'tersedia', NULL, 190, NULL),
(1745, '45', 'tersedia', NULL, 190, NULL),
(1746, '46', 'tersedia', NULL, 190, NULL),
(1747, '47', 'tersedia', NULL, 190, NULL),
(1748, '48', 'tersedia', NULL, 190, NULL),
(1749, '49', 'tersedia', NULL, 190, NULL),
(1750, '50', 'tersedia', NULL, 190, NULL),
(1751, '1', 'tersedia', NULL, 193, NULL),
(1752, '2', 'booked', '647j3m', 193, 64),
(1753, '3', 'tersedia', NULL, 193, NULL),
(1754, '4', 'tersedia', NULL, 193, NULL),
(1755, '5', 'tersedia', NULL, 193, NULL),
(1756, '6', 'tersedia', NULL, 193, NULL),
(1757, '7', 'tersedia', NULL, 193, NULL),
(1758, '8', 'tersedia', NULL, 193, NULL),
(1759, '9', 'tersedia', NULL, 193, NULL),
(1760, '10', 'tersedia', NULL, 193, NULL),
(1761, '11', 'tersedia', NULL, 194, NULL),
(1762, '12', 'tersedia', NULL, 194, NULL),
(1763, '13', 'tersedia', NULL, 194, NULL),
(1764, '14', 'tersedia', NULL, 194, NULL),
(1765, '15', 'tersedia', NULL, 194, NULL),
(1766, '16', 'tersedia', NULL, 194, NULL),
(1767, '17', 'tersedia', NULL, 194, NULL),
(1768, '18', 'tersedia', NULL, 194, NULL),
(1769, '19', 'tersedia', NULL, 194, NULL),
(1770, '20', 'tersedia', NULL, 194, NULL),
(1771, '21', 'tersedia', NULL, 195, NULL),
(1772, '22', 'tersedia', NULL, 195, NULL),
(1773, '23', 'tersedia', NULL, 195, NULL),
(1774, '24', 'tersedia', NULL, 195, NULL),
(1775, '25', 'tersedia', NULL, 195, NULL),
(1776, '26', 'tersedia', NULL, 195, NULL),
(1777, '27', 'tersedia', NULL, 195, NULL),
(1778, '28', 'tersedia', NULL, 195, NULL),
(1779, '29', 'tersedia', NULL, 195, NULL),
(1780, '30', 'tersedia', NULL, 195, NULL),
(1781, '31', 'tersedia', NULL, 196, NULL),
(1782, '32', 'tersedia', NULL, 196, NULL),
(1783, '33', 'tersedia', NULL, 196, NULL),
(1784, '34', 'tersedia', NULL, 196, NULL),
(1785, '35', 'tersedia', NULL, 196, NULL),
(1786, '36', 'tersedia', NULL, 196, NULL),
(1787, '37', 'tersedia', NULL, 196, NULL),
(1788, '38', 'tersedia', NULL, 196, NULL),
(1789, '39', 'tersedia', NULL, 196, NULL),
(1790, '40', 'tersedia', NULL, 196, NULL),
(1791, '41', 'tersedia', NULL, 197, NULL),
(1792, '42', 'tersedia', NULL, 197, NULL),
(1793, '43', 'tersedia', NULL, 197, NULL),
(1794, '44', 'tersedia', NULL, 197, NULL),
(1795, '45', 'tersedia', NULL, 197, NULL),
(1796, '46', 'tersedia', NULL, 197, NULL),
(1797, '47', 'tersedia', NULL, 197, NULL),
(1798, '48', 'tersedia', NULL, 197, NULL),
(1799, '49', 'tersedia', NULL, 197, NULL),
(1800, '50', 'tersedia', NULL, 197, NULL),
(1801, '1', 'tersedia', NULL, 198, NULL),
(1802, '2', 'tersedia', NULL, 198, NULL),
(1803, '3', 'tersedia', NULL, 198, NULL),
(1804, '4', 'tersedia', NULL, 198, NULL),
(1805, '5', 'tersedia', NULL, 198, NULL),
(1806, '6', 'tersedia', NULL, 198, NULL),
(1807, '7', 'tersedia', NULL, 198, NULL),
(1808, '8', 'tersedia', NULL, 198, NULL),
(1809, '9', 'tersedia', NULL, 198, NULL),
(1810, '10', 'tersedia', NULL, 198, NULL),
(1811, '11', 'tersedia', NULL, 199, NULL),
(1812, '12', 'tersedia', NULL, 199, NULL),
(1813, '13', 'tersedia', NULL, 199, NULL),
(1814, '14', 'tersedia', NULL, 199, NULL),
(1815, '15', 'tersedia', NULL, 199, NULL),
(1816, '16', 'tersedia', NULL, 199, NULL),
(1817, '17', 'tersedia', NULL, 199, NULL),
(1818, '18', 'tersedia', NULL, 199, NULL),
(1819, '19', 'tersedia', NULL, 199, NULL),
(1820, '20', 'tersedia', NULL, 199, NULL),
(1821, '21', 'tersedia', NULL, 200, NULL),
(1822, '22', 'tersedia', NULL, 200, NULL),
(1823, '23', 'tersedia', NULL, 200, NULL),
(1824, '24', 'tersedia', NULL, 200, NULL),
(1825, '25', 'tersedia', NULL, 200, NULL),
(1826, '26', 'tersedia', NULL, 200, NULL),
(1827, '27', 'tersedia', NULL, 200, NULL),
(1828, '28', 'tersedia', NULL, 200, NULL),
(1829, '29', 'tersedia', NULL, 200, NULL),
(1830, '30', 'tersedia', NULL, 200, NULL),
(1831, '31', 'tersedia', NULL, 201, NULL),
(1832, '32', 'tersedia', NULL, 201, NULL),
(1833, '33', 'tersedia', NULL, 201, NULL),
(1834, '34', 'tersedia', NULL, 201, NULL),
(1835, '35', 'tersedia', NULL, 201, NULL),
(1836, '36', 'tersedia', NULL, 201, NULL),
(1837, '37', 'tersedia', NULL, 201, NULL),
(1838, '38', 'tersedia', NULL, 201, NULL),
(1839, '39', 'tersedia', NULL, 201, NULL),
(1840, '40', 'tersedia', NULL, 201, NULL),
(1841, '41', 'tersedia', NULL, 202, NULL),
(1842, '42', 'tersedia', NULL, 202, NULL),
(1843, '43', 'tersedia', NULL, 202, NULL),
(1844, '44', 'tersedia', NULL, 202, NULL),
(1845, '45', 'tersedia', NULL, 202, NULL),
(1846, '46', 'tersedia', NULL, 202, NULL),
(1847, '47', 'tersedia', NULL, 202, NULL),
(1848, '48', 'tersedia', NULL, 202, NULL),
(1849, '49', 'tersedia', NULL, 202, NULL),
(1850, '50', 'tersedia', NULL, 202, NULL),
(1851, '1', 'tersedia', NULL, 203, NULL),
(1852, '2', 'booked', 'klk87k', 203, 67),
(1853, '3', 'tersedia', NULL, 203, NULL),
(1854, '4', 'tersedia', NULL, 203, NULL),
(1855, '5', 'tersedia', NULL, 203, NULL),
(1856, '6', 'tersedia', NULL, 203, NULL),
(1857, '7', 'tersedia', NULL, 203, NULL),
(1858, '8', 'tersedia', NULL, 203, NULL),
(1859, '9', 'tersedia', NULL, 203, NULL),
(1860, '10', 'tersedia', NULL, 203, NULL),
(1861, '1', 'tersedia', NULL, 204, NULL),
(1862, '2', 'tersedia', NULL, 204, NULL),
(1863, '3', 'tersedia', NULL, 204, NULL),
(1864, '4', 'tersedia', NULL, 204, NULL),
(1865, '5', 'tersedia', NULL, 204, NULL),
(1866, '6', 'tersedia', NULL, 204, NULL),
(1867, '7', 'tersedia', NULL, 204, NULL),
(1868, '8', 'tersedia', NULL, 204, NULL),
(1869, '9', 'tersedia', NULL, 204, NULL),
(1870, '10', 'tersedia', NULL, 204, NULL),
(1871, '1', 'tersedia', NULL, 205, NULL),
(1872, '2', 'tersedia', NULL, 205, NULL),
(1873, '3', 'tersedia', NULL, 205, NULL),
(1874, '4', 'tersedia', NULL, 205, NULL),
(1875, '5', 'tersedia', NULL, 205, NULL),
(1876, '6', 'tersedia', NULL, 205, NULL),
(1877, '7', 'tersedia', NULL, 205, NULL),
(1878, '8', 'tersedia', NULL, 205, NULL),
(1879, '9', 'tersedia', NULL, 205, NULL),
(1880, '10', 'tersedia', NULL, 205, NULL),
(1881, '1', 'tersedia', NULL, 206, NULL),
(1882, '2', 'tersedia', NULL, 206, NULL),
(1883, '3', 'tersedia', NULL, 206, NULL),
(1884, '4', 'tersedia', NULL, 206, NULL),
(1885, '5', 'tersedia', NULL, 206, NULL),
(1886, '6', 'tersedia', NULL, 206, NULL),
(1887, '7', 'tersedia', NULL, 206, NULL),
(1888, '8', 'tersedia', NULL, 206, NULL),
(1889, '9', 'tersedia', NULL, 206, NULL),
(1890, '10', 'tersedia', NULL, 206, NULL),
(1891, '1', 'tersedia', NULL, 207, NULL),
(1892, '2', 'tersedia', NULL, 207, NULL),
(1893, '3', 'tersedia', NULL, 207, NULL),
(1894, '4', 'tersedia', NULL, 207, NULL),
(1895, '5', 'tersedia', NULL, 207, NULL),
(1896, '6', 'tersedia', NULL, 207, NULL),
(1897, '7', 'tersedia', NULL, 207, NULL),
(1898, '8', 'tersedia', NULL, 207, NULL),
(1899, '9', 'tersedia', NULL, 207, NULL),
(1900, '10', 'tersedia', NULL, 207, NULL),
(1951, '1', 'booked', 'nfd7kr', 213, 73),
(1952, '2', 'tersedia', NULL, 213, NULL),
(1953, '3', 'tersedia', NULL, 213, NULL),
(1954, '4', 'tersedia', NULL, 213, NULL),
(1955, '5', 'tersedia', NULL, 213, NULL),
(1956, '6', 'tersedia', NULL, 213, NULL),
(1957, '7', 'tersedia', NULL, 213, NULL),
(1958, '8', 'tersedia', NULL, 213, NULL),
(1959, '9', 'tersedia', NULL, 213, NULL),
(1960, '10', 'tersedia', NULL, 213, NULL),
(1961, '1', 'tersedia', NULL, 214, NULL),
(1962, '2', 'tersedia', NULL, 214, NULL),
(1963, '3', 'tersedia', NULL, 214, NULL),
(1964, '4', 'tersedia', NULL, 214, NULL),
(1965, '5', 'tersedia', NULL, 214, NULL),
(1966, '6', 'tersedia', NULL, 214, NULL),
(1967, '7', 'tersedia', NULL, 214, NULL),
(1968, '8', 'tersedia', NULL, 214, NULL),
(1969, '9', 'tersedia', NULL, 214, NULL),
(1970, '10', 'tersedia', NULL, 214, NULL),
(1971, '1', 'tersedia', NULL, 215, NULL),
(1972, '2', 'tersedia', NULL, 215, NULL),
(1973, '3', 'tersedia', NULL, 215, NULL),
(1974, '4', 'tersedia', NULL, 215, NULL),
(1975, '5', 'tersedia', NULL, 215, NULL),
(1976, '6', 'tersedia', NULL, 215, NULL),
(1977, '7', 'tersedia', NULL, 215, NULL),
(1978, '8', 'tersedia', NULL, 215, NULL),
(1979, '9', 'tersedia', NULL, 215, NULL),
(1980, '10', 'tersedia', NULL, 215, NULL),
(1981, '1', 'tersedia', NULL, 216, NULL),
(1982, '2', 'tersedia', NULL, 216, NULL),
(1983, '3', 'tersedia', NULL, 216, NULL),
(1984, '4', 'tersedia', NULL, 216, NULL),
(1985, '5', 'tersedia', NULL, 216, NULL),
(1986, '6', 'tersedia', NULL, 216, NULL),
(1987, '7', 'tersedia', NULL, 216, NULL),
(1988, '8', 'tersedia', NULL, 216, NULL),
(1989, '9', 'tersedia', NULL, 216, NULL),
(1990, '10', 'tersedia', NULL, 216, NULL),
(1991, '1', 'tersedia', NULL, 217, NULL),
(1992, '2', 'tersedia', NULL, 217, NULL),
(1993, '3', 'tersedia', NULL, 217, NULL),
(1994, '4', 'tersedia', NULL, 217, NULL),
(1995, '5', 'tersedia', NULL, 217, NULL),
(1996, '6', 'tersedia', NULL, 217, NULL),
(1997, '7', 'tersedia', NULL, 217, NULL),
(1998, '8', 'tersedia', NULL, 217, NULL),
(1999, '9', 'tersedia', NULL, 217, NULL),
(2000, '10', 'tersedia', NULL, 217, NULL),
(2001, '1', 'tersedia', NULL, 218, NULL),
(2002, '2', 'tersedia', NULL, 218, NULL),
(2003, '3', 'tersedia', NULL, 218, NULL),
(2004, '4', 'tersedia', NULL, 218, NULL),
(2005, '5', 'tersedia', NULL, 218, NULL),
(2006, '6', 'tersedia', NULL, 218, NULL),
(2007, '7', 'tersedia', NULL, 218, NULL),
(2008, '8', 'tersedia', NULL, 218, NULL),
(2009, '9', 'tersedia', NULL, 218, NULL),
(2010, '10', 'tersedia', NULL, 218, NULL),
(2011, '1', 'tersedia', NULL, 219, NULL),
(2012, '2', 'tersedia', NULL, 219, NULL),
(2013, '3', 'tersedia', NULL, 219, NULL),
(2014, '4', 'tersedia', NULL, 219, NULL),
(2015, '5', 'tersedia', NULL, 219, NULL),
(2016, '6', 'tersedia', NULL, 219, NULL),
(2017, '7', 'tersedia', NULL, 219, NULL),
(2018, '8', 'tersedia', NULL, 219, NULL),
(2019, '9', 'tersedia', NULL, 219, NULL),
(2020, '10', 'tersedia', NULL, 219, NULL),
(2021, '1', 'tersedia', NULL, 220, NULL),
(2022, '2', 'tersedia', NULL, 220, NULL),
(2023, '3', 'tersedia', NULL, 220, NULL),
(2024, '4', 'tersedia', NULL, 220, NULL),
(2025, '5', 'tersedia', NULL, 220, NULL),
(2026, '6', 'tersedia', NULL, 220, NULL),
(2027, '7', 'tersedia', NULL, 220, NULL),
(2028, '8', 'tersedia', NULL, 220, NULL),
(2029, '9', 'tersedia', NULL, 220, NULL),
(2030, '10', 'tersedia', NULL, 220, NULL),
(2031, '1', 'tersedia', NULL, 221, NULL),
(2032, '2', 'tersedia', NULL, 221, NULL),
(2033, '3', 'tersedia', NULL, 221, NULL),
(2034, '4', 'tersedia', NULL, 221, NULL),
(2035, '5', 'tersedia', NULL, 221, NULL),
(2036, '6', 'tersedia', NULL, 221, NULL),
(2037, '7', 'tersedia', NULL, 221, NULL),
(2038, '8', 'tersedia', NULL, 221, NULL),
(2039, '9', 'tersedia', NULL, 221, NULL),
(2040, '10', 'tersedia', NULL, 221, NULL),
(2041, '1', 'tersedia', NULL, 222, NULL),
(2042, '2', 'tersedia', NULL, 222, NULL),
(2043, '3', 'tersedia', NULL, 222, NULL),
(2044, '4', 'tersedia', NULL, 222, NULL),
(2045, '5', 'tersedia', NULL, 222, NULL),
(2046, '6', 'tersedia', NULL, 222, NULL),
(2047, '7', 'tersedia', NULL, 222, NULL),
(2048, '8', 'tersedia', NULL, 222, NULL),
(2049, '9', 'tersedia', NULL, 222, NULL),
(2050, '10', 'tersedia', NULL, 222, NULL),
(2051, '1', 'tersedia', NULL, 223, NULL),
(2052, '2', 'tersedia', NULL, 223, NULL),
(2053, '3', 'tersedia', NULL, 223, NULL),
(2054, '4', 'tersedia', NULL, 223, NULL),
(2055, '5', 'tersedia', NULL, 223, NULL),
(2056, '6', 'tersedia', NULL, 223, NULL),
(2057, '7', 'tersedia', NULL, 223, NULL),
(2058, '8', 'tersedia', NULL, 223, NULL),
(2059, '9', 'tersedia', NULL, 223, NULL),
(2060, '10', 'tersedia', NULL, 223, NULL),
(2061, '1', 'tersedia', NULL, 224, NULL),
(2062, '2', 'tersedia', NULL, 224, NULL),
(2063, '3', 'tersedia', NULL, 224, NULL),
(2064, '4', 'tersedia', NULL, 224, NULL),
(2065, '5', 'tersedia', NULL, 224, NULL),
(2066, '6', 'tersedia', NULL, 224, NULL),
(2067, '7', 'tersedia', NULL, 224, NULL),
(2068, '8', 'tersedia', NULL, 224, NULL),
(2069, '9', 'tersedia', NULL, 224, NULL),
(2070, '10', 'tersedia', NULL, 224, NULL),
(2071, '1', 'tersedia', NULL, 225, NULL),
(2072, '2', 'tersedia', NULL, 225, NULL),
(2073, '3', 'tersedia', NULL, 225, NULL),
(2074, '4', 'tersedia', NULL, 225, NULL),
(2075, '5', 'tersedia', NULL, 225, NULL),
(2076, '6', 'tersedia', NULL, 225, NULL),
(2077, '7', 'tersedia', NULL, 225, NULL),
(2078, '8', 'tersedia', NULL, 225, NULL),
(2079, '9', 'tersedia', NULL, 225, NULL),
(2080, '10', 'tersedia', NULL, 225, NULL),
(2081, '1', 'tersedia', NULL, 226, NULL),
(2082, '2', 'tersedia', NULL, 226, NULL),
(2083, '3', 'tersedia', NULL, 226, NULL),
(2084, '4', 'tersedia', NULL, 226, NULL),
(2085, '5', 'tersedia', NULL, 226, NULL),
(2086, '6', 'tersedia', NULL, 226, NULL),
(2087, '7', 'tersedia', NULL, 226, NULL),
(2088, '8', 'tersedia', NULL, 226, NULL),
(2089, '9', 'tersedia', NULL, 226, NULL),
(2090, '10', 'tersedia', NULL, 226, NULL),
(2091, '1', 'tersedia', NULL, 227, NULL),
(2092, '2', 'tersedia', NULL, 227, NULL),
(2093, '3', 'tersedia', NULL, 227, NULL),
(2094, '4', 'tersedia', NULL, 227, NULL),
(2095, '5', 'tersedia', NULL, 227, NULL),
(2096, '6', 'tersedia', NULL, 227, NULL),
(2097, '7', 'tersedia', NULL, 227, NULL),
(2098, '8', 'tersedia', NULL, 227, NULL),
(2099, '9', 'tersedia', NULL, 227, NULL),
(2100, '10', 'tersedia', NULL, 227, NULL),
(2151, '1', 'booked', 'nfd7kr', 233, 74),
(2152, '2', 'tersedia', NULL, 233, NULL),
(2153, '3', 'tersedia', NULL, 233, NULL),
(2154, '4', 'tersedia', NULL, 233, NULL),
(2155, '5', 'tersedia', NULL, 233, NULL),
(2156, '6', 'tersedia', NULL, 233, NULL),
(2157, '7', 'tersedia', NULL, 233, NULL),
(2158, '8', 'tersedia', NULL, 233, NULL),
(2159, '9', 'tersedia', NULL, 233, NULL),
(2160, '10', 'tersedia', NULL, 233, NULL),
(2161, '1', 'tersedia', NULL, 234, NULL),
(2162, '2', 'tersedia', NULL, 234, NULL),
(2163, '3', 'tersedia', NULL, 234, NULL),
(2164, '4', 'tersedia', NULL, 234, NULL),
(2165, '5', 'tersedia', NULL, 234, NULL),
(2166, '6', 'tersedia', NULL, 234, NULL),
(2167, '7', 'booked', '56x0v5', 234, 76),
(2168, '8', 'tersedia', NULL, 234, NULL),
(2169, '9', 'tersedia', NULL, 234, NULL),
(2170, '10', 'tersedia', NULL, 234, NULL),
(2171, '1', 'tersedia', NULL, 235, NULL),
(2172, '2', 'tersedia', NULL, 235, NULL),
(2173, '3', 'tersedia', NULL, 235, NULL),
(2174, '4', 'tersedia', NULL, 235, NULL),
(2175, '5', 'tersedia', NULL, 235, NULL),
(2176, '6', 'tersedia', NULL, 235, NULL),
(2177, '7', 'tersedia', NULL, 235, NULL),
(2178, '8', 'tersedia', NULL, 235, NULL),
(2179, '9', 'tersedia', NULL, 235, NULL),
(2180, '10', 'tersedia', NULL, 235, NULL),
(2181, '1', 'tersedia', NULL, 236, NULL),
(2182, '2', 'tersedia', NULL, 236, NULL),
(2183, '3', 'tersedia', NULL, 236, NULL),
(2184, '4', 'tersedia', NULL, 236, NULL),
(2185, '5', 'tersedia', NULL, 236, NULL),
(2186, '6', 'tersedia', NULL, 236, NULL),
(2187, '7', 'tersedia', NULL, 236, NULL),
(2188, '8', 'tersedia', NULL, 236, NULL),
(2189, '9', 'tersedia', NULL, 236, NULL),
(2190, '10', 'tersedia', NULL, 236, NULL),
(2191, '1', 'tersedia', NULL, 237, NULL),
(2192, '2', 'tersedia', NULL, 237, NULL),
(2193, '3', 'tersedia', NULL, 237, NULL),
(2194, '4', 'tersedia', NULL, 237, NULL),
(2195, '5', 'tersedia', NULL, 237, NULL),
(2196, '6', 'tersedia', NULL, 237, NULL),
(2197, '7', 'tersedia', NULL, 237, NULL),
(2198, '8', 'tersedia', NULL, 237, NULL),
(2199, '9', 'tersedia', NULL, 237, NULL),
(2200, '10', 'tersedia', NULL, 237, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `pelanggan`
--

CREATE TABLE `pelanggan` (
  `id_pelanggan` int(11) NOT NULL,
  `no_ktp` varchar(25) NOT NULL,
  `nama_pelanggan` varchar(100) NOT NULL,
  `no_telp` varchar(20) NOT NULL,
  `email` varchar(90) NOT NULL,
  `total_pembayaran` decimal(22,2) DEFAULT NULL,
  `tgl_pemesanan` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `pelanggan`
--

INSERT INTO `pelanggan` (`id_pelanggan`, `no_ktp`, `nama_pelanggan`, `no_telp`, `email`, `total_pembayaran`, `tgl_pemesanan`) VALUES
(64, '456879', 'osfsodjh', '0997896', 'pakelompok11@SMBD.4C', '24000.00', '2023-05-22'),
(67, '56789203435', 'Nuri Hidayatuloh', '098102984230', 'asdan@gmail.com', '23500.00', '2023-05-23'),
(68, '0995847547656897', 'Yohan Permanen', '09876546789', 'xyz@gmail.com', '10000.00', '2023-05-26'),
(69, '0995847547656897', 'Yohan Permanen', '09876546789', 'xyz@gmail.com', '10000.00', '2023-05-26'),
(70, '0995847547656897', 'Yohan Permanen', '09876546789', 'xyz@gmail.com', '10000.00', '2023-05-26'),
(71, '3545674', 'Machrus', '08087340', 'hdytlh@gmail.com', '10000.00', '2023-05-26'),
(72, '3497349', 'idfheiu', '29347', 'sdfhw', '10000.00', '2023-05-26'),
(73, '01347234827', 'SKDJF', '9238472384', 'SDJFN', '10000.00', '2023-05-26'),
(74, '1111111111111111', 'Nuri', '081199991111', 'nuri121@gmail.com', '29000.00', '2023-05-26'),
(76, '1987198719871987', 'Yuli Sumpil', '081119871987', 'sumpil@gmail.com', '29000.00', '2023-05-26');

-- --------------------------------------------------------

--
-- Stand-in structure for view `pelanggan_view`
-- (See below for the actual view)
--
CREATE TABLE `pelanggan_view` (
`id_pelanggan` int(11)
,`no_ktp` varchar(25)
,`nama_pelanggan` varchar(100)
,`no_telp` varchar(20)
,`email` varchar(90)
,`total_pembayaran` decimal(22,2)
,`tgl_pemesanan` date
);

-- --------------------------------------------------------

--
-- Table structure for table `tujuan`
--

CREATE TABLE `tujuan` (
  `id` int(11) NOT NULL,
  `nama_tujuan` text NOT NULL,
  `id_kereta` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tujuan`
--

INSERT INTO `tujuan` (`id`, `nama_tujuan`, `id_kereta`) VALUES
(49, 'Semarang - Stasiun Semarang Tawang', 34),
(50, 'Yogyakarta - Stasiun Tugu', 35),
(53, 'Malang - Stasiun Malang Kotabaru', 36),
(54, 'Malang - Stasiun Malang Kotabaru', 43),
(56, 'Malang - Stasiun Malang Kotabaru', 45),
(58, 'Yogyakarta - Stasiun Tugu', 47),
(59, 'Surabaya - Stasiun Semut', 48),
(60, 'Semarang - Stasiun Semarang Tawang', 49),
(62, 'Semarang - Stasiun Semarang Tawang', 51);

-- --------------------------------------------------------

--
-- Stand-in structure for view `view_artikel_id_desc`
-- (See below for the actual view)
--
CREATE TABLE `view_artikel_id_desc` (
`id` int(11)
,`judul` text
,`isi` text
,`tanggal` date
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `view_kereta_asal_tujuan`
-- (See below for the actual view)
--
CREATE TABLE `view_kereta_asal_tujuan` (
`id` int(11)
,`nama_kereta` varchar(400)
,`kelas` varchar(50)
,`tanggal` date
,`jam_berangkat` varchar(5)
,`jam_tiba` varchar(5)
,`tarif_dewasa` decimal(22,2)
,`tarif_anak` decimal(22,2)
,`status` varchar(200)
,`nama_asal` text
,`nama_tujuan` text
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `view_pelanggan`
-- (See below for the actual view)
--
CREATE TABLE `view_pelanggan` (
`id_pelanggan` int(11)
,`nama_pelanggan` varchar(100)
,`email` varchar(90)
,`no_telp` varchar(20)
,`kursi_id` int(255)
,`status_kursi` varchar(8)
,`gerbong_id` int(11)
,`posisi_gerbong` varchar(2)
,`kereta_id` int(11)
,`nama_kereta` varchar(400)
,`kelas` varchar(50)
,`tanggal` date
,`jam_berangkat` varchar(5)
,`jam_tiba` varchar(5)
,`tarif_dewasa` decimal(22,2)
,`tarif_anak` decimal(22,2)
,`status_kereta` varchar(200)
,`nama_asal` text
,`nama_tujuan` text
);

-- --------------------------------------------------------

--
-- Structure for view `artikel_view`
--
DROP TABLE IF EXISTS `artikel_view`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `artikel_view`  AS SELECT `artikel`.`id` AS `id`, `artikel`.`judul` AS `judul`, `artikel`.`isi` AS `isi`, `artikel`.`tanggal` AS `tanggal` FROM `artikel` ;

-- --------------------------------------------------------

--
-- Structure for view `pelanggan_view`
--
DROP TABLE IF EXISTS `pelanggan_view`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `pelanggan_view`  AS SELECT `pelanggan`.`id_pelanggan` AS `id_pelanggan`, `pelanggan`.`no_ktp` AS `no_ktp`, `pelanggan`.`nama_pelanggan` AS `nama_pelanggan`, `pelanggan`.`no_telp` AS `no_telp`, `pelanggan`.`email` AS `email`, `pelanggan`.`total_pembayaran` AS `total_pembayaran`, `pelanggan`.`tgl_pemesanan` AS `tgl_pemesanan` FROM `pelanggan` WHERE `pelanggan`.`id_pelanggan` = last_insert_id() AND cast(`pelanggan`.`tgl_pemesanan` as date) = curdate() ORDER BY `pelanggan`.`id_pelanggan` DESC ;

-- --------------------------------------------------------

--
-- Structure for view `view_artikel_id_desc`
--
DROP TABLE IF EXISTS `view_artikel_id_desc`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `view_artikel_id_desc`  AS SELECT `artikel`.`id` AS `id`, `artikel`.`judul` AS `judul`, `artikel`.`isi` AS `isi`, `artikel`.`tanggal` AS `tanggal` FROM `artikel` ORDER BY `artikel`.`id` DESC ;

-- --------------------------------------------------------

--
-- Structure for view `view_kereta_asal_tujuan`
--
DROP TABLE IF EXISTS `view_kereta_asal_tujuan`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `view_kereta_asal_tujuan`  AS SELECT `k`.`id` AS `id`, `k`.`nama_kereta` AS `nama_kereta`, `k`.`kelas` AS `kelas`, `k`.`tanggal` AS `tanggal`, `k`.`jam_berangkat` AS `jam_berangkat`, `k`.`jam_tiba` AS `jam_tiba`, `k`.`tarif_dewasa` AS `tarif_dewasa`, `k`.`tarif_anak` AS `tarif_anak`, `k`.`status` AS `status`, `a`.`nama_asal` AS `nama_asal`, `t`.`nama_tujuan` AS `nama_tujuan` FROM ((`kereta` `k` join `asal` `a` on(`k`.`id` = `a`.`id_kereta`)) join `tujuan` `t` on(`a`.`id_kereta` = `t`.`id_kereta`)) ORDER BY `k`.`id` DESC ;

-- --------------------------------------------------------

--
-- Structure for view `view_pelanggan`
--
DROP TABLE IF EXISTS `view_pelanggan`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `view_pelanggan`  AS SELECT `p`.`id_pelanggan` AS `id_pelanggan`, `p`.`nama_pelanggan` AS `nama_pelanggan`, `p`.`email` AS `email`, `p`.`no_telp` AS `no_telp`, `k`.`id` AS `kursi_id`, `k`.`status` AS `status_kursi`, `g`.`id` AS `gerbong_id`, `g`.`posisi_gerbong` AS `posisi_gerbong`, `kr`.`id` AS `kereta_id`, `kr`.`nama_kereta` AS `nama_kereta`, `kr`.`kelas` AS `kelas`, `kr`.`tanggal` AS `tanggal`, `kr`.`jam_berangkat` AS `jam_berangkat`, `kr`.`jam_tiba` AS `jam_tiba`, `kr`.`tarif_dewasa` AS `tarif_dewasa`, `kr`.`tarif_anak` AS `tarif_anak`, `kr`.`status` AS `status_kereta`, `a`.`nama_asal` AS `nama_asal`, `t`.`nama_tujuan` AS `nama_tujuan` FROM (((((`pelanggan` `p` join `kursi` `k` on(`p`.`id_pelanggan` = `k`.`id_pelanggan`)) join `gerbong` `g` on(`k`.`id_gerbong` = `g`.`id`)) join `kereta` `kr` on(`g`.`id_kereta` = `kr`.`id`)) join `asal` `a` on(`kr`.`id` = `a`.`id_kereta`)) join `tujuan` `t` on(`t`.`id_kereta` = `a`.`id_kereta`)) ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `admin`
--
ALTER TABLE `admin`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `artikel`
--
ALTER TABLE `artikel`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `asal`
--
ALTER TABLE `asal`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_kereta` (`id_kereta`);

--
-- Indexes for table `gerbong`
--
ALTER TABLE `gerbong`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_kereta` (`id_kereta`);

--
-- Indexes for table `kereta`
--
ALTER TABLE `kereta`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `kontak_us`
--
ALTER TABLE `kontak_us`
  ADD PRIMARY KEY (`no_telp`);

--
-- Indexes for table `kursi`
--
ALTER TABLE `kursi`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_gerbong` (`id_gerbong`),
  ADD KEY `id_pelanggan` (`id_pelanggan`);

--
-- Indexes for table `pelanggan`
--
ALTER TABLE `pelanggan`
  ADD PRIMARY KEY (`id_pelanggan`),
  ADD KEY `id_pelanggan` (`id_pelanggan`);

--
-- Indexes for table `tujuan`
--
ALTER TABLE `tujuan`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_kereta` (`id_kereta`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `admin`
--
ALTER TABLE `admin`
  MODIFY `id` int(2) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `artikel`
--
ALTER TABLE `artikel`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `asal`
--
ALTER TABLE `asal`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=63;

--
-- AUTO_INCREMENT for table `gerbong`
--
ALTER TABLE `gerbong`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=238;

--
-- AUTO_INCREMENT for table `kereta`
--
ALTER TABLE `kereta`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=52;

--
-- AUTO_INCREMENT for table `kursi`
--
ALTER TABLE `kursi`
  MODIFY `id` int(255) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2201;

--
-- AUTO_INCREMENT for table `pelanggan`
--
ALTER TABLE `pelanggan`
  MODIFY `id_pelanggan` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=77;

--
-- AUTO_INCREMENT for table `tujuan`
--
ALTER TABLE `tujuan`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=63;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `asal`
--
ALTER TABLE `asal`
  ADD CONSTRAINT `id_kreta_CONS` FOREIGN KEY (`id_kereta`) REFERENCES `kereta` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `gerbong`
--
ALTER TABLE `gerbong`
  ADD CONSTRAINT `idkereta_CONS` FOREIGN KEY (`id_kereta`) REFERENCES `kereta` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `kursi`
--
ALTER TABLE `kursi`
  ADD CONSTRAINT `id_kursi_CONS` FOREIGN KEY (`id_gerbong`) REFERENCES `gerbong` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `id_pelanggan_CONS` FOREIGN KEY (`id_pelanggan`) REFERENCES `pelanggan` (`id_pelanggan`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `tujuan`
--
ALTER TABLE `tujuan`
  ADD CONSTRAINT `id_kerta_CONS` FOREIGN KEY (`id_kereta`) REFERENCES `kereta` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
