<?php
session_start();
	$id = $_GET['id'];
	$database = mysqli_connect("localhost","root","","pa_smbd4c");
	mysqli_query($database,"UPDATE KERETA SET status='Berangkat' WHERE id=$id");
	echo "<script>window.location.href='../lihatdata.php';</script>";
	mysqli_close($database);
?>