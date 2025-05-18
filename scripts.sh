#!/bin/bash

set -e  # Exit on any error

install_zig() {
    echo "Checking for necessary dependencies..."
    REQUIRED_PACKAGES=(cmake gcc g++ clang llvm-19-dev lld-19 liblld-19-dev)
    MISSING_PACKAGES=()
    
    for pkg in "${REQUIRED_PACKAGES[@]}"; do
        if ! dpkg -s "$pkg" &> /dev/null; then
            MISSING_PACKAGES+=("$pkg")
        fi
    done
    
    if [ ${#MISSING_PACKAGES[@]} -ne 0 ]; then
        echo "Installing missing dependencies: ${MISSING_PACKAGES[*]}"
        sudo apt update
        sudo apt install -y "${MISSING_PACKAGES[@]}"
    else
        echo "All dependencies are already installed."
    fi
    
    echo "Cloning Zig repository..."
    git clone https://github.com/ziglang/zig.git
    cd zig
    
    echo "Checking out latest successful commit..."
    LATEST_COMMIT=$(git log --oneline --grep "✅" | head -n 1 | awk '{print $1}')
    if [ -z "$LATEST_COMMIT" ]; then
        echo "Warning: No successful commits found. Using the latest master branch."
    else
        git checkout "$LATEST_COMMIT"
    fi
    
    echo "Building Zig..."
    mkdir build
    cd build
    cmake .. -DCMAKE_BUILD_TYPE=Release -DLLVM_CONFIG=/usr/bin/llvm-config-19
    make -j$(nproc)
    sudo make install
    
    echo "Zig installation complete!"
}

install_ghostty() {
    echo "Checking for Zig 0.13 installation..."
    if ! command -v zig &> /dev/null || [[ $(zig version) != "0.13"* ]]; then
        echo "Error: Zig 0.13 is required. Please install it first."
        exit 1
    fi
    
    echo "Cloning Ghostty repository..."
    git clone https://github.com/ghostty-org/ghostty.git
    cd ghostty
    
    echo "Checking out stable release tag..."
    LATEST_TAG=$(git describe --tags --abbrev=0)
    git checkout "$LATEST_TAG"
    
    echo "Building Ghostty..."
    zig build -Doptimize=ReleaseFast
    
    echo "Ghostty build complete!"
}

if [[ "$1" == "zig" ]]; then
    install_zig
elif [[ "$1" == "ghostty" ]]; then
    install_ghostty
else
    echo "Usage: $0 {zig|ghostty}"
fi
