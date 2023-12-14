<?php
	$database = mysqli_connect("localhost","root","","pa_smbd4c");
	$get_data = mysqli_query($database,"SELECT * FROM view_kereta_asal_tujuan");
	mysqli_close($database);
?>