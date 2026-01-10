# WLS installeren 

Install WSL on windows 11
```bash
wsl --install
```

Copy .bashrc to ~/
```bash
copy-item .bashrch ~
```

Install fzf
```bash
sudo apt install fzf
```

Install fastfetch
```bash
wget https://github.com/fastfetch-cli/fastfetch/releases/latest/download/fastfetch-linux-amd64.deb

sudo apt install ./fastfetch-linux-amd64.deb

fastfetch
```

Install nvim
```bash
sudo apt install neovim
```

Install lazyvim
```bash
git clone https://github.com/LazyVim/starter ~/.config/nvim

rm -rf ~/.config/nvim/.git

nvim
```
