$(document).ready(function(){
			$("#carijadwal").hide();
			$("#menulogin").hide();
			$("#carijadwal2").hide();
			$("#menulogin2").hide();
			$(".login").click(function(){
				$("#menulogin").fadeIn('slow');
			});
			$("#click").click(function(){
				$("#carijadwal").slideDown();
			});
			$("#close").click(function(){
				$("#carijadwal").slideUp();
			});
			$("#cls").click(function(){
				$("#menulogin").fadeOut('slow');
			});
			$(".login").click(function(){
				$("#menulogin2").fadeIn('slow');
			});
			$("#click").click(function(){
				$("#carijadwal2").slideDown();
			});
			$("#close").click(function(){
				$("#carijadwal2").slideUp();
			});
			$("#cls").click(function(){
				$("#menulogin2").fadeOut('slow');
			});
			$("#slideshow > div:gt(0)").hide();

			setInterval(function() { 
  				$('#slideshow > div:first')
			    .fadeOut(1000)
			    .next()
			    .fadeIn(1000)
			    .end()
			    .appendTo('#slideshow');
			},  3000);
});