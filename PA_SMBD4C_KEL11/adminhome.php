<?php
	include("proses/cek_sesi.php");
?>
<!DOCTYPE html>
<html>
	<head>
		<title>SIKAT:Home Admin</title>
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
						<nav>
							<ul>
								<li class="active"><a class="active" href="adminhome.php">Beranda</a></li>
								<li><a href="suntingartikel.php">Sunting Artikel</a></li>
								<li><a href="ubahdata.php">Ubah Data</a></li>
								<li><a href="lihatdata.php">Lihat Data</a></li>
								<li><a href="lihatartikel.php">Daftar Artikel</a></li>
								<li><a href="lihatpelanggan.php">Lihat Pelanggan</a></li>
								<li><a href="pengaturan.php">Pengaturan</a></li>
							</ul>
						</nav>
				<div>
					<h2 id="font">Selamat Datang Admin!</h2>
					<article id="font3">
						<h3>Petunjuk Penggunaan :</h3>
						<h4>1. Menu Sunting Artikel</h4>
						<p>Pada Menu ini, admin dapat menambah artikel baru kedalam sistem TranSys.</p>
						<h4>2. Menu Ubah Data</h4>
						<p>Menu ini menyediakan fitur penambahan data berupa jadwal keberangkatan Kereta Api.</p>
						<h4>3. Menu Lihat Data</h4>
						<p>Pada menu ini, daftar data penjadwalan Kereta Api ditampilkan dan memiliki fitur pengubahan dan penghapusan data.</p>
						<h4>4. Menu Daftar Artikel</h4>
						<p>Di menu ini admin dapat melihat daftar artikel dan melakukan perubahan pada artikel yang telah dibuat atau melihat tampilan artikel yang telah dibuat.</p>
						<h4>5. Menu Lihat Pelanggan</h4>
						<p>Pada menu Lihat Pelanggan, Admin bisa melihat Data Pelanggan yang sudah melakukan pemesanan tiket dan memiliki fitur pengubahan dan penghapusan data.</p>
						<h4>6. Menu Pengaturan</h4>
						<p>Pada menu pengaturan, Admin bisa melakukan perubahan kata sandi dan data kontak.</p>
					</article>
					
				</div>
					<footer>
						Copyright &copy 2023 by 210441100100 dan 210441100020
					</footer>

		</body>
</html>
