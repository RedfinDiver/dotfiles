##########################################
#  Custom Manjaro installation script    #
##########################################

# after installation first update system
sudo pacman -Syu --noconfirm

##########################################
#     do this section manually           #
#  before or after this script executed  #
##########################################

# prepare for changing uid and gid for main user
# this is necassary for nfs access on the nas
##-> sudo useradd -m -G wheel test
##-> sudo passwd test 
##-> sudo visudo /etc/sudoers # uncomment line for all wheelers to become sudo

# login as test and do
##-> sudo groupadd --gid 100 nfs
##-> sudo usermod -u 1028 -g 100 markus
##-> sudo find / -user 1000 -exec chown 1028 {} \;
##-> sudo find / -group 1000 -exec chgrp 100 {} \;

# login again as user markus and do
##-> sudo userdel -r test

##########################################
#     Install and configure autofs       #
##########################################

sudo pacman -S autofs --noconfirm 
mkdir $HOME/NAS
echo "/home/markus/NAS    /etc/autofs/auto.synology --ghost" | sudo tee -a /etc/autofs/auto.master > /dev/null
sudo touch /etc/autofs/auto.synology
echo "markus -fstype=nfs,rw,retry=0 192.168.178.20:/volume1/homes/markus" | sudo tee -a /etc/autofs/auto.synology > /dev/null
echo "share -fstype=nfs,rw,retry=0 192.168.178.20:/volume1/share" | sudo tee -a /etc/autofs/auto.synology > /dev/null
echo "video -fstype=nfs,rw,retry=0 192.168.178.20:/volume1/video" | sudo tee -a /etc/autofs/auto.synology > /dev/null
sudo systemctl start autofs.service
sudo systemctl enable autofs.service

##########################################
#    Install and configure development   #
##########################################

sudo pacman -S code ant docker docker-compose python-pip --noconfirm

# python
sudo pip install pipenv

# git
git config --global user.name "Redfindiver"
git config --global user.email "redfindiver@gmail.com"

# ant
pamac build apache-ant-contrib
cd ~/Downloads
wget https://sourceforge.net/projects/xmltask/files/xmltask/1.16/xmltask.jar
sudo cp xmltask.jar /usr/share/java/apache-ant/xmltask.jar
rm xmltask.jar
sudo archlinux-java set java-13-openjdk

# docker
sudo usermod -aG docker markus
sudo systemctl start docker
sudo systemctl enable docker

# install vscode extensions
code --install-extension MS-CEINTL.vscode-language-pack-de
code --install-extension ms-python.python
code --install-extension bmewburn.vscode-intelephense-client
code --install-extension felixfbecker.php-debug
code --install-extension formulahendry.code-runner
code --install-extension alefragnani.project-manager
code --install-extension Gruntfuggly.todo-tree
code --install-extension nickheap.vscode-ant
code --install-extension ms-azuretools.vscode-docker
code --install-extension lextudio.restructuredtext
code --install-extension ziishaned.livereload
code --install-extension skyapps.fish-vscode
code --install-extension mikestead.dotenv

##########################################
#             Applications               #
##########################################

sudo pacman -S \
gimp gimp-help-de \
chromium \
handbrake \
fish \
inkscape \
keepassxc --noconfirm

# fish shell customisation
sudo chsh -s /usr/bin/fish markus
curl -L https://get.oh-my.fish | fish
omf install simple-ass-prompt
ln -s /home/markus/Projekte/dotfiles/fish/myabbr.fish /home/markus/.config/fish/conf.d/myabbr.fish

# flatpaks
flatpak install flathub com.bitwarden.desktop
flatpak install flathub com.skype.Client

# AUR builds
pamac build gimp-plugin-saveforweb
pamac build synology-drive
pamac build arronax

# uninstall stuff
sudo pacman -R evolution --noconfirm

##########################################
#     Themes and other customisation     #
##########################################

# install themes
sudo pacman -S moka-icon-theme --noconfirm

# gesettings, dconf watch / is your friend ;-)
gsettings set org.gnome.shell.extensions.user-theme name "Matcha-dark-azul"
gsettings set org.gnome.desktop.interface gtk-theme "Matcha-dark-azul"
gsettings set org.gnome.desktop.interface cursor-theme "Xcursor-breeze-snow"
gsettings set org.gnome.desktop.interface icon-theme "Moka"

gsettings set org.gnome.desktop.interface font-name "Noto Sans 10"
gsettings set org.gnome.desktop.interface document-font-name "Sans 10"
gsettings set org.gnome.desktop.interface monospace-font-name "Hack 10"
gsettings set org.gnome.desktop.wm.preferences titlebar-font "Cantarell Bold 10"
gsettings set org.gnome.desktop.input-sources xkb-options "['caps:none']"

gsettings set org.gnome.nautilus.preferences default-folder-viewer "list-view"
gsettings set org.gnome.nautilus.list-view default-zoom-level "small"
gsettings set org.gnome.shell favorite-apps "['firefox.desktop', 'org.gnome.Nautilus.desktop', 'org.gnome.Terminal.desktop', 'org.gnome.tweaks.desktop', 'code-oss.desktop']"
gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/', '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/']"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ name 'terminal'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ command 'gnome-terminal'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ binding '<Primary><Alt>t'
gsettings set org.gnome.shell favorite-apps "['firefox.desktop', 'chromium.desktop', 'org.gnome.Nautilus.desktop', 'org.gnome.tweaks.desktop', 'code-oss.desktop', 'com.bitwarden.desktop.desktop', 'webserver.desktop']"

# hosts file settings
echo "192.168.178.100  nas" | sudo tee -a /etc/hosts > /dev/null
echo "w014834e.kasserver.com allinkl" | sudo tee -a /etc/hosts > /dev/null
