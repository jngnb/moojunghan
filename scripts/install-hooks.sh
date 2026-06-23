#!/bin/bash
# Run this once from your repo root to install the pre-push hook:
#   bash scripts/install-hooks.sh

HOOK_DIR="$(git rev-parse --git-dir)/hooks"
HOOK_FILE="$HOOK_DIR/pre-push"

cat > "$HOOK_FILE" << 'HOOK'
#!/bin/bash
# pre-push hook: stamps the current ISO datetime (with timezone offset) into
# the `date:` field of any posts/*.md files that are staged or modified.

set -e

# Get current time as ISO 8601 with local timezone offset, e.g. 2026-06-22T15:30:00+09:00
NOW=$(date +"%Y-%m-%dT%H:%M:%S%z" | sed 's/\([+-][0-9][0-9]\)\([0-9][0-9]\)$/\1:\2/')

# Find all posts/*.md files that are tracked and modified (staged or unstaged)
CHANGED=$(git diff --name-only HEAD -- 'posts/*.md' 2>/dev/null)
STAGED=$(git diff --cached --name-only -- 'posts/*.md' 2>/dev/null)
FILES=$(echo -e "$CHANGED\n$STAGED" | sort -u | grep -v '^$' || true)

# Also catch brand-new (untracked) files that were just added
NEW=$(git ls-files --others --exclude-standard 'posts/*.md' 2>/dev/null || true)
FILES=$(echo -e "$FILES\n$NEW" | sort -u | grep -v '^$' || true)

if [ -z "$FILES" ]; then
  exit 0
fi

AMENDED=0
for FILE in $FILES; do
  [ -f "$FILE" ] || continue

  if grep -q '^date:' "$FILE"; then
    # Replace existing date line
    sed -i.bak "s|^date:.*|date: $NOW|" "$FILE" && rm -f "$FILE.bak"
  else
    # Insert date after the opening --- if no date field exists yet
    sed -i.bak "0,/^---/{/^---/!b; /^---/{n; s|^|date: $NOW\n|;}}" "$FILE" && rm -f "$FILE.bak"
  fi

  git add "$FILE"
  AMENDED=1
  echo "  ✓ Stamped $FILE → $NOW"
done

if [ "$AMENDED" = "1" ]; then
  echo "[pre-push] Updated date fields. Amending commit..."
  git commit --amend --no-edit --no-verify -q
fi

exit 0
HOOK

chmod +x "$HOOK_FILE"
echo "✓ pre-push hook installed at $HOOK_FILE"
