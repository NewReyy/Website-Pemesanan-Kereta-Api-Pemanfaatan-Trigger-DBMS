<!DOCTYPE html>
	<html>
		<head>
			<title>Home Transys</title>
			<link rel="icon" type="image/png" href="images/iconnya.png">
			<link rel="stylesheet" type="text/css" href="css/style3.css">
			<link rel="stylesheet" type="text/css" href="css/style.css">
			<script type="text/javascript" src="scripts/jquery-1.12.2.js"></script>
			<script type="text/javascript" src="scripts/main.js"></script>
			<script type="text/javascript">
				function konfirmasi(){
					var pilihan = confirm('Yakin data Anda sudah benar?');
					if (pilihan==true) {
						return true;
					}else{
						return false;
					}
				}
			</script>
		</head>
			<body>				
			<div id="wrapper">				
				<header style="margin-top:1px">	
				<a href="index.php">			
					<img src="images/iconnya.png"></a>					
					<nav>
							<ul>
							<br>
								<li><a class="active">Isi Data Pemesan</a></li>
								<li><a>Pilih Kursi</a></li>
								<li><a>Review</a></li>
							</ul>
						</nav>
				</header>						
						
						
				<article class="hasil">
						<center>
						<?php
						$id = $_GET['id'];
							echo"<form method='POST' action='proses/proses_pesan.php?id=$id'>"; ?>
								<h3 id="jddetail">Isi Data Pemesan</h3>
								<table>
								<tr>
									<td id="jd">No. KTP</td>
									<td id="jdisi"><input name="no_ktp" style="width: 400px;"></td>
								</tr>
								<tr>
									<td id="jd">Nama Lengkap</td>
									<td id="jdisi"><input name="nama" style="width: 400px;"></td>
								</tr>
								<tr>
									<td id="jd">Nomer Telp/Hp</td>
									<td id="jdisi"><input name="no_telp" style="width: 400px;"></td>
								</tr>
								<tr>
									<td id="jd">Email</td>
									<td id="jdisi"><input name="email" style="width: 400px;"></td>
								</tr>
								<tr>
									<td id="jd">Jumlah Penumpang</td>
									<td><label>Dewasa</label>
									<select name="dewasa" id="jdisi">
										<?php for($i=1;$i<=4;$i++){echo "<option value='$i'>$i</option>";}?>
									</select>
									<label>Anak &#8804; 3</label>
									<select name="anak" id="jdisi">
										<?php for($i=0;$i<=3;$i++){echo "<option value='$i'>$i</option>";}?>
									</select>
									</td>
								</tr>									
							</table>
							<button type="submit" onclick="return konfirmasi()" name="lanjut" id="tbpesan2">Lanjut Pilih Kursi</button>
						</form>
						<br>
						<h5>Note : Semua form wajib diisi!</h5>
						</center>
				</article>	
			</div>		
			<footer>
				<div id="kontak_us">
				<?php
					$database = mysqli_connect("localhost","root","","pa_smbd4c");
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
