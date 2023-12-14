<?php
session_start();
if(!isset($_SESSION['admin'])){
	echo "<script> alert('Silahkan Login terlebih dahulu!');
	window.location.href = 'index.php' </script>";
}
?>