#!/usr/bin/env sh

QTILE_DIR="$HOME/qtile"
VENV_DIR="$QTILE_DIR/.venv"

cd "$QTILE_DIR" || { echo "Qtile directory not found."; exit 1; }

# Fetch latest changes
git fetch origin > /dev/null 2>&1

# Compare local and remote
LOCAL=$(git rev-parse @)
REMOTE=$(git rev-parse @{u})
BASE=$(git merge-base @ @{u})

if [ "$LOCAL" = "$REMOTE" ]; then
    echo "Qtile is already up to date."
    exit 0
elif [ "$LOCAL" = "$BASE" ]; then
    echo "Updating Qtile..."
    git pull --rebase
    echo "pulled updates"

    # Reinstall inside virtualenv
    if [ -d "$VENV_DIR" ]; then
        . "$VENV_DIR/bin/activate"
        echo "using pip"
        pip install -e .
        deactivate
    else
        echo "No virtualenv found, skipping reinstall."
    fi

    echo "Qtile updated successfully."
else
    echo "Local Qtile branch has diverged from remote — manual review needed."
fi

