<?php
class pembatas{
	public $batas;
	function __construct(){
		$this->batas=1;
	}
	function batasp(){
		$this->batas=$this->batas+1;
	}

	function batask(){
		$this->batas=$this->batas-1;
	}
	function setBatas($setB){
		$this->batas=$setB;
	}
	function getBatas(){
		return $this->batas;
	}

}
	$set = new pembatas();
?>