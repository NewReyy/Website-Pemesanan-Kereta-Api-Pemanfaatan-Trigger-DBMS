<!-- <!DOCTYPE html>
<html lang="en">
<head>
	<link rel="stylesheet" type="text/css" href="css/style2.css">
</head>
<body>
	
</body>
</html> -->
<?php
	$database = mysqli_connect("localhost","root","","pa_smbd4c");
	$id=$_GET['id'];
	$idg;
	$query = mysqli_query($database,"SELECT * FROM GERBONG WHERE id_kereta='$id'");
	while ($data = mysqli_fetch_array($query)){
		$idg = $data['id'];
		echo "<table border='0' class='fontdt' align='left' style='background-color: rgba(250, 250, 250,1);'>";		
		echo "<th id='jd'> Gerbong : ".$data['posisi_gerbong']."<br>No Kursi</th>
		          <th id='jd'>Status</th>";	
		$query2 = mysqli_query($database,"SELECT * FROM KURSI WHERE id_gerbong='$idg'");
		while ($data2 = mysqli_fetch_array($query2)) {
			echo "<tr><td style='text-align: center;'>".$data2['posisi_kursi']."</td>";
			if($data2['status']=='booked'){
				echo "<td style='color: red;'>".$data2['status']."</td></tr>";
			}else{
				echo "<td>".$data2['status']."</td></tr>";
			}
				      
		}
		echo "</table>";	
	}
?>