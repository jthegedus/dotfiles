function update --description "Update system packages via Homebrew"
    if command -v brew
        echo "--- brew update ---"
        brew update
        echo "--- brew upgrade --greedy ---"
        brew upgrade --greedy
    end

    if command -v pacman
        echo "--- pacman upgrade ---"
        sudo pacman -Syu
    end

    if command -v fwupdmgr
        echo "--- fwupd firmware update ---"
        fwupdmgr refresh
        fwupdmgr update
    end

    if command -v flatpak
        echo "--- flatpak update ---"
        flatpak update
    end
end
