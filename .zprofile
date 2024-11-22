if [ "$(tty)" = "/dev/tty1" ]; then
    export MOZ_ENABLE_WAYLAND=1
    export SAL_USE_VCLPLUGIN=gtk3
    export QT_QPA_PLATFORM=wayland-egl
    export QT_WAYLAND_FORCE_DPI=physical
    export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
    export GTK_THEME=Adwaita:dark
    export GTK2_RC_FILES=/usr/share/themes/Adwaita-dark/gtk-2.0/gtkrc
    export QT_STYLE_OVERRIDE=Adwaita-Dark
    export ECORE_EVAS_ENGINE=wayland_egl
    export ELM_ENGINE=wayland_egl
    export SDL_VIDEODRIVER=wayland
    export _JAVA_AWT_WM_NONREPARENTING=1
    exec sway
fi
