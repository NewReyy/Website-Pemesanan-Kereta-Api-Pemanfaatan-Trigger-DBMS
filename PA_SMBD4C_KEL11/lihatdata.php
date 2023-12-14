<?php
	include("proses/cek_sesi.php");
	include("proses/get_data.php");
?>
<!DOCTYPE html>
<html>
	<head>
		<title>SIKAT:Data Kereta</title>
		<link rel="icon" type="image/png" href="images/iconnya.png">
		<link rel="stylesheet" type="text/css" href="css/style2.css">
	</head>
		<body>
			<aside>
				<a href="proses/logout.php">
					<img src="images/logout.png">
					<h5>Logout</h5>	
				</a>
			</aside>
				<header>
					<h1>SIKAT</h1>
					<h5>Sistem Informasi Kereta Api Terbaik</h5>
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
				<d>
					<h3 style="margin-left: 45%;font-family: Arial;">Daftar Jadwal Kereta</h3>
					<table border="0" class="fontdt">
						<th>No</th>
						<th id="tabeldt">Nama Kereta</th>
						<th>Kelas</th>
						<th>Asal</th>
						<th>Tujuan</th>
						<th>Tanggal</th>
						<th>Jam Berangkat</th>
						<th>Jam Tiba</th>
						<th>Status</th>
						<th>Aksi</th>
							<?php
							$no = 1;
								while ($data = mysqli_fetch_array($get_data)) {
									$tanggal = date("d-m-Y", strtotime($data['tanggal']));
									echo "<tr>";
									echo "<td>".$no++."</td>";
									echo "<td>".$data['nama_kereta']."</td>";
									echo "<td>".$data['kelas']."</td>";
									echo "<td>".$data['nama_asal']."</td>";
									echo "<td>".$data['nama_tujuan']."</td>";
									echo "<td>$tanggal</td>";
									echo "<td style='text-align: center;'>".$data['jam_berangkat']."</td>";
									echo "<td style='text-align: center;'>".$data['jam_tiba']."</td>";
									echo "<td><a href='proses/update_status.php?id=".$data['id']."' style='color: blue; text-decoration: none;'>".$data['status']."</a></td>";
									echo "<td>
										<a id ='lhtart' href='proses/hapus_data.php?id=".$data['id']."'>Hapus</a>
										<a id ='lhtart' href='lihatkursi.php?id=".$data['id']."'>Kursi</a>
										</td>";
									echo "</tr>";
								}
							?>

					</table>
				</div>
				<p>*Note : Ketika Kereta berangkat, klik pada status kereta yang berada pada kolom status untuk mengubah statusnya menjadi Berangkat.</p>
					<footer>
						Copyright &copy 2023 by 210441100100 dan 210441100020
					</footer>
		</body>
</html>
