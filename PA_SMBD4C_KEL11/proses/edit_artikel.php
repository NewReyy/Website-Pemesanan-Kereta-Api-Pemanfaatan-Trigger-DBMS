<?php
session_start();
	$judul = $_POST['judul'];
	$isi = $_POST['isi'];
	$id = $_POST['id'];
	if(isset($_POST['simpan'])){
		$database = mysqli_connect("localhost","root","","pa_smbd4c");
		mysqli_query($database,"UPDATE ARTIKEL SET judul ='$judul', isi = '$isi' WHERE id =$id");	
		echo "<script>alert('Artikel berhasil disimpan');window.location.href='../lihatartikel.php';</script>";
	}elseif(isset($_POST['batal'])){
		echo "<script>window.location.href='../adminhome.php';</script>";
	}
	mysqli_close($database);
?>