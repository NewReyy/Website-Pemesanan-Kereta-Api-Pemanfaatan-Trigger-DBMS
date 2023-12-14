<?php
	include("proses/cek_sesi.php");
	include("proses/get_data_pelanggan.php");
?>
<!DOCTYPE html>
<html>
	<head>
		<title>SIKAT:Data Pelanggan</title>
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
				<li><a href="lihatdata.php">Lihat Data</a></li>
				<li><a href="lihatartikel.php">Daftar Artikel</a></li>
                <li class="active"><a href="lihatpelanggan.php">Daftar Pelanggan</a></li>
				<li><a href="pengaturan.php">Pengaturan</a></li>
			</ul>
		</nav>
		<div>
			<h3 style="margin-left: 45%;font-family: Arial;">Log Daftar Pelanggan</h3>
			<table border="0" class="fontdt">
				<th>No</th>
				<th>Nama Pelanggan</th>
				<th>No. Telepon</th>
				<th>Posisi Gerbong</th>
				<th>Nama Kereta</th>
				<th>Kelas</th>
				<th>Tanggal</th>
				<th>Jam Berangkat</th>
				<th>Jam Tiba</th>
				<th>Status Kereta</th>
				<th>Asal</th>
				<th>Tujuan</th>
                <th>Aksi</th>
				<?php
                    error_reporting(0);
					$no = 1;
					while ($data = mysqli_fetch_array($get_data_pelanggan)) {
						$tanggal = date("d-m-Y", strtotime($data['tanggal']));
						echo "<tr>";
						echo "<td>".$no++."</td>";
						echo "<td>".$data['nama_pelanggan']."</td>";
						echo "<td>".$data['no_telp']."</td>";
						echo "<td>".$data['posisi_gerbong']."</td>";
						echo "<td>".$data['nama_kereta']."</td>";
						echo "<td>".$data['kelas']."</td>";
						echo "<td>".$tanggal."</td>";
						echo "<td>".$data['jam_berangkat']."</td>";
						echo "<td>".$data['jam_tiba']."</td>";
						echo "<td>".$data['status_kereta']."</td>";
						echo "<td>".$data['nama_asal']."</td>";
						echo "<td>".$data['nama_tujuan']."</td>";
                        echo "<td><a id ='lhtart' href='proses/hapuspelanggan.php?id=".$data['id_pelanggan']."'>Hapus</a></td>";
						echo "</tr>";
					}
				?>
			</table>
		</div>
		<footer>
			Copyright &copy 2023 by 210441100100 dan 210441100020
		</footer>
	</body>
</html>
