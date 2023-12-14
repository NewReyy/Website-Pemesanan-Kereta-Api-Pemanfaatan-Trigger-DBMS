<!DOCTYPE html>
	<html>
		<head>
			<title>Home SIKAT</title>
			<link rel="icon" type="image/png" href="images/iconnya.png">
			<link rel="stylesheet" type="text/css" href="css/style3.css">
			<link rel="stylesheet" type="text/css" href="css/style.css">
			<script type="text/javascript" src="scripts/jquery-1.12.2.js"></script>
			<script type="text/javascript" src="scripts/main.js"></script>
		</head>
		</head>
			<body>				
			<div id="wrapper">				
				<header style="margin-top:1px">	
				<a href="index.php">			
					<img src="images/iconnya.png"></a>					
					<nav>
							<ul>
							<br>
								<li><a class="active" href="index.php">Home</a></li>
								<li><a id="click" >Cari Jadwal Kereta Api</a></li>
								<li class="login"><a>Login Admin</a></li>
							</ul>
						</nav>
				</header>
						<div id="slideshow">
							<div>
								<img src="images/kreta.jpg">
							</div>
							<div>
								<img src="images/background.jpg">
							</div>
							<div>
								<img src="images/background.png">
							</div>
						</div>
						<div id="carijadwal">
							<button id="close">close</button>
							<header id="rheader">
								<h1>Cari Jadwal</h1>
							</header>
							<form id="rform" method="POST" action="hasilpencarian.php">
								<label>Tanggal &#40;Tanggal&#45;Bulan&#45;Tahun&#41;</label><br>
									<?php
										echo "<select name='tanggal'>";
										for ($i=1; $i <=31 ; $i++) { 
											echo "<option value='$i'>$i</option>";
										}
										echo "</select>&#45;";
										echo "<select name='bulan'>";
										for($i=1;$i<=12;$i++){
											echo "<option value='$i'>$i</option>";
										}
										echo "</select>&#45;";
										echo "<select name='tahun'>";
										for($i=2016;$i<=2023;$i++){
											echo "<option value='$i'>$i</option>";
										}
										echo "</select>";
									?><br>
								<label>Asal</label><br>
								<select id="roption" name="asal">
									<option value="Yogyakarta &#45; Stasiun Tugu">Yogyakarta &#45; Stasiun Tugu</option>
									<option value="Bandung &#45; Stasiun Hall">Bandung &#45; Stasiun Hall</option>
									<option value="Semarang &#45; Stasiun Semarang Tawang">Semarang &#45; Stasiun Semarang Tawang</option>
									<option value="Malang &#45; Stasiun Malang Kotabaru">Malang &#45; Stasiun Malang Kotabaru</option>
									<option value="Surabaya &#45; Stasiun Semut">Surabaya &#45; Stasiun Semut</option> 
								</select><br>
								<label>Tujuan</label><br>
								<select id="roption" name="tujuan">
									<option value="Yogyakarta &#45; Stasiun Tugu">Yogyakarta &#45; Stasiun Tugu</option>
									<option value="Bandung &#45; Stasiun Hall">Bandung &#45; Stasiun Hall</option>
									<option value="Semarang &#45; Stasiun Semarang Tawang">Semarang &#45; Stasiun Semarang Tawang</option>
									<option value="Malang &#45; Stasiun Malang Kotabaru">Malang &#45; Stasiun Malang Kotabaru</option>
									<option value="Surabaya &#45; Stasiun Semut">Surabaya &#45; Stasiun Semut</option> 
								</select><br>
								<button id="lbutton" type="submit" name="cari">Cari</button>
							</form>
						</div>
						<div id="menulogin">
							<button id="cls">close</button>
							<header id="lheader">
								<h1>Login to SIKAT</h1>
							</header>
							<center>
								<form id="lform" method="POST" action="proses/sesi_login.php">
									<input id="linput" type="text" name="username" placeholder="Username"></input><br>
									<input id="linput" type="password" name="password" placeholder="Password"></input><br>
									<button id="lbutton" type="submit" name="login">Login</button>
								</form>
							</center>		
						</div>
				<article>
					<?php
					$database = mysqli_connect("localhost","root","","pa_smbd4c");
					$query = mysqli_query($database,"SELECT * FROM artikel_view");
					while ($data = mysqli_fetch_array($query)) {
					$tanggal = date("d-m-Y", strtotime($data['tanggal']));
						echo "<h5 style='clear: both; position: absolute; margin-left: 74%;'>$tanggal</h5>";
						echo "<h3 class='judul' id='".$data['judul']."'>".$data['judul']."</h3>";
						echo "<p class='isi'>".$data['isi']."</p>";
					}
					?>
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
				<marquee align="down">SIKAT : Sistem Informasi Kereta Api Terbaik</marquee>
			</footer>
			</body>
</html>
