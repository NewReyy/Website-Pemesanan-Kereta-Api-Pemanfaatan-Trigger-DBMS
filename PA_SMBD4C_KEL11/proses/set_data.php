<?php
session_start();
$nama = $_POST['namakereta'];
$kelas = $_POST['kelas'];
$asal = $_POST['asal'];
$tujuan = $_POST['tujuan'];
$jambr = $_POST['jam1'];
$jamtb = $_POST['jam2'];
$tarif_d = $_POST['tarif_d'];
$tarif_a = $_POST['tarif_a'];
$tanggal = $_POST['tanggal'];
$bulan = $_POST['bulan'];
$tahun = $_POST['tahun'];
$posG = array('A','B','C','D','E');
$posKursi = 1;
$database = mysqli_connect("localhost", "root", "", "pa_smbd4c");

if (!$database) {
    die("Koneksi database gagal: " . mysqli_connect_error());
}

if ($asal != $tujuan) {
    // Memanggil prosedur TambahKereta
    $query = "CALL TambahKereta(NULL, '$nama', '$kelas', '$tahun-$bulan-$tanggal', '$jambr', '$jamtb', $tarif_d, $tarif_a, 'Belum berangkat')";
    $result = mysqli_query($database, $query);
}

if ($result) {
    // Mendapatkan ID kereta yang baru ditambahkan
    $query = "SELECT MAX(id) AS new_train_id FROM kereta";
    $result = mysqli_query($database, $query);

    if ($result && mysqli_num_rows($result) > 0) {
        $row = mysqli_fetch_assoc($result);
        $newTrainId = $row['new_train_id'];

        // Menyimpan data asal
        mysqli_query($database, "INSERT INTO asal VALUES(NULL, '$asal', '$newTrainId')");

        // Menyimpan data tujuan
        mysqli_query($database, "INSERT INTO tujuan VALUES(NULL, '$tujuan', '$newTrainId')");

        // Menyimpan data gerbong dan kursi
        mysqli_query($database, "CALL insert_gerbong_kursi('$newTrainId')");

        echo "<script>alert('Data berhasil disimpan!');window.location.href='../lihatdata.php';</script>";
    } else {
        echo "<script>alert('Gagal mendapatkan ID kereta baru.');window.location.href='../ubahdata.php';</script>";
    }
} else {
    echo "<script>alert('Gagal menambahkan data kereta.');window.location.href='../ubahdata.php';</script>";
}

mysqli_close($database);
?>
