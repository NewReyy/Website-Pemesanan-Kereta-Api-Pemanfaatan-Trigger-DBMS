<?php
	include("proses/cek_sesi.php");
?>
<!DOCTYPE html>
<html>
	<head>
		<title>SIKAT:Pengaturan</title>
		<link rel="stylesheet" type="text/css" href="css/style2.css">
		<link rel="icon" type="image/png" href="images/iconnya.png">
		<script type="text/javascript" src="scripts/jquery-1.12.2.js"></script>
		<script type="text/javascript" src="scripts/pengaturan.js"></script>
		<script type="text/javascript">
			function konfirmasi_ktk(){
				var konfirmasi = confirm('Yakin ingin mengubah data kontak?');
				if (konfirmasi==true) {
					return true;
				}else{
					return false;
				}
			}
			function konfirmasi_pss(){
				var konfirmasi = confirm('Yakin ingin mengubah password?');
				if (konfirmasi==true) {
					return true;
				}else{
					return false;
				}
			}
		</script>
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
								<li><a href="lihatartikel.php">Daftar Artikel</a></li>
								<li><a href="lihatpelanggan.php">Lihat Pelanggan</a></li>
								<li class="active"><a class="active" href="pengaturan.php">Pengaturan</a></li>
							</ul>
						</nav>
				<div>
					<h2 id="font">Halaman Pengaturan Admin</h2>
					<div id="buttons">					
						<button id="show1">Ubah Sandi</button>
						<button id="show2">Ubah Kontak</button>					
					</div>
					<div id="ubhpass">
						<form class="settings" id="font2" method="POST" action="proses/set_password.php">
							<table>
							<tr>
							<td><label>Masukkan Kata Sandi Lama</label></td>
							<td><input id="jarakpass3" type="password" name="oldpassword"></input></td></tr><br>
							<tr>
							<td><label>Masukkan Kata Sandi Baru</label></td>
							<td><input id="jarakpass2" type="password" name="newpassword"></input></td></tr><br>
							<tr>
							<td><label>Masukkan Ulang Kata Sandi</label></td>
							<td><input class="cekpass" id="jarakpass" type="password" name="newpassword2"></input></td></tr>
							</table>					
							<button class="setmargin" type="submit" name="batal">Batal</button>
							<button type="submit" name="simpan" onclick="return konfirmasi_pss()">Simpan</button>
						</form>
					</div>
					<div id="ubhkontak">
						<form class="settings" id="font2" method="POST" action="proses/set_kontak.php">
							<label>Masukkan Nomor Telpon</label>
							<input id="jarakno" type="text" name="no_telp" placeholder="contoh : 021-XXXX"></input><br>
							<label>Masukkan Email</label>
							<input id="jarakemail" type="text" name="email" placeholder="contoh : XXXX@gmail.com"></input><br>
							<button class="setmargin" type="submit" name="batal">Batal</button>
							<button type="submit" name="simpan" onclick="return konfirmasi_ktk()">Simpan</button>
						</form>
					</div>
					<center>
						<button id="pilihan">Pilihan Pengaturan</button>
					</center>
				</div>
					<footer>
						Copyright &copy 2023 by 210441100100 dan 210441100020
					</footer>

		</body>
</html>
