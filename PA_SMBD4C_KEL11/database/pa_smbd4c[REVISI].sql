-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jun 09, 2023 at 09:55 AM
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_kursi` (IN `kursi_id` INT(100))  BEGIN
    DECLARE kursi_status VARCHAR(10);
    
    -- Mendapatkan status kursi sebelum dihapus
    SELECT status INTO kursi_status FROM kursi WHERE id = kursi_id;
    
    -- Jika status sebelumnya adalah "tersedia", batalkan penghapusan
    IF kursi_status = 'tersedia' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Kursi dengan status "tersedia" tidak dapat dihapus.';
    END IF;

    -- Jika status sebelumnya adalah "booked", lakukan update status menjadi "tersedia"
    IF kursi_status = 'booked' THEN
        UPDATE kursi SET status = 'tersedia', kd_booking = NULL, id_pelanggan = NULL WHERE id = kursi_id;
    END IF;
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
(1, 'admin', 'PAKEL11');

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
(64, 'Bandung - Stasiun Hall', 53);

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
(243, 'A', 53),
(244, 'B', 53),
(245, 'C', 53),
(246, 'D', 53),
(247, 'E', 53);

--
-- Triggers `gerbong`
--
DELIMITER $$
CREATE TRIGGER `trg_before_delete_gerbong` BEFORE DELETE ON `gerbong` FOR EACH ROW BEGIN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Tidak diizinkan menghapus data dari tabel "gerbong".';
END
$$
DELIMITER ;

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
(53, 'Kereta Api Brantas', 'Eksekutif', '2023-06-09', '19:00', '23:00', '25000.00', '19000.00', 'Belum berangkat');

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
('081122334455', 'pa11smbd');

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
(2251, '1', 'tersedia', NULL, 243, NULL),
(2252, '2', 'tersedia', NULL, 243, NULL),
(2253, '3', 'tersedia', NULL, 243, NULL),
(2254, '4', 'tersedia', NULL, 243, NULL),
(2255, '5', 'tersedia', NULL, 243, NULL),
(2256, '6', 'tersedia', NULL, 243, NULL),
(2257, '7', 'tersedia', NULL, 243, NULL),
(2258, '8', 'tersedia', NULL, 243, NULL),
(2259, '9', 'tersedia', NULL, 243, NULL),
(2260, '10', 'tersedia', NULL, 243, NULL),
(2261, '1', 'tersedia', NULL, 244, NULL),
(2262, '2', 'tersedia', NULL, 244, NULL),
(2263, '3', 'tersedia', NULL, 244, NULL),
(2264, '4', 'tersedia', NULL, 244, NULL),
(2265, '5', 'tersedia', NULL, 244, NULL),
(2266, '6', 'tersedia', NULL, 244, NULL),
(2267, '7', 'tersedia', NULL, 244, NULL),
(2268, '8', 'tersedia', NULL, 244, NULL),
(2269, '9', 'tersedia', NULL, 244, NULL),
(2270, '10', 'tersedia', NULL, 244, NULL),
(2271, '1', 'tersedia', NULL, 245, NULL),
(2272, '2', 'tersedia', NULL, 245, NULL),
(2273, '3', 'tersedia', NULL, 245, NULL),
(2274, '4', 'tersedia', NULL, 245, NULL),
(2275, '5', 'tersedia', NULL, 245, NULL),
(2276, '6', 'tersedia', NULL, 245, NULL),
(2277, '7', 'tersedia', NULL, 245, NULL),
(2278, '8', 'tersedia', NULL, 245, NULL),
(2279, '9', 'tersedia', NULL, 245, NULL),
(2280, '10', 'tersedia', NULL, 245, NULL),
(2281, '1', 'tersedia', NULL, 246, NULL),
(2282, '2', 'tersedia', NULL, 246, NULL),
(2283, '3', 'tersedia', NULL, 246, NULL),
(2284, '4', 'tersedia', NULL, 246, NULL),
(2285, '5', 'tersedia', NULL, 246, NULL),
(2286, '6', 'tersedia', NULL, 246, NULL),
(2287, '7', 'tersedia', NULL, 246, NULL),
(2288, '8', 'tersedia', NULL, 246, NULL),
(2289, '9', 'tersedia', NULL, 246, NULL),
(2290, '10', 'tersedia', NULL, 246, NULL),
(2291, '1', 'tersedia', NULL, 247, NULL),
(2292, '2', 'tersedia', NULL, 247, NULL),
(2293, '3', 'tersedia', NULL, 247, NULL),
(2294, '4', 'tersedia', NULL, 247, NULL),
(2295, '5', 'tersedia', NULL, 247, NULL),
(2296, '6', 'tersedia', NULL, 247, NULL),
(2297, '7', 'tersedia', NULL, 247, NULL),
(2298, '8', 'tersedia', NULL, 247, NULL),
(2299, '9', 'tersedia', NULL, 247, NULL),
(2300, '10', 'tersedia', NULL, 247, NULL);

--
-- Triggers `kursi`
--
DELIMITER $$
CREATE TRIGGER `trg_before_delete_kursi` BEFORE DELETE ON `kursi` FOR EACH ROW BEGIN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Tidak diizinkan menghapus data dari tabel "kursi".';
END
$$
DELIMITER ;

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
(67, '56789203435', 'Nuri Hidayatuloh', '098102984230', 'asdan@gmail.com', '23500.00', '2023-05-23'),
(68, '0995847547656897', 'Yohan Permanen', '09876546789', 'xyz@gmail.com', '10000.00', '2023-05-26'),
(69, '0995847547656897', 'Yohan Permanen', '09876546789', 'xyz@gmail.com', '10000.00', '2023-05-26'),
(70, '0995847547656897', 'Yohan Permanen', '09876546789', 'xyz@gmail.com', '10000.00', '2023-05-26'),
(71, '3545674', 'Machrus', '08087340', 'hdytlh@gmail.com', '10000.00', '2023-05-26'),
(72, '3497349', 'idfheiu', '29347', 'sdfhw', '10000.00', '2023-05-26'),
(76, '1987198719871987', 'Yuli Sumpil', '081119871987', 'sumpil@gmail.com', '29000.00', '2023-05-26'),
(77, '1910191892345678', 'vhbjn', '089786765', 'jhgvsd@', '25000.00', '2023-06-08'),
(78, '0995847547656897', 'drtfyguh', '09867546456', 'hgfdter@', '25000.00', '2023-06-08'),
(79, '1111111111111111', 'kjhvgcdhsdf', '097968546758', 'jbhgvgfc@', '44000.00', '2023-06-08'),
(80, '1111111111111111', 'Nuri', '099349247629', 'nuriiii@', '25000.00', '2023-06-08'),
(81, '0995847547656897', 'Nurhiee', '098675678', 'nhhsdgf@', '25000.00', '2023-06-08');

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
(64, 'Yogyakarta - Stasiun Tugu', 53);

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
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=65;

--
-- AUTO_INCREMENT for table `gerbong`
--
ALTER TABLE `gerbong`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=248;

--
-- AUTO_INCREMENT for table `kereta`
--
ALTER TABLE `kereta`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=54;

--
-- AUTO_INCREMENT for table `kursi`
--
ALTER TABLE `kursi`
  MODIFY `id` int(255) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2301;

--
-- AUTO_INCREMENT for table `pelanggan`
--
ALTER TABLE `pelanggan`
  MODIFY `id_pelanggan` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=82;

--
-- AUTO_INCREMENT for table `tujuan`
--
ALTER TABLE `tujuan`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=65;

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
