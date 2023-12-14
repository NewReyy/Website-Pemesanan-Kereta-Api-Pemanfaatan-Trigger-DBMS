<?php
	$database = mysqli_connect("localhost","root","","pa_smbd4c");
	$get_judul = mysqli_query($database,"SELECT * FROM view_artikel_id_desc;");
	mysqli_close($database);
?>