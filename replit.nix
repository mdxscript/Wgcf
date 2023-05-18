{ pkgs }: {
    deps = [
        pkgs.wget
        pkgs.zip
        pkgs.qrencode.bin
        pkgs.busybox
        pkgs.bashInteractive
        pkgs.man
    ];
}