<?php
	include("proses/cek_sesi.php");
?>
<!DOCTYPE html>
<html>
	<head>
		<title>Ubah Data</title>
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
								<li class="active"><a class="active" href="ubahdata.php">Ubah Data</a></li>
								<li><a href="lihatdata.php">Lihat Data</a></li>
								<li><a href="lihatartikel.php">Daftar Artikel</a></li>
								<li><a href="lihatpelanggan.php">Lihat Pelanggan</a></li>
								<li><a href="pengaturan.php">Pengaturan</a></li>
							</ul>
						</nav>
				<div>
					<h3 id="font">Tambah Data ke SIKAT</h3>
					<form method="POST" action="proses/set_data.php">						
						<label>Nama Kereta Api</label>
						<input class="jaraknama" name="namakereta" type="text"></input><br>
						<label>Kelas</label>
						<select class="jarakkelas" name="kelas">
							<option value="Eksekutif">Eksekutif</option>
							<option value="Bisnis">Bisnis</option>
							<option value="Ekonomi">Ekonomi</option>
						</select><br>
						<label>Asal</label>
						<select class="jarakasal" name="asal">
							<option value="Yogyakarta &#45; Stasiun Tugu">Yogyakarta &#45; Stasiun Tugu</option>
							<option value="Bandung &#45; Stasiun Hall">Bandung &#45; Stasiun Hall</option>
							<option value="Semarang &#45; Stasiun Semarang Tawang">Semarang &#45; Stasiun Semarang Tawang</option>
							<option value="Malang &#45; Stasiun Malang Kotabaru">Malang &#45; Stasiun Malang Kotabaru</option>
							<option value="Surabaya &#45; Stasiun Semut">Surabaya &#45; Stasiun Semut</option> 
						</select><br>
						<label>Tujuan</label>
						<select class="jaraktujuan" name="tujuan" type="text">
							<option value="Yogyakarta &#45; Stasiun Tugu">Yogyakarta &#45; Stasiun Tugu</option>
							<option value="Bandung &#45; Stasiun Hall">Bandung &#45; Stasiun Hall</option>
							<option value="Semarang &#45; Stasiun Semarang Tawang">Semarang &#45; Stasiun Semarang Tawang</option>
							<option value="Malang &#45; Stasiun Malang Kotabaru">Malang &#45; Stasiun Malang Kotabaru</option>
							<option value="Surabaya &#45; Stasiun Semut">Surabaya &#45; Stasiun Semut</option> 
						</select><br>
						<label>Tanggal/Bulan/Tahun</label>
						<?php
							echo "<select class='tanggal' name='tanggal'>";
							for ($i=1; $i <=31 ; $i++) { 
								echo "<option value='$i'>$i</option>";
							}
							echo "</select>&#45;";
							echo "<select class='bulan' name='bulan'>";
							for($i=1;$i<=12;$i++){
								echo "<option value='$i'>$i</option>";
							}
							echo "</select>&#45;";
							echo "<select class='tahun' name='tahun'>";
							for($i=2016;$i<=2023;$i++){
								echo "<option value='$i'>$i</option>";
							}
							echo "</select>";
						?><br>
						<label>Jam Keberangkatan/Tiba</label>
						<input class="jarakjam" name="jam1" type="time"></input><label><b>/</b></label><input class="jarakjam2" name="jam2" type="time"></input><br>
						<label>Harga Tiket Dewasa<br>(&#62;3 Tahun)</label>
						<input class="jarakharga1" name="tarif_d" type="text"></input><br>
						<label>Harga Tiket Anak-anak<br>(&#8804; 3 Tahun)</label>
						<input class="jarakharga" name="tarif_a" type="text"></input><br>
						<button class="batal" type="submit" name="batal">Batal</button>
						<button class="simpan" type="submit" name="simpan">Simpan</button>
					</form>
				</div>
					<footer>
						Copyright &copy 2023 by 210441100100 dan 210441100020
					</footer>

		</body>
</html>
