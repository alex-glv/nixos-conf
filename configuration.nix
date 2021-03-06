{ config, lib, pkgs, ... }:

{
	imports =
		[ # Include the results of the hardware scan.
			../hardware-configuration.nix
			./desktop.nix
			./emacs.nix
		];

	boot.loader.gummiboot.enable = true;
	networking = {
		hostName = "alnix";
		wireless.enable = false;
		#wireless.interfaces = ["wlp3s0"];
		#wireless.driver = "nl80211";
		#wireless.userControlled.enable = true;
		wicd.enable = true;	
		useDHCP = false;
		enableIPv6 = false;
		networkmanager.enable = false;
		
	};
	system.stateVersion = "15.09";
	powerManagement.enable = true;

	virtualisation = {
		docker.enable = true;
		docker.socketActivation = false;
		virtualbox.host.enable = true;
	};

	boot.kernelPackages = pkgs.linuxPackages_4_3;
	boot.initrd.kernelModules = ["acpi" "thinkpad-acpi" "acpi-call"];
  	boot.extraModulePackages = [
  	];
	i18n = {
		consoleFont = "Lat2-Terminus16";
		consoleKeyMap = "dvorak";
		defaultLocale = "en_US.UTF-8";
	};

	time.timeZone = "Europe/Amsterdam";

	environment.systemPackages = with pkgs; [
		gtk
		gdb
		gcc
		man
		openvpn
		xlaunch
		tcpdump
		unzip
		xlibs.xev
		xlibs.xinput
		xlibs.xmessage
		xlibs.xmodmap
		bluez
		wget
		gnumake
		gnused
		dmenu
		emacs
		zsh  
		curl
		xclip
		htop
		zsh
		mesa
		ffmpeg
		vim
		git
		vagrant
		nettools
		i3status
		pavucontrol
		i3lock
		xss-lock
		feh
		bind
		rxvt
		rxvt_unicode
      		gnome.gnomeicontheme # more icons
      		hicolor_icon_theme   # icons for thunar
		pythonPackages.udiskie
		python3
		cryptsetup
		lxappearance
		gnome_themes_standard
		numix-gtk-theme
		audacious
		compton
		#wicd-gtk
	];
	security.setuidPrograms = [
    	"xlaunch"
  	];

	services = {
		nfs.server.enable = true;
		openssh.enable = true;
		tlp.enable = true;

		xserver = {
			enable = true;
			layout = "us";
			xkbVariant = "dvp";
			xkbOptions = "ctrl:nocaps";
			exportConfiguration = true;
			desktopManager = {
				#gnome3.enable = true;
				xterm.enable = false;
			};
			displayManager = {
				#sddm.enable = true;
				#gdm.enable = true;
				lightdm.enable = true;
			};
			windowManager = {
				i3.enable = true;
				default = "i3";
			};
		};
		redshift = {
				enable = true;
				latitude = "52.21";
				longitude = "4.55";
				temperature.day = 6000;
				temperature.night = 3700;
		};
		transmission = {
				enable = true;
		};
		udisks2 = { enable = true; };

	};
	programs = {
		#zsh ={
	        #	enable = true;
		#};
		light = {
			enable = true;
		};
		ssh.startAgent = true;
	};

	hardware = {
		trackpoint = {
			enable = true;
			speed = 255;
			sensitivity = 255;
			emulateWheel = true;
		};
		pulseaudio = {
			enable = true;
			package = pkgs.pulseaudioFull;
		};
		bluetooth = {
			enable = true;
		};
  		enableAllFirmware = true;
		
	};
	nixpkgs.config.packageOverrides = pkgs: {
 		bluez = pkgs.bluez5;
 	};


	users.extraUsers.alg = {
		isNormalUser = true;
		uid = 1000;
		useDefaultShell = false;
		initialPassword = "test";
		extraGroups = [ "wheel" "docker" "alg" "transmission" ];
		shell = "/run/current-system/sw/bin/bash";

	};


	nixpkgs.config.allowUnfree = true;
	
	fonts = {
		enableFontDir = true;
		enableGhostscriptFonts = true;
		fonts = with pkgs; [
			inconsolata
		];
	};
	services.logind.extraConfig = "IdleActionSec=9000000";

	nix.trustedBinaryCaches = [ https://hydra.nixos.org ];

  	nix.extraOptions = ''
	    build-cores = 4
 	'';
  	#system.activationScripts =
  	#{
    	#	dotfiles = lib.stringAfter [ "users" ]
    	#	''
      	#	cd /home/alg
	#	rm -rf dotfiles
      	#	cd dotfiles
	#	export PATH=${pkgs.gnused}/bin:$PATH
      	#	${pkgs.git}/bin/git clone https://github.com/alex-glv/dotfiles.git
      	#	${pkgs.gnumake}/bin/make GIT='${pkgs.git}/bin/git' all
	#	chown -R alg:alg /home/alg/
    	#	'';

  	#};
}
