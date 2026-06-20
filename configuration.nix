{ config, pkgs, ... }:

let
  home-manager = builtins.fetchTarball {
    url = "https://github.com/nix-community/home-manager/archive/master.tar.gz";
  };

  miku-cursor = pkgs.stdenvNoCC.mkDerivation {
    name = "miku-cursor";
    src = pkgs.fetchzip {
      url = "https://github.com/supermariofps/hatsune-miku-windows-linux-cursors/archive/refs/tags/1.2.6.tar.gz";
      hash = "sha256-OQjjOc9VnxJ7tWNmpHIMzNWX6WsavAOkgPwK1XAMwtE=";
    };
    installPhase = ''
      mkdir -p $out/share/icons
      cp -r miku-cursor-linux $out/share/icons/
    '';
  };
in
{
    
  imports =
    [
      /etc/nixos/hardware-configuration.nix
      "${home-manager}/nixos"
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "puter";

  networking.networkmanager.enable = true;

  time.timeZone = "Europe/London";

  i18n.defaultLocale = "en_GB.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_GB.UTF-8";
    LC_IDENTIFICATION = "en_GB.UTF-8";
    LC_MEASUREMENT = "en_GB.UTF-8";
    LC_MONETARY = "en_GB.UTF-8";
    LC_NAME = "en_GB.UTF-8";
    LC_NUMERIC = "en_GB.UTF-8";
    LC_PAPER = "en_GB.UTF-8";
    LC_TELEPHONE = "en_GB.UTF-8";
    LC_TIME = "en_GB.UTF-8";
  };

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  home-manager.users.adam = { pkgs, ... }: {
    home.stateVersion = "26.05";
    gtk = {
      enable = true;
      theme = {
        name = "Mint-Y-Dark-Purple";
        package = pkgs.mint-themes;
      };
      iconTheme = {
        name = "Mint-Y-Purple";
        package = pkgs.mint-y-icons;
      };
      cursorTheme = {
        name = "miku-cursor-linux";
        package = miku-cursor;
        size = 32;
      };
      font = {
        name = "Iosevka Nerd Font Mono";
        package = pkgs.nerd-fonts.iosevka;
        size = 11;
      };
    };
    programs.rofi = {
      enable = true;
      plugins = [pkgs.rofi-emoji];
    };
  };

  programs.hyprland.enable = true;

  services.xserver.xkb = {
    layout = "gb";
    variant = "";
  };
  services.xserver.autoRepeatDelay = 200;
  services.xserver.autoRepeatInterval = 80;

  console.keyMap = "uk";

  services.printing.enable = true;

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  users.users."adam" = {
    isNormalUser = true;
    description = "adam";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
    ];
  };

  programs.firefox.enable = true;
  programs.bash = {
    enable = true;
    shellAliases = {
      cls = "tput reset";
      ls = "ls --color=auto";
      ll = "ls -lah";
      grep = "grep --color=auto";
      tmux = "tmux -2";
    };
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    emacs-pgtk
    git
    vim
    wget
    xclip
    wl-clipboard
    stow
    kitty
    alacritty
    rofi
    rofi-emoji
    gnumake
    cmake
    gcc
    clang
    dunst
    mpd
    btop
    nemo
    waybar
    hyprpaper
    libtool
    unzip
    opencode
    hunspell
    mint-themes
    mint-x-icons
    mint-y-icons
    mint-cursor-themes
    lxappearance
    bolt-launcher
    steam
    steamcmd
  ];

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    nerd-fonts.iosevka
    iosevka
    font-awesome
  ];

  fonts.fontconfig.defaultFonts.monospace = [ "Iosevka Nerd Font Mono" ];
  fonts.fontconfig.defaultFonts.sansSerif = [ "Iosevka Nerd Font Mono" ];
  fonts.fontconfig.defaultFonts.serif = [ "Iosevka Nerd Font Mono" ];
  fonts.fontconfig.defaultFonts.emoji = [ "NotoFonts Color Emoji" ];

  environment.sessionVariables = rec {
    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_STATE_HOME = "$HOME/.local/state";
    XDG_BIN_HOME = "$HOME/.local/bin";

    LESSHISTFILE=".history";

    DOTNET_CLI_TELEMETRY_OPTOUT = 1;
    
    MPD_HOST = "localhost";
    MPD_PORT = "6969";

    PATH = [
      "${XDG_BIN_HOME}"
      "$HOME/puter/scriptz"
    ];
  };

  system.stateVersion = "26.05";

}
