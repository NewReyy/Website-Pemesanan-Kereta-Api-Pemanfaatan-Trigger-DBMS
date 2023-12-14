<!DOCTYPE html>
	<html>
		<head>
			<title>Pilih Kursi : SIKAT</title>
			<link rel="icon" type="image/png" href="images/iconnya.png">
			<!-- <link rel="stylesheet" type="text/css" href="css/style3.css"> -->
			<!-- <link rel="stylesheet" type="text/css" href="css/style.css"> -->
            <link rel="stylesheet" type="text/css" href="css/style2.css">
			<script type="text/javascript" src="scripts/jquery-1.12.2.js"></script>
			<script type="text/javascript" src="scripts/main.js"></script>
			<body>										
					
				</header>
						<nav class="lhd">
							<ul>
								<li><a href="adminhome.php">Beranda</a></li>
								<li><a href="suntingartikel.php">Sunting Artikel</a></li>
								<li><a href="ubahdata.php">Ubah Data</a></li>
								<li class="active"><a class="active" href="lihatdata.php">Lihat Data</a></li>
								<li><a href="lihatartikel.php">Daftar Artikel</a></li>
								<li><a href="lihatpelanggan.php">Lihat Pelanggan</a></li>
								<li><a href="pengaturan.php">Pengaturan</a></li>
							</ul>
						</nav>
				<article class="hasil">
						<center>
						<?php
							include('proses/batas.php');
							$database = mysqli_connect("localhost","root","","pa_smbd4c");
							$id=$_GET['id'];
                            $batas=1;
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
                                        echo"<td>
                                                <a id ='lhtart' href='proses/hapus_pelanggan.php?id=".$data2['id']."'>Hapus Customer</a>
                                            </td>";
									}else{
										echo "<td id='tbkisi'>".$data2['status']."</td>";
									}										    
										      $idkursi = $data2['id'];
										      if($data2['status']=='tersedia'){
										      	if($set->getBatas()<=$batas){	
										      		$send = $set->getBatas();
										      		echo"<td>
                                                            <a id ='lhtart' href='proses/hapus_pelanggan.php?id=".$data2['id']."'>Hapus Customer</a>
                                                        </td>";
										      	}else{
										      	echo "<td><span id='tbkbeda' style='font-size: 10.5pt;'>Booking</span>";
										      	}
										      }
									
									echo "</tr>";
								}
								echo "</table>";

							}
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
