#!/usr/bin/env bash
set -x
set -eo pipefail

function buildnvim() {
    local nvim_dir="$HOME/Software/neovim"
    [ ! -d "$nvim_dir" ] && echo "Silly girl, you haven't cloned neovim..." && return

    cd "$nvim_dir" || { printf '\n========== COULD NOT CD TO NEOVIM DIRECTORY ==========\n' && return; }

    if ! git diff --exit-code; then
        printf '\n========== LOCAL NEOVIM CHANGES! ==========\n'
        return
    fi

    git checkout master
    git fetch upstream master
    git --no-pager log --decorate=short --pretty=short master..upstream/master
    git merge upstream/master

    local install_dir="$HOME/.nvim"
    rm -rf "$install_dir"
    make distclean

    local commit="${1:-HEAD}"
    printf '\n========== CHECKING OUT COMMIT %s... ==========\n' "$commit"
    git reset --hard "$commit"

    # Build
    make CMAKE_BUILD_TYPE=RelWithDebInfo CMAKE_INSTALL_PREFIX="$install_dir" install
}

buildnvim "$@"
