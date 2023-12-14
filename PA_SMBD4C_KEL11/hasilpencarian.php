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
			<body>				
			<div id="wrapper">				
				<header style="margin-top:1px">	
				<a href="index.php">			
					<img src="images/iconnya.png"></a>					
					<nav>
							<ul>
							<br>
								<li><a href="index.php">Home</a></li>
								<li><a class="active" id="click" >Cari Jadwal Kereta Api</a></li>
								<li class="login"><a>Login Admin</a></li>
							</ul>
						</nav>
				</header>						
						<div id="carijadwal2">
							<button id="close">close</button>
							<header id="rheader">
								<h1>Cari Jadwal</h1>
							</header>
							<form id="rform" method="POST" action="hasilpencarian.php">
								<label>Tanggal &#40;tanggal&#45;bulan&#45;tahun&#41;</label><br>
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
						<div id="menulogin2">
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
				<article class="hasil">
							<?php
								error_reporting(0);
								$tgl = $_POST['tanggal'];
								$bln = $_POST['bulan'];
								$thn = $_POST['tahun'];
								$tujuan = $_POST['tujuan'];
								$asal = $_POST['asal'];
								$database = mysqli_connect("localhost","root","","pa_smbd4c");
								$get = mysqli_query($database,"SELECT * FROM KERETA WHERE tanggal='$thn-$bln-$tgl'");
								$cek = mysqli_num_rows($get);
								if($cek==0){
									echo "<center><h1>Tidak ada jadwal yang tersedia</h1></center>";
								}else{ ?>
									<center><table id="tbhasil">
											<th id="jdwl">Nama Kereta</th>
											<th id="jdwl">Asal</th>
											<th id="jdwl">Tujuan</th>
											<th id="jdwl">Tanggal</th>										
											<th id="jdwl">Jam Berangkat</th>
											<th id="jdwl">Jam Tiba</th>
											<th id="jdwl">Kelas</th>
											<th id="jdwl">Aksi</th>
									<?php
									while ($data = mysqli_fetch_array($get)) {
										$id = $data['id'];
										$get1 = mysqli_query($database,"SELECT * FROM ASAL WHERE id_kereta=$id AND nama_asal='$asal'");
										$get2 = mysqli_query($database,"SELECT * FROM TUJUAN WHERE id_kereta=$id AND nama_tujuan='$tujuan'");
										$data1 = mysqli_fetch_array($get1);
										$data2 = mysqli_fetch_array($get2);
										$tanggal = date("d-m-Y", strtotime($data['tanggal']));
										if($data1['nama_asal']!=null && $data2['nama_tujuan']!=null){ 								
											echo "<tr>";
											echo "<td id='isijdwl'>".$data['nama_kereta']."</td>";									
											echo "<td id='isijdwl'>".$data1['nama_asal'];
											echo "<td id='isijdwl'>".$data2['nama_tujuan']."</td>";
											echo "<td id='isijdwl'>$tanggal</td>";
											echo "<td align='center' id='isijdwl'>".$data['jam_berangkat']."</td>";
											echo "<td align='center' id='isijdwl'>".$data['jam_tiba']."</td>";
											echo "<td id='isijdwl'>".$data['kelas']."</td>";
											if($data['status']=='Belum berangkat'){
												echo "<td id='isijdwla'><a style='color: white;' href='detail.php?id=$id'>Detail</a></td>";	
											}else{
												echo "<script>alert('Kereta yang dipilih sudah berangkat');</script>";
    											exit;
											}
																			
											echo "</tr>";
										}
									}
								}
							?>

					</table></center>
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
