<?php
	session_start();
	$id=$_GET['id'];
	$no_ktp=$_POST['no_ktp'];
	$nama = $_POST['nama'];
	$no_telp = $_POST['no_telp'];
	$email = $_POST['email'];
	$anak = $_POST['anak'];
	$dewasa = $_POST['dewasa'];
	if (isset($_POST['lanjut'])) {
		if ($no_ktp!=null && $nama!=null && $no_telp!=null && $email!=null) {			
			if(strlen($no_ktp) != 16){
				echo "<script>alert('No. KTP harus memiliki 16 digit');window.location.href='../form_pemesan.php?id=$id';</script>";
    			exit;
			}
			elseif(preg_match('/[0-9]/', $nama_pelanggan)){
				echo "<script>alert('Nama Lengkap tidak boleh mengandung angka');window.location.href='../form_pemesan.php?id=$id';</script>";
    			exit;
			}
			elseif(preg_match('/[A-Za-z]/', $no_telepon)){
				echo "<script>alert('Nomor Hp tidak boleh mengandung huruf');window.location.href='../form_pemesan.php?id=$id';</script>";
    			exit;
			}
			elseif(!strpos($email, '@')){
				echo "<script>alert('Email harus mengandung karakter \"@\"');window.location.href='../form_pemesan.php?id=$id';</script>";
    			exit;
			}
			else{
				$database = mysqli_connect("localhost","root","","pa_smbd4c");
				$query = mysqli_query($database,"SELECT * FROM KERETA WHERE id=$id");
				$data = mysqli_fetch_array($query);
				$hasil = ($data['tarif_dewasa']*$dewasa)+($data['tarif_anak']*$anak);
				mysqli_query($database,"INSERT INTO PELANGGAN VALUES(NULL,'$no_ktp','$nama','$no_telp','$email','$hasil', CURDATE())");
				$query2 = mysqli_query($database,"SELECT * FROM pelanggan_view");
				$data2 = mysqli_fetch_array($query2);
				$id_pelanggan = $data2['id_pelanggan'];
				$kode = null;
				$n = 6;
				$char = "k83dfh3ld8ab9hfcfg12d4g5h88354hi647j3m24ef645dfp3675q6nfd7krty6yt8y96ou44656x0v55yrw1tklk87k56yz25up6i6rstr";
				for ($i=0; $i < $n; $i++) { 
					$acak = rand($n,strlen($char));
					$kode = substr($char, $acak,$n);
				}
			 echo "<script>alert('Data berhasil disimpan!');";
			 mysqli_close($database);
			 echo  "window.location='../pilih_kursi.php?id=$id&ank=$anak&dws=$dewasa&idplg=$id_pelanggan&kdb=$kode'</script>";
			}
		}else{
			echo "<script>alert('Isi data secara lengkap!');window.location.href='../form_pemesan.php?id=$id';</script>";
		}
	}

	
?>