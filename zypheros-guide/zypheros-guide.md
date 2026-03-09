# ZypherOS: The Official User Guide

## Table of Contents
1. [Introduction: The ZypherOS Philosophy](#1-introduction-the-zypheros-philosophy)
2. [System Management (The Arch Way)](#2-system-management-the-arch-way)
3. [System Rescue & Rollbacks](#3-system-rescue--rollbacks)
4. [ZypherOS Environments (The Payloads)](#4-zypheros-environments-the-payloads)
5. [The Terminal Experience](#5-the-terminal-experience)
6. [Version Control: Mastering Git](#6-version-control-mastering-git)
7. [The Neovim Survival Guide](#7-the-neovim-survival-guide)

---

## 1. Introduction: The ZypherOS Philosophy

Welcome to ZypherOS. 

This operating system was not built to hide Linux from you. It was built to give you a pristine, stable, and highly optimized Arch Linux foundation, and then get out of your way. There are no bloated graphical software centers, no forced telemetry, and no proprietary wrappers. 

ZypherOS assumes you are a capable user who wants a reliable daily driver that still respects your right to own and modify your system. We provide the infrastructure; you build the environment.

### The Core Stack & Installation Options
During the installation, ZypherOS allows you to tailor the core of your operating system to your specific hardware and workflow.

* **The Foundation:** Pure Arch Linux, featuring a custom deployment engine that ensures your system is correctly configured from the very first boot.
* **The Bootloader:** We utilize **Limine**, a modern, robust, and significantly lighter alternative to GRUB. It supports both modern UEFI and legacy BIOS systems flawlessly.
* **Kernel Selection:** * **Mainline (`linux`):** The standard Arch kernel for the absolute latest hardware support and features.
    * **Zen (`linux-zen`):** Tuned specifically for desktop responsiveness, multimedia, and heavy gaming.
    * **The LTS Failsafe:** Regardless of which primary kernel you choose, ZypherOS automatically installs the Long Term Support kernel (`linux-lts`) as a secondary boot option. If a cutting-edge update ever causes a boot issue, you always have a rock-solid backup ready in the Limine boot menu.
* **Filesystem Architecture:** * **BTRFS (Recommended):** Configured automatically with dedicated subvolumes (`@`, `@home`, `@log`, `@pkg`) to support instant system rollbacks via Snapper without overwriting your personal data.
    * **Ext4:** The traditional, rock-solid Linux filesystem.
    * **XFS:** A high-performance journaling filesystem optimized for parallel I/O.
* **Memory Management:** Natively configures **ZRAM** (compressing data in RAM to vastly improve performance and prolong SSD lifespan) or traditional physical Swap partitions (required for hibernation).
* **Security:** Optional Full-Disk **LUKS2** encryption integrated seamlessly into the bootloader.
* **The Desktop:** KDE Plasma (Wayland), providing a modern, tear-free graphical environment customized with the ZypherOS aesthetic.

### The ZypherOS Repository
Alongside the official Arch Linux repositories, your system is securely tied to `repo.zyphersystems.com`. This custom repository provides pre-compiled meta-packages (payloads). Instead of forcing every user to download gigabytes of software they don't need, these payloads allow you to instantly transform this minimal system into a gaming rig, a developer workstation, or a creator studio with a single command.

---

## 2. System Management (The Arch Way)

In ZypherOS, the terminal is your primary tool for system management. We do not use graphical "App Stores" because they abstract and obscure what is actually happening to your machine. The `pacman` package manager is incredibly fast, efficient, and transparent. Here is everything you need to know to maintain your system.

### Updating the System
Arch is a rolling release distribution. You do not need to wait for major version upgrades. To sync your databases and update all installed software, run:
```bash
sudo pacman -Syu
```
**CRITICAL RULE:** Never run `pacman -Sy` (syncing databases *without* updating packages) before installing a new program. This can cause dependency breakages known as partial upgrades. Always use `-Syu` to keep your system synchronized.

### Managing Packages
To search the official Arch repositories and the ZypherOS repository for a package:
```bash
pacman -Ss <search_term>
```

To install a package:
```bash
sudo pacman -S <package_name>
```

To cleanly remove a package **and** all of its unused dependencies (Highly Recommended over standard removal):
```bash
sudo pacman -Rns <package_name>
```

### Cleaning the Cache
Every time you download a package, `pacman` keeps a compressed copy of it in your cache (`/var/cache/pacman/pkg/`). Over time, this will silently eat up gigabytes of drive space. 

ZypherOS includes the `paccache` utility to safely manage this. To delete all cached packages except for the 2 most recent versions (allowing you to downgrade if an update breaks a program):
```bash
sudo paccache -r -k 2
```

### Managing System Services
ZypherOS uses `systemd` to manage background services (like Bluetooth, networking, SSH, or Docker).

To check if a service is running and view its recent logs:
```bash
systemctl status <service_name>
```
To start a service immediately for the current session:
```bash
sudo systemctl start <service_name>
```
To enable a service so it automatically starts every time you boot the computer:
```bash
sudo systemctl enable <service_name>
```
To disable a service from starting on boot:
```bash
sudo systemctl disable <service_name>
```

---

## 3. System Rescue & Rollbacks

When you run a bleeding-edge, rolling-release distribution, there is always a small chance that a new kernel or a massive desktop update might introduce a bug or cause a boot failure. This is not a flaw; it is the nature of cutting-edge software. 

ZypherOS is specifically engineered to ensure that when things break, you can always get your system back online in seconds.

### The Limine Failsafe Kernel
If you update your system, reboot, and suddenly find yourself staring at a black screen or a frozen desktop, the primary kernel may have a temporary conflict with your hardware.
1. Reboot your computer.
2. When the Limine boot menu appears, use your arrow keys to select **ZypherOS (linux-lts)**.
3. Press `Enter`.

This boots your system using the Long Term Support kernel. The LTS kernel prioritizes absolute stability over new features. You can safely use your computer in this failsafe mode until the primary kernel receives a patch.

### BTRFS & Snapper Rollbacks
If you chose the BTRFS filesystem during installation, your system is automatically configured to use `snapper`. Because your system files (`@`) and your personal files (`@home`) live on separate BTRFS subvolumes, you can completely revert your operating system to a previous state *without* losing any of your downloaded files, documents, or game saves.

**To view your system history:**
```bash
sudo snapper list
```
This will print a timeline of snapshots. Look for the "pre" and "post" snapshots created around the time you installed a broken package or ran a system update. Note the snapshot **number** you want to return to.

**To roll back the system:**
```bash
sudo snapper rollback <snapshot_number>
```
Once the command completes, simply reboot your computer. You will boot directly into the pristine, working snapshot. 

---

## 4. ZypherOS Environments (The Payloads)

Most distributions bloat their ISO files by guessing what software you might want. ZypherOS takes the opposite approach: we give you a minimal, highly optimized core and provide "Payloads" (meta-packages) to build out your environment exactly how you need it. 

These payloads are hosted on the official ZypherOS repository and securely pull down everything you need in a single command.

### The Gaming Environment
Transforms your system into a native Linux gaming powerhouse. 
* **Includes:** Steam, Lutris (for managing standalone game prefixes like World of Warcraft), Wine-Staging, Feral Gamemode (for background CPU/GPU optimization), and MangoHud (for performance overlays).
* **To Install:**
```bash
sudo pacman -S zypheros-gaming-env
```

### The Creator Environment
A complete suite of industry-standard, open-source production tools for audio, video, and graphic design.
* **Includes:** OBS Studio (streaming/recording), Kdenlive (video editing), Krita (digital painting), Audacity (audio mastering), and Inkscape (vector graphics).
* **To Install:**
```bash
sudo pacman -S zypheros-creator-env
```

### The Virtualization Environment
Equips your system with enterprise-grade local virtualization tools, allowing you to spin up and manage virtual machines with near-native performance.
* **Includes:** QEMU/KVM, Virt-Manager, and all required networking bridge dependencies.
* **To Install:**
```bash
sudo pacman -S zypheros-virtualization-env
```

### Flatpaks (Sandboxed Applications)
For closed-source or heavy graphical applications like Discord, Spotify, or Slack, ZypherOS recommends using **Flatpak**. Flatpaks sandbox these applications away from your core system files, ensuring they cannot break your dependencies.

The Flatpak engine is included in several of our payloads by default. You can search and install software directly from Flathub using the terminal:

**To search for an app:**
```bash
flatpak search <app_name>
```

**To install an app:**
```bash
flatpak install flathub <Application.ID>
```

### AUR (Arch User Repository)
ZypherOS includes yay preinstalled.  Yay is your gateway into the AUR.  The AUR is a massive collection of scripts designed to install nearly any applications onto your computer.  

The command `yay` allows you tap into the AUR to install your needed applications.  I would recomend only using packages out of the AUR if they are not natively in the Arch Repositories. 

`yay` utilizes the sames switches as pacman to keep things simple to remember. 

### Managing AUR Packages
To search the official Arch repositories and the ZypherOS repository for a package:
```bash
yay -Ss <search_term>
```

To install a package:
```bash
yay -S <package_name>
```

To cleanly remove a package **and** all of its unused dependencies (Highly Recommended over standard removal):
```bash
yay -Rns <package_name>
```
```
```
```
```

---

## 5. The Terminal Experience

ZypherOS is built for the command line. We have replaced legacy GNU tools with modern, blazingly fast alternatives written in Rust or Go, giving you a beautiful and highly efficient terminal out of the box.

### The Shell and Emulator
* **Ghostty:** Your default terminal emulator. It is GPU-accelerated, written in Zig, and incredibly responsive. 
* **Fish:** Your default shell. It provides intelligent auto-suggestion, syntax highlighting, and out-of-the-box web-like search capabilities without needing complex configuration files.

### Modern CLI Replacements
ZypherOS ships with several modern alternatives to standard Linux commands. You can still use the old commands, but learning these will vastly improve your workflow:

* **`eza` (Replaces `ls`):** A modern replacement for `ls` with color, icons, and git integration. 
  * *Try running:* `eza -la` (List all with details) or `eza -T` (View directory as a tree).
* **`bat` (Replaces `cat`):** A file viewer with built-in syntax highlighting and Git integration.
  * *Try running:* `bat /etc/os-release`
* **`zoxide` (Replaces `cd`):** A smarter `cd` command that learns your habits. Once you visit a directory, you can jump back to it from anywhere just by typing `z` and part of the name.
  * *Example:* `z down` will jump straight to `~/Downloads`.
* **`yazi`:** A blazing fast, async terminal file manager. Just type `yazi` to navigate your system, preview images directly in the terminal, and manage files without touching your mouse.
* **`fzf`:** A general-purpose command-line fuzzy finder. It is deeply integrated into Fish; just press `Ctrl+R` to instantly search your entire command history.

---

## 6. Version Control: Mastering Git

Whether you are pulling down AUR scripts or managing your own code, Git is essential. ZypherOS assumes you will be interacting with remote repositories (GitHub, GitLab, Forgejo) and is ready to accommodate both HTTPS and SSH workflows.

### First-Time Configuration
Before making your first commit, tell Git who you are:
```bash
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

### The Fundamental Workflow
1. Check repository status: `git status`
2. Stage your changes: `git add .` (Stages all files) or `git add <filename>`
3. Commit your changes: `git commit -m "Your descriptive message"`
4. Push to the remote server: `git push origin main`

### Authentication: HTTPS vs. SSH
While HTTPS is easy for cloning public repositories, **SSH** is the power-user standard for authentication. It prevents you from having to type a password every time you push code.

**Step 1: Generate an ED25519 SSH Key**
```bash
ssh-keygen -t ed25519 -C "your.email@example.com"
```
Press `Enter` to accept the default file location. You can add a passphrase for extra security.

**Step 2: Copy the Public Key**
```bash
cat ~/.ssh/id_ed25519.pub
```
Copy the output and paste it into the SSH Keys section of your Git host's settings panel.

**Step 3: Swap an Existing Repo to SSH**
If you cloned a repository using HTTPS and want to switch to SSH to avoid password prompts, check your current remote:
```bash
git remote -v
```
Then swap the URL (replacing the URL with your specific SSH path):
```bash
git remote set-url origin git@github.com:Username/Repository.git
```

---

## 7. The Neovim Survival Guide

ZypherOS does not force you to use `nano`. Your default terminal text editor is **Neovim**, pre-configured with the **LazyVim** framework. It acts as a full-fledged IDE right inside your terminal, complete with syntax highlighting, language servers, and file trees.

If you are new to Neovim, do not panic. Here are the survival basics.

### The Three Modes
Neovim is a "modal" editor, meaning your keyboard does different things depending on which mode you are in.
* **Normal Mode:** For moving around and running commands. (Press `Esc` to enter this mode).
* **Insert Mode:** For actually typing text. (Press `i` to enter this mode).
* **Visual Mode:** For highlighting text. (Press `v` to enter this mode).

### Basic Navigation (Normal Mode)
Take your hand off the mouse and the arrow keys. Use your right hand on the home row:
* `h` - Left
* `j` - Down
* `k` - Up
* `l` - Right

### File Management (The Leader Key)
In LazyVim, the `Spacebar` acts as your "Leader" key to trigger powerful IDE commands.
* **Open File Tree:** Press `Space` then `e`. (Use `h j k l` to navigate the tree, `Enter` to open a file).
* **Fuzzy Find Files:** Press `Space` then `f` then `f`. Start typing the name of any file in your project, and press `Enter` to jump straight to it.

### Saving and Exiting (Normal Mode)
Ensure you are in Normal Mode by pressing `Esc`, then type:
* `:w` and press `Enter` to **Save** (Write).
* `:q` and press `Enter` to **Quit**.
* `:wq` and press `Enter` to **Save and Quit**.
* `:q!` and press `Enter` to **Force Quit** without saving changes.

---



