<?php
session_start();
$no_telp = $_POST['no_telp'];
$email = $_POST['email'];

if (isset($_POST['simpan'])) {
    $database = mysqli_connect("localhost", "root", "", "pa_smbd4c");

    // Memanggil stored procedure
    $result = mysqli_query($database, "CALL UpdateContact('$no_telp', '$email')");

    // Menampilkan pesan dari stored procedure
    $row = mysqli_fetch_assoc($result);
    echo "<script>alert('" . $row['message'] . "'); window.location.href='../pengaturan.php';</script>";
} elseif (isset($_POST['batal'])) {
    echo "<script>window.location.href='../adminhome.php';</script>";
}

mysqli_close($database);
?>
