
Config {
		-- appearance
		 font = "xft:Roboto Mono:size=7:antialias=true:hinting=true"
	   , additionalFonts = []
	   , borderColor = "black"
	   , border = TopB
	   , bgColor = "black"
	   , fgColor = "grey"
	   , alpha = 100
	   , position = Bottom
	   , textOffset = -1
	   , iconOffset = -1
	   , lowerOnStart = True
	   , pickBroadest = False
	   , persistent = False
	   , hideOnStart = False
	   , iconRoot = "."
	   , allDesktops = True
	   , overrideRedirect = True
	   , sepChar = "%"
	   , alignSep = "}{"
	   , commands = [
				   Run Weather "EDDK" ["-t","<station>: <tempC>C",
					"-L","18","-H","25",
					"--normal","green",
					"--high","red",
					"--low","lightblue"] 36000

				 , Run Network "eno1" ["-L","0","-H","32", "--normal","green","--high","red"] 10

				 , Run Cpu ["-L","3","-H","50", "--normal","green","--high","red"] 10

				 , Run Memory ["-t","Mem: <usedratio>%"] 10

				 , Run Date "%a %b %_d %Y %H:%M:%S" "date" 10

				 , Run UnsafeStdinReader
				 ]
	   , template = "%UnsafeStdinReader% %cpu% | %memory% | %eno1% }\
				 \{ %EDDK% | <fc=#ee9a00>%date%</fc> "}
