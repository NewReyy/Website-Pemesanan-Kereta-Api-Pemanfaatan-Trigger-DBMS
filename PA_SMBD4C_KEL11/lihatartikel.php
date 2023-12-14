<?php
	include("proses/cek_sesi.php");
	include("proses/get_artikel.php");
?>
<!DOCTYPE html>
<html>
	<head>
		<title>SIKAT:Lihat Artikel</title>
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
								<li><a href="adminhome.php">Beranda</a></li>
								<li><a href="suntingartikel.php">Sunting Artikel</a></li>
								<li><a href="ubahdata.php">Ubah Data</a></li>
								<li><a href="lihatdata.php">Lihat Data</a></li>
								<li class="active"><a class="active" href="lihatartikel.php">Daftar Artikel</a></li>
								<li><a href="lihatpelanggan.php">Lihat Pelanggan</a></li>
								<li><a href="pengaturan.php">Pengaturan</a></li>
							</ul>
						</nav>
				<div style="font-family: Arial;">
					<h3 style="margin-left: 45%;">Daftar Artikel</h3>
					<table border="1" class="fontdt">
						<th>No</th>
						<th id="tabeljd">Judul</th>
						<th>Aksi</th>
							<?php
							$no = 1;
								while ($data = mysqli_fetch_array($get_judul)) {
									echo "<tr>";
									echo "<td>".$no++."</td>";
									echo "<td>".$data['judul']."</td>";
									echo "<td><a id ='lhtart' href='edit_artikel.php?id=".$data['id']."'>Edit</a>";
									echo "<a id ='lhtart' href='index.php#".$data['judul']."' target='_blank'>Lihat Artikel</a>";
									echo "<a id ='lhtart' href='proses/hapus_artikel.php?id=".$data['id']."'>Hapus</a></td>";
									echo "</tr>";
								}
							?>

					</table>
				</div>
					<footer>
						Copyright &copy 2016 by 14523144 dan 14523150
					</footer>
		</body>
</html>
