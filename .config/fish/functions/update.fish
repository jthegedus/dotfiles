function update --description "Update: firmware, system, userland cli & apps"
    # Firmware
    if command -q fwupdmgr
        echo
        echo "--- fwupd firmware update ---"
        fwupdmgr refresh
        fwupdmgr update
    end

    # System
    if command -q pacman
        echo
        echo "--- pacman upgrade ---"
        sudo pacman -Syu
    end

    # Userland CLI & Apps
    if command -q brew
        echo
        echo "--- brew update ---"
        brew update

        echo
        echo "--- brew bundle ---"
        brew bundle --file=$HOME/.config/brewfile/Brewfile

        echo
        echo "--- brew upgrade --greedy ---"
        brew upgrade --greedy
    end

    if command -q flatpak
        echo
        echo "--- flatpak update ---"
        flatpak update
    end
end
