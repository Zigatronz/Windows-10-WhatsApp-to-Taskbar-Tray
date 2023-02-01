# Windows 10 WhatsApp to Taskbar Tray
Basically, minimize your WhatsApp window to tray and let it run on background.

# How to download
- [Download Here](https://github.com/Zigatronz/Windows-10-WhatsApp-to-Taskbar-Tray/releases)

# How to use
1. Make sure you have installed WhatsApp via [Microsoft Store](https://www.microsoft.com/en-us/p/whatsapp-desktop/9nksqgp7f2nh)
2. Run WhatsAppTray.exe
3. Wait for WhatsApp window appear
4. Minimize WhatsApp, notice that your WhatsApp minimized to tray
![WhatsApp tray image](whattray.png)
5. Double click on WhatsApp tray to restore
6. There you go, WhatsApp running on background. Have a good day ^w^

# How it's works
## Initialize (if WhatsApp **not** running)
1. Grab Get-AppxPackage and search for WhatsApp app info
2. Run WhatsApp via Explorer.exe
## Initialize (if WhatsApp **is** running)
1. Active WhatsApp window
## Do tray thing
1. Detect WhatsApp minimize, then hide WhatsApp window and show tray
2. Double click tray, then reshow WhatsApp window and re-hide tray
## Exit
- Exits when WhatsApp exits
- Exits WhatsApp via tray menu

# NEED HELP!!
This software is no longer work due to WhatsApp UI update recently. The UI is now using Windows Application Frame Window which is I do able to hide the window but I can't completely hide it as the taskbar icon remains. Detail explanation on [stackoverflow](https://stackoverflow.com/questions/74001810).
