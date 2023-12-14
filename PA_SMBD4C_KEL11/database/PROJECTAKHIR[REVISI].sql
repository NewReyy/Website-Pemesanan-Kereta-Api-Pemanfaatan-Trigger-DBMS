-- STORED PROCEDURE 

#SP UNTUK MENGHAPUS DATA ARTIKEL
DELIMITER $$
CREATE PROCEDURE `DelArtikel`(IN `ida` INT(100))
BEGIN
	DELETE FROM artikel WHERE id = ida;
END$$
DELIMITER ;

#SP UNTUK MENGHAPUS DATA KERETA
DELIMITER $$
CREATE PROCEDURE `DelKereta`(IN `idk` INT(100))
BEGIN
	DELETE FROM kereta WHERE id = idk;
END$$
DELIMITER ;

#SP UNTUK MENAMBAHKAN ARTIKEL
DELIMITER $$
CREATE PROCEDURE `InsertArtikel`(IN `id` INT(100), IN `$judul` VARCHAR(255), IN `$isi` TEXT)
BEGIN
    INSERT INTO artikel VALUES(NULL, $judul, $isi, CURDATE());
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE `TambahKereta`(IN `id` INT(100), IN `nama_kereta` VARCHAR(400), IN `kelas` VARCHAR(50), IN `tanggal` DATE, IN `jam_berangkat` VARCHAR(5), IN `jam_tiba` VARCHAR(5), IN `tarif_dewasa` DECIMAL(22,2), IN `tarif_anak` DECIMAL(22,2), IN `status` VARCHAR(50))
BEGIN
    INSERT INTO kereta (id, nama_kereta, kelas, tanggal, jam_berangkat, jam_tiba, tarif_dewasa, tarif_anak, status)
    VALUES (id, nama_kereta, kelas, tanggal, jam_berangkat, jam_tiba, tarif_dewasa, tarif_anak, status);
END$$
DELIMITER ;

#SP UNTUK MENGUPDATE KONTAK
DELIMITER $$
CREATE PROCEDURE `UpdateContact`(IN p_no_telp VARCHAR(255), IN p_email VARCHAR(255))
BEGIN
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
DELIMITER ;

#SP UNTUK MENGHAPUS DATA PELANGGAN
DELIMITER $$
CREATE PROCEDURE `delete_pelanggan`(IN `pelanggan_id` INT(100))
BEGIN
  DELETE FROM pelanggan WHERE id_pelanggan = pelanggan_id;
END$$
DELIMITER ;

#SP UNTUK MENAMBAHKAN SECARA OTOMATIS BANYAK MENGGUNAKAN SP BRANCHING SESUAI DENGAN KEBUTUHAN
DELIMITER $$
CREATE PROCEDURE `insert_gerbong_kursi`(IN `newTrainId` INT(100))
BEGIN
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
DELIMITER ;

#SP UNTUK MENGUPDATE PASSWORD ADMIN
DELIMITER $$
CREATE PROCEDURE `update_pass`(IN `admin_id` INT(100), IN `old_password` VARCHAR(255), IN `new_password` VARCHAR(255))
BEGIN
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

DELIMITER $$
CREATE PROCEDURE `delete_kursi`(IN `kursi_id` INT(100))
BEGIN
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
DELIMITER ;

-- ----------------------------------VIEWS----------------------------------
CREATE VIEW artikel_view AS
SELECT *
FROM ARTIKEL;

CREATE VIEW view_artikel_id_desc AS
SELECT *
FROM ARTIKEL
ORDER BY id DESC;

CREATE VIEW pelanggan_view AS
SELECT *
FROM pelanggan
WHERE id_pelanggan = LAST_INSERT_ID() AND DATE(tgl_pemesanan) = CURDATE()
ORDER BY id_pelanggan DESC;

CREATE VIEW view_kereta_asal_tujuan AS
SELECT k.*, a.nama_asal, t.nama_tujuan
FROM KERETA k
JOIN ASAL a ON k.id = a.id_kereta
JOIN TUJUAN t ON a.id_kereta = t.id_kereta
ORDER BY id DESC;

CREATE VIEW view_pelanggan AS
SELECT p.id_pelanggan, p.nama_pelanggan, p.email, p.no_telp,
	k.id AS kursi_id, k.status AS status_kursi, g.id AS gerbong_id, 
	g.posisi_gerbong, kr.id AS kereta_id, kr.nama_kereta, kr.kelas,
    kr.tanggal, kr.jam_berangkat, kr.jam_tiba, kr.tarif_dewasa,
    kr.tarif_anak, kr.status AS status_kereta, a.nama_asal, t.nama_tujuan
FROM pelanggan p
JOIN kursi k ON p.id_pelanggan = k.id_pelanggan
JOIN gerbong g ON k.id_gerbong = g.id
JOIN kereta kr ON g.id_kereta = kr.id
JOIN asal a ON kr.id = a.id_kereta
JOIN tujuan t ON t.id_kereta = a.id_kereta;

-- ----------------------------------TRIGGERS----------------------------------
DELIMITER //
CREATE TRIGGER `KONTAK` BEFORE UPDATE ON `kontak_us`
 FOR EACH ROW BEGIN
SET NEW.email = LOWER(NEW.email);
END //

DELIMITER //
CREATE TRIGGER `after_delete_kereta` AFTER DELETE ON `kereta`
 FOR EACH ROW BEGIN
    -- Hapus data terkait di tabel asal
    DELETE FROM asal WHERE id_kereta = OLD.id;

    -- Hapus data terkait di tabel tujuan
    DELETE FROM tujuan WHERE id_kereta = OLD.id;
END //

DELIMITER //
CREATE TRIGGER `after_update_admin_password` AFTER UPDATE ON `admin`
 FOR EACH ROW BEGIN
    -- Cek apakah kolom password diupdate
    IF NEW.password = OLD.password THEN
        -- Menampilkan pesan setelah password diupdate
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Password admin tidak berhasil diperbarui.';
    END IF;
END //

DELIMITER //
CREATE TRIGGER `cek_status_belum_berangkat` BEFORE DELETE ON `kereta`
 FOR EACH ROW BEGIN
    IF OLD.status = 'Belum berangkat' THEN
        SIGNAL SQLSTATE '45000' 
            SET MESSAGE_TEXT = 'Tidak dapat menghapus data dari Tabel Kereta. Status masih "Belum berangkat".';
    END IF;
END //

DELIMITER //
CREATE TRIGGER `cek_waktu_sekarang` BEFORE INSERT ON `kereta`
 FOR EACH ROW BEGIN
    DECLARE waktu_sekarang TIMESTAMP;
    SET waktu_sekarang = NOW();
    
    IF NEW.tanggal < DATE(waktu_sekarang) OR (NEW.tanggal = DATE(waktu_sekarang) AND NEW.jam_berangkat < TIME(waktu_sekarang)) THEN
        SIGNAL SQLSTATE '45000' 
            SET MESSAGE_TEXT = 'Tidak dapat menambahkan ke dalam Tabel Kereta. Tanggal dan jam harus di atas atau sama dengan waktu saat ini.';
    END IF;
END //

DELIMITER //
CREATE TRIGGER `trg_before_delete_gerbong` BEFORE DELETE ON `gerbong`
 FOR EACH ROW BEGIN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Tidak diizinkan menghapus data dari tabel "gerbong".';
END //

DELIMITER //
CREATE TRIGGER `trg_before_delete_kursi` BEFORE DELETE ON `kursi`
 FOR EACH ROW BEGIN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Tidak diizinkan menghapus data dari tabel "kursi".';
END //

