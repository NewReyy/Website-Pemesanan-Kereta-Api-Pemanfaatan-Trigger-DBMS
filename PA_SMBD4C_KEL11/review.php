<?php
	include('proses/proses_review.php');
?>

<!DOCTYPE html>
	<html>
		<head>
			<title>Review Tiket : SIKAT</title>
			<link rel="icon" type="image/png" href="images/iconnya.png">
			<link rel="stylesheet" type="text/css" href="css/style3.css">
			<link rel="stylesheet" type="text/css" href="css/style.css">
			<script type="text/javascript" src="scripts/jquery-1.12.2.js"></script>
			<script type="text/javascript" src="scripts/main.js"></script>
			
		</head>
			<body>				
			<div id="wrapper">				
				<header style="margin-top:1px">	
				<a href="index.php">			
					<img src="images/iconnya.png"></a>					
					<nav>
							<ul>
							<br>
								<li><a>Isi Data Pemesan</a></li>
								<li><a>Pilih Kursi</a></li>
								<li><a class="active">Review</a></li>
							</ul>
						</nav>
				</header>						
						
				<article class="hasilreview">
						<center>
						<?php
						$data = mysqli_fetch_array($query);
						$anak = $_GET['ank'];
						$dewasa = $_GET['dws'];
						$data3 = mysqli_fetch_array($query4);
							echo"<h3 id='jdreview'>Ringkasan Data</h3>";
							echo "<table id='tbr'>";
							echo "<tr id='trreview'>";
							echo "<td id='tbrjudul'>Nama</td>";
							echo "<td id='tbrisi'>".$data['nama_pelanggan']."</td>";
							echo "</tr>";
							echo "<tr id='trreview'>";
							echo "<td id='tbrjudul'>No KTP</td>";
							echo "<td id='tbrisi'>".$data['no_ktp']."</td>";
							echo "</tr>";
							echo "<tr id='trreview'>";
							echo "<td id='tbrjudul'>No Telp/HP</td>";
							echo "<td id='tbrisi'>".$data['no_telp']."</td>";
							echo "</tr>";
							echo "<tr id='trreview'>";
							echo "<td id='tbrjudul'>Email</td>";
							echo "<td id='tbrisi'>".$data['email']."</td>";
							echo "</tr>";
							echo "<tr id='trreview'>";
							$tanggal = date("d-m-Y", strtotime($data['tgl_pemesanan']));
							echo "<td id='tbrjudul'>Tanggal Pemesanan</td>";
							echo "<td id='tbrisi'>$tanggal</td>";
							echo "</tr>";
							echo "<tr id='trreview'>
							         <td id='tbrjudul'>Ket. Penumpang</td>
							         <td id='tbrisi'>Dewasa : $dewasa | Anak : $anak</td>
							         </tr>";
							echo "<tr id='trreview'>";
							echo "<td id='tbrjudul'>Nama Kereta</td>";
							echo "<td id='tbrisi'>".$data3['nama_kereta']."</td>";
							echo "</tr>";
							echo "<tr id='trreview'>";
							echo "<td id='tbrjudul'>Asal</td>";
							echo "<td id='tbrisi'>".$data3['nama_asal']."</td>";
							echo "</tr>";
							echo "<tr id='trreview'>";
							echo "<td id='tbrjudul'>Tujuan</td>";
							echo "<td id='tbrisi'>".$data3['nama_tujuan']."</td>";
							echo "</tr>";
							echo "<tr id='trreview'>";
							echo "<td id='tbrjudul'>Kelas</td>";
							echo "<td id='tbrisi'>".$data3['kelas']."</td>";
							echo "</tr>";
							echo "<tr id='trreview'>";
							$tanggalbr = date("d-m-Y", strtotime($data3['tanggal']));
							echo "<td id='tbrjudul'>Tanggal Keberangkatan</td>";
							echo "<td id='tbrisi'>$tanggalbr</td>";
							echo "</tr>";
							echo "<tr id='trreview'>";
							echo "<td id='tbrjudul'>Jam Berangkat</td>";
							echo "<td id='tbrisi'>".$data3['jam_berangkat']."</td>";
							echo "</tr>";
							echo "<tr id='trreview'>";
							echo "<td id='tbrjudul'>Jam Tiba</td>";
							echo "<td id='tbrisi'>".$data3['jam_tiba']."</td>";
							echo "</tr>";
							echo "<tr id='trreview'>";
							echo "<td id='tbrjudul'>Gerbong-No Kursi</td>";
							echo "<td id='tbrisi'>";
							$query2 = mysqli_query($database,"SELECT * FROM KURSI WHERE id_pelanggan=$id");
							while ($data1 = mysqli_fetch_array($query2)) {
								$id_gerbong = $data1['id_gerbong'];
								$query3 = mysqli_query($database,"SELECT * FROM GERBONG WHERE id=$id_gerbong");
								$data2 = mysqli_fetch_array($query3);
								echo  " | ".$data2['posisi_gerbong']."-".$data1['posisi_kursi']." | ";
							}
							echo "</td>";
							echo "</tr>";
							$query2 = mysqli_query($database,"SELECT * FROM KURSI WHERE id_pelanggan=$id");
							$data2 = mysqli_fetch_array($query2);							
							echo "<tr id='trreview'>
								  <td id='tbrjudul'>Total Pembayaran</td>
								  <td id='tbrisi'>Rp ".number_format($data['total_pembayaran'],"2",",",".")."
								  </tr>";
							echo "<tr id='trreview'>
								  <td id='tbrjudul'>Kode Booking</td>
								  <td id='tbrisi'>".$data2['kd_booking']."</td>
								  </tr>";
							echo "</table>";

							echo "<a href='javascript:window.print()'><button type='button' id='download'>Cetak</button></a>";
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
