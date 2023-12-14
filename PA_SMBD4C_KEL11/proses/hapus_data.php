<?php
session_start();
	$id = $_GET['id'];
	$database = mysqli_connect("localhost","root","","pa_smbd4c");
	$result = mysqli_query($database,"CALL DelKereta('$id')");
	if ($result) {
		echo "<script>alert('Data Kereta berhasil dihapus!');window.location.href='../lihatdata.php';</script>";
	}
	else {
		echo "<script>alert('Data Kereta Tidak Bisa Dihapus!');window.location.href='../lihatdata.php';</script>";
	}
	mysqli_close($database);
?>