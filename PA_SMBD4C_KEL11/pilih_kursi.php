<!DOCTYPE html>
	<html>
		<head>
			<title>Pilih Kursi : SIKAT</title>
			<link rel="icon" type="image/png" href="images/iconnya.png">
			<link rel="stylesheet" type="text/css" href="css/style3.css">
			<link rel="stylesheet" type="text/css" href="css/style.css">
			<script type="text/javascript" src="scripts/jquery-1.12.2.js"></script>
			<script type="text/javascript" src="scripts/main.js"></script>
			<body>				
			<div id="wrapper">				
				<header style="margin-top:1px">	
				<a href="index.php">			
					<img src="images/iconnya.png"></a>					
					<nav>
							<ul>
							<br>
								<li><a>Isi Data Pemesan</a></li>
								<li><a  class="active">Pilih Kursi</a></li>
								<li><a>Review</a></li>
							</ul>
						</nav>
				</header>						
						
						
				<article class="hasil">
						<center>
						<?php
							include('proses/batas.php');
							$database = mysqli_connect("localhost","root","","pa_smbd4c");
							$id=$_GET['id'];
							$anak = $_GET['ank'];
							$dewasa = $_GET['dws'];
							$batas = $anak+$dewasa;							
							$kd_booking = $_GET['kdb'];
							$id_pelanggan = $_GET['idplg'];
							$query = mysqli_query($database,"SELECT * FROM GERBONG WHERE id_kereta='$id'");
							
							
							while ($data = mysqli_fetch_array($query)){
								$idg = $data['id'];
								echo "<table id='tbk' align='left' style='background-color: rgba(250, 250, 250,1);'>";		
								echo "<th id='jd'> Gerbong : ".$data['posisi_gerbong']."<br>No Kursi</th>
								          <th id='jd'>Status</th>
								          <th id='jd'>Aksi</th>";	
								$query2 = mysqli_query($database,"SELECT * FROM KURSI WHERE id_gerbong='$idg'");

								while ($data2 = mysqli_fetch_array($query2)) {
									echo "<tr><td id='tbkisi' style='text-align: center;'>".$data2['posisi_kursi']."</td>";
									if($data2['status']=='booked'){
										echo "<td id='tbkisi' style='background-color: yellow;'>".$data2['status']."</td>";
									}else{
										echo "<td id='tbkisi'>".$data2['status']."</td>";
									}										    
										      $idkursi = $data2['id'];
										      if($data2['status']=='tersedia'){
										      if(isset($_GET['p'])){
										      	$set->setBatas($_GET['p']);	
										      }
										      	if($set->getBatas()<=$batas){	
										      		$send = $set->getBatas();
										      		echo "<td><a style='font-size: 10.5pt; text-decoration: none;color: blue;' href='proses/update_kursi.php?s=booking&idkrt=$id&ank=$anak&dws=$dewasa&kdb=$kd_booking&idp=$id_pelanggan&idKrs=$idkursi&p=$send'><button type='buttons' id='tbbooking'>Booking</button></a></td>";
										      	}else{
										      	echo "<td><span id='tbkbeda' style='font-size: 10.5pt;'>Booking</span>";
										      	}
										      }else{
										      	if($data2['kd_booking']==$kd_booking){
										      	$getV = $_GET['p'];
										      	$set->setBatas($getV);
										      	$send = $set->getBatas();
										      	echo "<td><a style='text-decoration: none;' href='proses/update_kursi.php?s=batal&idkrt=$id&ank=$anak&dws=$dewasa&kdb=$kd_booking&idp=$id_pelanggan&idKrs=$idkursi&p=$send'><button type='button' id='tbkbatal'>batal</button></a></td>";
										      	}
										      }
									
									echo "</tr>";
								}
								echo "</table>";

							}
							echo "<a href='review.php?idplg=$id_pelanggan&ank=$anak&dws=$dewasa'><button id='tbklanjut' type='submit' name='lanjutkan'>Lanjutkan</button></a>";
						?>

						</center>
				</article>	
			</div>		
			<footer>
				<div id="kontak_us">
				<?php
					$query = mysqli_query($database,"SELECT * FROM KONTAK_US");
					$data = mysqli_fetch_array($query);
					echo "<h3 style='margin-left: 83%; padding-top: 8px;'> Contact Us </h3>";
					echo "<img style='width: 15px; height: 15px;margin-left: 66.5%;' src='images/telpon.png'>";
					echo "<h5 style='display: inline;margin-left: 85%;'>".$data['no_telp']."</h5><br>";
					echo "<img style='width: 15px; height: 13px;margin-left: 66.5%; margin-top: 4px;' src='images/email.png'>";
					echo "<h5 style='display: inline;margin-left: 85%;'>".$data['email']."</h5>";
					mysqli_close($database);

				?>
				</div>
				<hr width="500px" color="white">
				Copyright &copy 2023 by 210441100100 dan 210441100020
				<marquee style="position: relative;">SIKAT : Sistem Informasi Kereta Api Terbaik</marquee>
			</footer>
			</body>
</html>
