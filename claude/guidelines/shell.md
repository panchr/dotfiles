# Shell Guidelines (Google Shell Style Guide + ShellCheck)

Summary from Google Shell Style Guide (abridged):
- Use `#!/usr/bin/env bash` (or `#!/bin/bash`) and avoid `sh` for Bash features.
- Prefer `[[ ... ]]` and `(( ... ))` over `[ ... ]` and `expr`.
- Quote variables unless you intentionally want word splitting or globbing.
- Use arrays for lists of items instead of string concatenation.
- Prefer `$(...)` for command substitution (avoid backticks).
- Use `set -euo pipefail` carefully; understand its impact on pipelines and conditionals.
- Indent with 2 spaces; keep lines reasonably short and readable.
- Use `readonly` for constants and `local` for function variables.
- Functions should be `lower_snake_case` and use `main` entry points when appropriate.
- Prefer `printf` over `echo` for predictable output.

First step:
- Run `shellcheck` on changed shell scripts and address findings.

Focus on:
- Correct quoting and safe word splitting.
- Safe handling of filenames with spaces and glob characters.
- Robust error handling and exit codes.
- Avoiding subshells and forks in hot paths.
- Consistent, readable structure and naming.

Always flag:
- Unquoted variables used in paths or arguments.
- `rm -rf` without obvious safeguards.
- Reliance on `echo` for non-trivial output or escape sequences.
- Parsing `ls` output.
- `for f in $(...)` loops over filenames.
- Unchecked command failures or ignored exit codes.
- `set -e` used without understanding its pitfalls in conditionals/pipelines.

Examples (always flag):

- Unquoted variable:

```bash
cp $src $dest
```

- Parsing ls:

```bash
for f in $(ls *.txt); do
  echo "$f"
done
```

- Unsafe rm:

```bash
rm -rf $target_dir
```

Examples:

- Quote variables:

```bash
cp "$src" "$dest"
```

- Safe file loop:

```bash
while IFS= read -r -d '' file; do
  echo "$file"
done < <(find . -type f -name '*.txt' -print0)
```
