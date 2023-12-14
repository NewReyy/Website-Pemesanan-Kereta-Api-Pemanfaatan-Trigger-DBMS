<?php
include('batas.php');
	session_start();	
	$aksi = $_GET['s'];
	$kd_booking = $_GET['kdb'];
	$id_pelanggan = $_GET['idp'];
	$id_kursi = $_GET['idKrs'];
	$idkereta = $_GET['idkrt'];
	$anak = $_GET['ank'];
	$dewasa = $_GET['dws'];
	$database = mysqli_connect("localhost","root","","pa_smbd4c");
	$getV = $_GET['p'];
	if($aksi=='booking'){
		$set->setBatas($getV);
		$set->batasp();
		$send = $set->getBatas();
		mysqli_query($database,"UPDATE KURSI SET status='booked',kd_booking='$kd_booking',id_pelanggan=$id_pelanggan WHERE id=$id_kursi");
		echo "<script>window.location.href='../pilih_kursi.php?id=$idkereta&ank=$anak&dws=$dewasa&idplg=$id_pelanggan&kdb=$kd_booking&p=$send';</script>";
	}elseif($aksi=='batal'){
		$set->setBatas($getV);
		$set->batask();
		$send = $set->getBatas();
		mysqli_query($database,"UPDATE KURSI SET status='tersedia',kd_booking=NULL,id_pelanggan=NULL WHERE id=$id_kursi");
		echo "<script>window.location.href='../pilih_kursi.php?id=$idkereta&ank=$anak&dws=$dewasa&idplg=$id_pelanggan&kdb=$kd_booking&p=$send';</script>";
	}
	mysqli_close($database);
?>