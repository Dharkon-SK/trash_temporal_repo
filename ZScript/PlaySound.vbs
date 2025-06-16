Set Sound = CreateObject("WMPlayer.OCX.7")
Sound.URL = "Fun.mp3"
Sound.Controls.Play
Do
WScript.Sleep 200
Loop
WScript.Sleep (int(Sound.currentmedia.duration)+1)*1
