#!/bin/bash
set -euo pipefail

DOTFILES="$(cd "$(dirname "$0")" && pwd)"

# Files/patterns to exclude from new file detection
EXCLUDE_PATTERNS=(
    "*.jsonl"
    "stats-cache.json"
    "lazy-lock.json"
    ".DS_Store"
)

is_excluded() {
    local file="$1"
    local base
    base=$(basename "$file")
    for pattern in "${EXCLUDE_PATTERNS[@]}"; do
        # shellcheck disable=SC2254
        case "$base" in $pattern) return 0 ;; esac
    done
    return 1
}

# --- 1. Detect new (unmanaged) files in managed directories ---
echo "==> Scanning for new files in managed directories..."

managed_dirs=$(chezmoi managed --include=dirs --path-style=absolute 2>/dev/null | sort -u)
managed_files=$(chezmoi managed --include=files --path-style=absolute 2>/dev/null | sort)

new_files=()
while IFS= read -r dir; do
    [ -d "$dir" ] || continue
    while IFS= read -r file; do
        if ! echo "$managed_files" | grep -qxF "$file" && ! is_excluded "$file"; then
            new_files+=("$file")
        fi
    done < <(find "$dir" -maxdepth 1 -type f 2>/dev/null | sort)
done <<< "$managed_dirs"

if [ ${#new_files[@]} -gt 0 ]; then
    echo ""
    echo "Found ${#new_files[@]} new file(s) not yet managed by chezmoi:"
    echo ""
    for i in "${!new_files[@]}"; do
        printf "  [%d] %s\n" "$((i + 1))" "${new_files[$i]}"
    done

    echo ""
    read -rp "Enter numbers to add (e.g. 1 3 5), 'a' for all, or Enter to skip: " choice

    if [ -n "$choice" ]; then
        if [ "$choice" = "a" ]; then
            for f in "${new_files[@]}"; do
                echo "  Adding $f"
                chezmoi add "$f"
            done
        else
            for num in $choice; do
                idx=$((num - 1))
                if [ "$idx" -ge 0 ] && [ "$idx" -lt ${#new_files[@]} ]; then
                    echo "  Adding ${new_files[$idx]}"
                    chezmoi add "${new_files[$idx]}"
                else
                    echo "  Skipping invalid number: $num"
                fi
            done
        fi
    else
        echo "  Skipped."
    fi
else
    echo "  No new files found."
fi

# --- 2. Re-add existing managed files ---
echo ""
echo "==> Syncing target changes back to chezmoi source..."
chezmoi re-add

# --- 3. Show git status ---
echo ""
echo "==> Git status:"
git -C "$DOTFILES" status --short

if [ -z "$(git -C "$DOTFILES" status --porcelain)" ]; then
    echo "(no changes)"
fi
