/obj/item/book/manual/wiki/initialize_wikibook()
	var/wikiurl = CONFIG_GET(string/wikiurl)
	if(wikiurl)
		dat = {"

			<html><head>[UTF8HEADER]
			<style>
				iframe {
					display: none;
				}
			</style>
			</head>
			<body>
			<script type="text/javascript">
				function pageloaded(myframe) {
					document.getElementById("loading").style.display = "none";
					myframe.style.display = "inline";
    			}
			</script>
			<p id='loading'>You start skimming through the manual... <span style="text-decoration: underline;">(please wait a few seconds while info is fetched)</span></p>
			<iframe width='100%' height='97%' onload="pageloaded(this)" src="[wikiurl]index.php?title=[page_link]&printable=yes&remove_links=1" frameborder="0" id="main_frame"></iframe>
			</body>

			</html>

			"}
