<?php
	$database = mysqli_connect("localhost","root","","pa_smbd4c");
	$get_data_pelanggan = mysqli_query($database,"SELECT * FROM view_pelanggan;");
	mysqli_close($database);
?>