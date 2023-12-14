<?php
session_start();
	$id = $_GET['id'];
	$database = mysqli_connect("localhost","root","","pa_smbd4c");
	$result = mysqli_query($database,"CALL delete_kursi('$id')");
	if ($result) {
		echo "<script>alert('Data Customer di Kursi ini berhasil dihapus dan menjadi Tersedia kembali!');window.location.href='../lihatdata.php';</script>";
	}
	else {
		echo "<script>alert('Data Customer Tidak Bisa Dihapus!');window.location.href='../lihatdata.php';</script>";
	}
	mysqli_close($database);
?>