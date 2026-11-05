#!/usr/bin/env bash
#
# Build treesitter parsers for Neovim's native treesitter support.
# nvim-treesitter was archived (April 2026); this replaces its :TSInstall.
#
# Requires: tree-sitter CLI (cargo install tree-sitter-cli), a C compiler, git.
#
# Usage:
#   ./install-parsers.sh          # install/update all parsers
#   ./install-parsers.sh ruby go  # install/update specific parsers
#
# Parsers land in ~/.local/share/nvim/site/parser/<lang>.so.
# Highlight queries are vendored in nvim/queries (must match the grammar
# revision reasonably well — bump revisions here and re-vendor queries together).

set -euo pipefail

PARSER_DIR="$HOME/.local/share/nvim/site/parser"
BUILD_DIR="$(mktemp -d)"
trap 'rm -rf "$BUILD_DIR"' EXIT

# lang|repo|revision|subdirectory (revisions from nvim-treesitter's last lockfile)
PARSERS='
bash|https://github.com/tree-sitter/tree-sitter-bash|a06c2e4415e9bc0346c6b86d401879ffb44058f7|
c|https://github.com/tree-sitter/tree-sitter-c|ae19b676b13bdcc13b7665397e6d9b14975473dd|
cpp|https://github.com/tree-sitter/tree-sitter-cpp|8b5b49eb196bec7040441bee33b2c9a4838d6967|
css|https://github.com/tree-sitter/tree-sitter-css|dda5cfc5722c429eaba1c910ca32c2c0c5bb1a3f|
go|https://github.com/tree-sitter/tree-sitter-go|2346a3ab1bb3857b48b29d779a1ef9799a248cd7|
graphql|https://github.com/bkegley/tree-sitter-graphql|5e66e961eee421786bdda8495ed1db045e06b5fe|
hcl|https://github.com/MichaHoffmann/tree-sitter-hcl|64ad62785d442eb4d45df3a1764962dafd5bc98b|
html|https://github.com/tree-sitter/tree-sitter-html|73a3947324f6efddf9e17c0ea58d454843590cc0|
javascript|https://github.com/tree-sitter/tree-sitter-javascript|58404d8cf191d69f2674a8fd507bd5776f46cb11|
json|https://github.com/tree-sitter/tree-sitter-json|001c28d7a29832b06b0e831ec77845553c89b56d|
liquid|https://github.com/hankthetank27/tree-sitter-liquid|9566ca79911052919fce09d26f1f655b5e093857|
lua|https://github.com/tree-sitter-grammars/tree-sitter-lua|10fe0054734eec83049514ea2e718b2a56acd0c9|
markdown|https://github.com/tree-sitter-grammars/tree-sitter-markdown|f969cd3ae3f9fbd4e43205431d0ae286014c05b5|tree-sitter-markdown
markdown_inline|https://github.com/tree-sitter-grammars/tree-sitter-markdown|f969cd3ae3f9fbd4e43205431d0ae286014c05b5|tree-sitter-markdown-inline
nginx|https://github.com/opa-oz/tree-sitter-nginx|47ade644d754cce57974aac44d2c9450e823d4f4|
python|https://github.com/tree-sitter/tree-sitter-python|v0.25.0|
rbs|https://github.com/joker1007/tree-sitter-rbs|5282e2f36d4109f5315c1d9486b5b0c2044622bb|
regex|https://github.com/tree-sitter/tree-sitter-regex|b2ac15e27fce703d2f37a79ccd94a5c0cbe9720b|
ruby|https://github.com/tree-sitter/tree-sitter-ruby|ad907a69da0c8a4f7a943a7fe012712208da6dee|
rust|https://github.com/tree-sitter/tree-sitter-rust|77a3747266f4d621d0757825e6b11edcbf991ca5|
scss|https://github.com/serenadeai/tree-sitter-scss|c478c6868648eff49eb04a4df90d703dc45b312a|
slim|https://github.com/theoo/tree-sitter-slim|a06113f5175b805a37d20df0a6f9d722e0ab6cfe|
sql|https://github.com/derekstride/tree-sitter-sql|851e9cb257ba7c66cc8c14214a31c44d2f1e954e|
terraform|https://github.com/MichaHoffmann/tree-sitter-hcl|64ad62785d442eb4d45df3a1764962dafd5bc98b|dialects/terraform
toml|https://github.com/tree-sitter-grammars/tree-sitter-toml|64b56832c2cffe41758f28e05c756a3a98d16f41|
tsx|https://github.com/tree-sitter/tree-sitter-typescript|75b3874edb2dc714fb1fd77a32013d0f8699989f|tsx
typescript|https://github.com/tree-sitter/tree-sitter-typescript|75b3874edb2dc714fb1fd77a32013d0f8699989f|typescript
yaml|https://github.com/tree-sitter-grammars/tree-sitter-yaml|4463985dfccc640f3d6991e3396a2047610cf5f8|
'

mkdir -p "$PARSER_DIR"

requested=("$@")

build_parser() {
  local lang="$1" url="$2" rev="$3" subdir="$4"
  local repo_dir="$BUILD_DIR/$lang"

  echo "==> $lang ($url @ $rev)"
  git init -q "$repo_dir"
  git -C "$repo_dir" fetch -q --depth 1 "$url" "$rev"
  git -C "$repo_dir" checkout -q FETCH_HEAD

  local src_dir="$repo_dir/${subdir:+$subdir}"
  if [ ! -f "$src_dir/src/parser.c" ]; then
    (cd "$src_dir" && tree-sitter generate)
  fi
  (cd "$src_dir" && tree-sitter build --output "$PARSER_DIR/$lang.so")
  echo "    installed $PARSER_DIR/$lang.so"
}

failed=()
while IFS='|' read -r lang url rev subdir; do
  [ -z "$lang" ] && continue
  if [ "${#requested[@]}" -gt 0 ]; then
    case " ${requested[*]} " in
      *" $lang "*) ;;
      *) continue ;;
    esac
  fi
  build_parser "$lang" "$url" "$rev" "$subdir" || failed+=("$lang")
done <<<"$PARSERS"

if [ "${#failed[@]}" -gt 0 ]; then
  echo "FAILED: ${failed[*]}" >&2
  exit 1
fi
echo "Done."
