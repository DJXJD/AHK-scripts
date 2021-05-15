; Initialise global variables
global showName := StrReplace(A_Args[1], " ", "%20")
global torrentName := StrReplace(A_Args[3], " ", "%20")

; Initiates correct process for what's been downloaded
switch A_Args[1]{
case "Black Clover":
	processEP("Absolute", "E:\Media Stuff\Anime\Black Clover")
case "Boruto":
	processEP("Absolute", "E:\Media Stuff\Anime\Boruto Naruto Next Generations")
case "Detective Conan":
	processEP("Absolute", "E:\Media Stuff\Anime\Detective Conan")
case "Digimon Adventure (2020)":
	processEP("Airdate", "E:\Media Stuff\Anime\Digimon Adventure (2020)", "376003")
case "Pocket Monsters (2019)":
	processEP("Absolute", "E:\Media Stuff\Anime\Pocket Monsters (2019)", "372460")
case "Spider isekai":
	processEP("Airdate", "E:\Media Stuff\Anime\So I'm a Spider, So What", "377902")
case "7 Deadly Sins S4":
	processEP("Airdate", "E:\Media Stuff\Anime\The Seven Deadly Sins")
case "HeroAca S5":
	processEP("Absolute", "E:\Media Stuff\Anime\My Hero Academia", "305074")
case "Maryarr p2":
	processEP("Airdate", "E:\Media Stuff\Anime\Moriarty the Patriot", "385542")
case "Koikimo":
	processEP("Airdate", "E:\Media Stuff\Anime\Koikimo", "397860")
case "Vivy":
	processEP("Airdate", "E:\Media Stuff\Anime\Vivy - Fluorite Eye's Song", "397774")
case "Combatants":
	processEP("Airdate", "E:\Media Stuff\Anime\Combatants Will Be Dispatched!", "394340")
case "Megalobox S2":
	processEP("Airdate", "E:\Media Stuff\Anime\MEGALOBOX", "341437")
case "Higehiro":
	processEP("Airdate", "E:\Media Stuff\Anime\Higehiro After Being Rejected, I Shaved and Took in a High School Runaway", "390306")
case "Fruits Basket S3":
	processEP("Airdate", "E:\Media Stuff\Anime\Fruits Basket (2019)", "357488")
case "The Slime Diaries":
	processEP("Airdate", "E:\Media Stuff\Anime\The Slime Diaries That Time I Got Reincarnated as a Slime", "385374")
case "No Demon Lord S2":
	processEP("Airdate", "E:\Media Stuff\Anime\How Not to Summon a Demon Lord", "347425")
case "World Ends With You":
	processEP("Airdate", "E:\Media Stuff\Anime\The World Ends With You The Animation", "392668")
case "86":
	processEP("Airdate", "E:\Media Stuff\Anime\86 Eighty Six", "378609")
case "Nagatoro-san":
	processEP("Airdate", "E:\Media Stuff\Anime\Don't Toy With Me, Miss Nagatoro", "385278")
case "Pretty Boy Nisio Gap":
	processEP("Airdate", "E:\Media Stuff\Anime\Pretty Boy Detective Club", "399147")
case "Tokyo Revengers":
	processEP("Airdate", "E:\Media Stuff\Anime\Tokyo Revengers", "393478")
case "To Your Eternity":
	processEP("Airdate", "E:\Media Stuff\Anime\To Your Eternity", "375271")
case "Zombie Land Saga S2":
	processEP("Airdate", "E:\Media Stuff\Anime\Zombie Land Saga", "351953")
case "Kid Girl Wins Romcom":
	processEP("Airdate", "E:\Media Stuff\Anime\Osamake Romcom Where the Childhood Friend Won't Lose", "396052")
case "Mars Red":
	processEP("Airdate", "E:\Media Stuff\Anime\Mars Red", "397250")
case "Sus-Guitar Prodigy":
	processEP("Airdate", "E:\Media Stuff\Anime\Those Snow White Notes", "397965")
case "ODDTAXI":
	processEP("Airdate", "E:\Media Stuff\Anime\ODDTAXI", "397208")
case "Shadows House":
	processEP("Airdate", "E:\Media Stuff\Anime\Shadows House", "396876")
default:
	Run % "curl -X POST -g " """http://localhost:8096/emby/Notifications/Admin?Name=Torrent%20download%20complete&Description=The%20following%20torrent%20has%20finished%20downloading:%0A%0A" torrentName "&api_key= insert api key here "" -H ""Content-Length: 0""", , Hide
}

; Processes downloaded episode
processEP(dbShowOrder, outputPath, tvdbid:=""){
	notifyESAdmins()
	mkLink(dbShowOrder, outputPath, tvdbid)
	refreshESLibs()
}

; Makes correctly named hardlink in correct place
mkLink(dbShowOrder, outputPath, tvdbid:=""){
	if (tvdbid != ""){
		RunWait % "filebot -rename --db TheTVDB --order " dbShowOrder " --action hardlink --q """ tvdbid """ --format {n}_{order.airdate.s00e00} -non-strict --output """ outputPath """ """ A_Args[2] """", , Hide
	}else{
		RunWait % "filebot -rename --db TheTVDB --order " dbShowOrder " --action hardlink --filter ""age <= 5"" --format {n}_{order.airdate.s00e00} -non-strict --output """ outputPath """ """ A_Args[2] """", , Hide
	}
}

; Notifies emby server admins
notifyESAdmins(){
	Run % "curl -X POST -g " """http://localhost:8096/emby/Notifications/Admin?Name=Processing%20new%20" showName "%20episode&Description=%0ATorrent%20name:%0A" torrentName "%0A%0APlease%20assure%20correct%20processing.&api_key= insert api key here "" -H ""Content-Length: 0""", , Hide
}

; Refreshes emby server libraries
refreshESLibs(){
	Run % "curl -X POST " """http://localhost:8096/emby/Library/Refresh?api_key= insert api key here "" -H ""Content-Length: 0""", , Hide
}