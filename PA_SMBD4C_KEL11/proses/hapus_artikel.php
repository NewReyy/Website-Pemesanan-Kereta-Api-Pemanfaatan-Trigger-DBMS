<?php
session_start();
$id = $_GET['id'];
$database = mysqli_connect("localhost","root","","pa_smbd4c");
mysqli_query($database,"CALL DelArtikel('$id')");
echo "<script>alert('Artikel berhasil dihapus');window.location.href='../lihatartikel.php';</script>";
mysqli_close($database);
?>