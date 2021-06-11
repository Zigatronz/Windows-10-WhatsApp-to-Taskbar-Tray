# Windows 10 WhatsApp to Taskbar Tray
Basically minimize your WhatsApp window to tray

# How to download
- [Download Here](https://github.com/Zigatronz/Windows-10-WhatsApp-to-Taskbar-Tray/releases)

# How to use
1. Make sure you have installed WhatsApp via [Microsoft Store](https://www.microsoft.com/en-us/p/whatsapp-desktop/9nksqgp7f2nh)
2. Run WhatsAppTray.exe
3. Wait for WhatsApp window appear
4. Minimize WhatsApp, notice that your WhatsApp minimized to tray
5. Double click on WhatsApp tray to restore
6. Have fun ^o^

# How it's works
## Initialize (if WhatsApp not running)
1. Grab Get-AppxPackage and search for WhatsApp app info
2. Run WhatsApp via Explorer.exe
## Do tray thing
1. Detect WhatsApp minimize, then hide WhatsApp window and show tray
2. Double click tray, then reshow WhatsApp window and rehide tray
## Exit
- If WhatsApp process not exist, then this process will close
- If exit from tray, WhatsApp will also close
