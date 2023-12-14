<!DOCTYPE html>
	<html>
		<head>
			<title>Home Transys</title>
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
										for($i=2016;$i<=2020;$i++){
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
								<h1>Login to TranSys</h1>
							</header>
							<center>
								<form id="lform" method="POST" action="proses/sesi_login.php">
									<input id="linput" type="text" name="username" placeholder="Username"></input><br>
									<input id="linput" type="password" name="password" placeholder="Password"></input><br>
									<button id="lbutton" type="submit" name="login">Login</button>
								</form>
							</center>		
						</div>
				
					<?php
						$database = mysqli_connect("localhost","root","","pa_smbd4c");
						$id = $_GET['id'];
						$query = mysqli_query($database,"SELECT * FROM KERETA WHERE id=$id");
						$query2 = mysqli_query($database, "SELECT * FROM ASAL WHERE id_kereta=$id");
						$query3 = mysqli_query($database, "SELECT * FROM TUJUAN WHERE id_kereta=$id");
						$data1 = mysqli_fetch_array($query);
						$data2 = mysqli_fetch_array($query2);
						$data3 = mysqli_fetch_array($query3);
						?>
				<article class="hasil">
					<?php
						$tanggal = date("d-m-Y", strtotime($data1['tanggal']));
						echo "<h3 id='jddetail'>Detail Kereta</h3>";
						echo "<center><table id='detailtb'>";
						echo "<tr>";
						echo "<td id='jd'>Nama Kereta</td>";
						echo "<td id='jdisi'>".$data1['nama_kereta']."</td>";
						echo "</tr>";
						echo "<tr>";
						echo "<td id='jd'>Kelas</td>";
						echo "<td id='jdisi'>".$data1['kelas']."</td>";
						echo "</tr>";
						echo "<tr>";
						echo "<td id='jd'>Asal</td>";
						echo "<td id='jdisi'>".$data2['nama_asal']."</td>";
						echo "</tr>";
						echo "<tr>";
						echo "<td id='jd'>Tujuan</td>";
						echo "<td id='jdisi'>".$data3['nama_tujuan']."</td>";
						echo "</tr>";
						echo "<tr>";
						echo "<td id='jd'>Tanggal</td>";
						echo "<td id='jdisi'>$tanggal</td>";
						echo "</tr>";
						echo "<tr>";
						echo "<td id='jd'>Jam Berangkat</td>";
						echo "<td id='jdisi'>".$data1['jam_berangkat']."</td>";
						echo "</tr>";
						echo "<tr>";
						echo "<td id='jd'>Jam Tiba</td>";
						echo "<td id='jdisi'>".$data1['jam_tiba']."</td>";
						echo "</tr>";
						echo "<tr>";
						echo "<td id='jd'>Tarif Dewasa</td>";
						echo "<td id='jdisi'>Rp ".number_format($data1['tarif_dewasa'],"2",",",".")."</td>";
						echo "</tr>";
						echo "<tr>";
						echo "<td id='jd'>Tarif Anak</td>";
						echo "<td id='jdisi'>Rp ".number_format($data1['tarif_anak'],"2",",",".")."</td>";
						echo "</tr>";
						echo "<tr><td id='jd'></td><td id='jdisi' style='color: blue; cursor: pointer;'><a id='cek'> Cek Kursi</a></td></tr>";
						echo "</table>";
						echo "<script type='text/javascript'> function redirect(){window.location.href='form_pemesan.php?id=$id';}</script>";
						echo "<button type='submit' id='tbpesan' onclick='return redirect()'>PESAN</button></center>";
					?>							
				</article>	
			</div>
			<script type="text/javascript">
			$(function(){
				$("#cek").mouseenter(function(){
					<?php echo "$('#cekkursi').load('proses/cek_kursi.php?id=$id');"; ?>
				});
				$("#cek").mouseleave(function(){
					$("#cekkursi").fadeOut();
				});
				$(document).ajaxStart(function(){
					$("#cekkursi").css({'display':'none'});
				});
				$(document).ajaxComplete(function(){
					$("#cekkursi").fadeIn();
				});
			});				
			</script>
			<div id="cekkursi"></div>		
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
