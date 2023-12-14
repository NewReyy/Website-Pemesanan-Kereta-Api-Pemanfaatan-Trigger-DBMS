<?php
session_start();
	$id = $_GET['id'];
	$database = mysqli_connect("localhost","root","","pa_smbd4c");
	$result = mysqli_query($database,"CALL delete_pelanggan('$id')");
	if ($result) {
		echo "<script>alert('Data Pelanggan berhasil dihapus!');window.location.href='../lihatpelanggan.php';</script>";
	}
	else {
		echo "<script>alert('Data Pelanggan Tidak Bisa Dihapus!');window.location.href='../lihatpelanggan.php';</script>";
	}
	mysqli_close($database);
?>