# 🐍 Auto-Activate Python venv in Bash, Zsh & Oh My Zsh

🔹 This script **automatically activates a Python virtual environment (venv)** in every new terminal session.  
🔹 Supports **Bash, Zsh, Fish**, and **Oh My Zsh** on **Ubuntu, Kali, Debian, Arch, and macOS**.  
🔹 **No manual activation required** – it works automatically! 🚀  

---

## 🚀 Features
✅ **Detects and configures your default shell** (Bash, Zsh, Oh My Zsh, Fish)  
✅ **Creates a virtual environment (`venv`) if it doesn’t exist**  
✅ **Automatically activates `venv` on every new terminal session**  
✅ **Fixes Oh My Zsh conflicts** to ensure activation works  
✅ **Sets `venv` Python & Pip as default** (no need to manually activate venv)  
✅ **Works on Linux & macOS** (Ubuntu, Kali, Debian, Arch, Manjaro, macOS)  

---

## 🔹 How to Install
### **1️⃣ Clone the Repository**
```bash
 git clone https://github.com/YOUR-USERNAME/auto-venv-activation.git && cd auto-venv-activation
```
**Make the Script Executable:**
```chmod +x setup_venv.sh```
**Run the Script:** 
```./setup_venv.sh```


✅ **Done!** Now, every time you open a new terminal, your Python virtual environment will be **automatically activated**. 🎉  

🛠️ **How It Works** → Detects your shell (**Bash, Zsh, Fish, or Oh My Zsh**) → Checks if **Python3 is installed** (installs if missing) → Creates a **virtual environment (`venv`) in `~/venv`** if it doesn’t exist → Modifies **shell config (`.bashrc`, `.zshrc`, or `config.fish`)** to: ✅ **Auto-activate `venv`** ✅ Set **venv's Python and Pip as default** → Handles **Oh My Zsh conflicts** → Applies changes **immediately** (no need to restart).  

🔥 **How to Uninstall (Remove Auto-Activation)** → Run:  
```bash
sed -i '/source \$HOME\/venv\/bin\/activate/d' ~/.bashrc ~/.zshrc ~/.config/fish/config.fish 2>/dev/null && \
sed -i '/export PATH="\$HOME\/venv\/bin:\$PATH"/d' ~/.bashrc ~/.zshrc ~/.config/fish/config.fish 2>/dev/null && \
rm -rf ~/venv
```
🎯 **Supported Platforms:** `✅ Ubuntu` `✅ Debian` `✅ Kali Linux` `✅ Arch Linux` `✅ Manjaro` `✅ macOS (with Python3 installed)`  

📜 **License:** This script is **open-source** and available under the **MIT License**.


This keeps **everything concise in a single block** while ensuring readability. 🚀 Let me know if you need further refinements! 😊
