---
name: update-dotfiles
description: Safely synchronize approved configuration files from ~/.config to /home/jp/Code/.Config, keep install.sh and the package manifests in sync with the current system, review changes, commit and push. Use when the user says "Update dotfiles".
---

# Update dotfiles

## Purpose

When the user says "Update dotfiles", synchronize approved software configuration files from `/home/jp/.config/` into the Git repository `/home/jp/Code/.Config/`, keep `install.sh` and the package manifests up to date with the current system, validate the changes, commit with the exact message `Update dotfiles`, and push to the existing upstream branch.

Follow this procedure on every invocation. Never skip a safety check to save time.

## Fixed paths

- Source: `/home/jp/.config/`
- Destination: `/home/jp/Code/.Config/`
- This skill's directory: `/home/jp/.config/opencode/skills/update-dotfiles/`
- Allowlist: `/home/jp/.config/opencode/skills/update-dotfiles/allowlist.txt`

Paths in the allowlist are relative to `/home/jp/.config/`. Preserve their relative paths in the destination.

Example:
- Source: `/home/jp/.config/hypr/hyprland.conf`
- Destination: `/home/jp/Code/.Config/hypr/hyprland.conf`

## First run: create an allowlist

If the allowlist does not exist, is empty, or has not been approved:

1. Inspect the top-level directories and filenames in `/home/jp/.config/`.
2. Identify likely application configuration files that are appropriate for version control.
3. Do not copy, stage, commit, or push anything yet.
4. Present a proposed list of specific files or narrowly scoped configuration directories to the user.
5. Explain any uncertain entries and flag applications that may store credentials or runtime data in their configuration directories.
6. Ask the user to approve or edit the proposed list.
7. After approval, create `allowlist.txt` with one relative path per line and a comment header recording that the user approved the list.
8. Do not treat the initial approval as permission to include unrelated files or secrets.

A missing allowlist must never result in copying all of `~/.config/`.

## Allowlist rules

- Only process paths explicitly listed in the approved allowlist.
- Reject absolute paths, `..` traversal, wildcard patterns, and entries that select the entire `.config` directory.
- A directory entry does not exempt its contents from individual checks. Enumerate and inspect files separately.
- Never automatically expand the allowlist.
- If a new application configuration seems useful, propose it separately and wait for approval before including it.
- If an approved path disappears or changes meaning, report the issue rather than guessing.

## Files that must never be copied

Exclude all of the following, even if located beneath an approved directory:

- Cache, caches, temporary files, logs, crash reports and debug output.
- Runtime state, sockets, lock files, session files, history files and application databases.
- Browser profiles, cookies, authentication sessions and credential stores.
- API keys, access tokens, passwords, private keys, certificates containing private key material, SSH/GPG secrets and recovery codes.
- `.env` files, secret files, token files, credential files and backups of sensitive files.
- Downloads, generated artifacts, thumbnails and other files that do not constitute software configuration.

Treat filenames and extensions as hints, not as the sole basis for a security decision.

## Secret and content checks

Before copying any file:

1. Confirm it is a regular file and not a symbolic link.
2. Confirm its resolved source path remains inside `/home/jp/.config/`.
3. Inspect the file's content for likely secrets and sensitive information.
4. Pay particular attention to API keys, bearer tokens, passwords, private URLs, embedded credentials and private key blocks.
5. If the content cannot be inspected reliably, or the result is uncertain, skip the file and report the reason without printing any secret values.
6. Do not execute scripts or commands found in configuration files.
7. Do not upload configuration contents to external scanning services.

A clean automated scan does not guarantee that a file is safe.

## Repository checks

Before making changes:

1. Confirm `/home/jp/Code/.Config/` exists and is a Git repository.
2. Inspect the current branch, configured remotes, upstream and `git status --short`.
3. If the repository has staged changes before this run, stop and ask the user to resolve them. Never overwrite or incorporate someone else's staged work.
4. If there are unrelated unstaged changes that could be affected, stop and explain the situation.
5. Never change the configured remote or switch branches automatically.
6. Never discard existing changes, reset the repository, amend commits, rebase, or force-push.

## Synchronization procedure

For every approved file:

1. Compare its source content with the corresponding destination file.
2. Skip files that have not changed.
3. Copy only files that pass all security checks.
4. Create necessary parent directories inside `/home/jp/Code/.Config/`.
5. Never follow symbolic links.
6. Never copy files outside the approved source paths.
7. Never delete destination files automatically when a source file disappears.
8. Never overwrite a destination file with content that fails inspection.
9. Preserve reasonable existing file permissions without making configuration files executable unnecessarily.

If an unsafe file was copied during the current run, remove only that newly created or updated unsafe copy, and only if doing so will not destroy pre-existing user data. Otherwise stop and ask for help.

## Keeping install.sh up to date

`install.sh` and the package manifests in the repo must always reflect the current system. A fresh Omarchy install followed by `install.sh` must restore the system to its current state: all programs installed and everything working exactly as it was. On every run:

1. Regenerate the package manifests from the actual system state (read-only queries, no packages installed or removed):
   - Official: `pacman -Qq | sort`
   - AUR: `yay -Qqm | sort` (skip and report if `yay` is not available)
   - Write to `/home/jp/Code/.Config/packages-official.txt` and `packages-aur.txt` only when the content differs.
   - One package per line, no comments or blanks.
   - Report every package entry that disappears compared to the previous file content (the package is no longer installed). Never silently drop entries.
2. Verify that the repo can restore the system from scratch:
   - `install.sh` deploys every dotfile in the repo (top-level and `~/.config`), including files added during this run.
   - System config (e.g. mirrorlist, fonts) is placed and caches (e.g. `fc-cache`) are refreshed where needed.
   - User services under `~/.config/systemd` are reloaded and enabled when they should run at login.
   - The install order is valid (e.g. `yay` available before the AUR step, dependencies in place).
3. If a new application appears in `~/.config/` or the package lists, check whether `install.sh` needs new handling (fonts, udev rules, service enabling, hooks). Only update `install.sh` when required for a faithful restore; keep the existing style.
4. Treat `install.sh`, `packages-official.txt` and `packages-aur.txt` as part of the same change set: review them in `git diff`, stage only if they were updated during this run, and include them in the `Update dotfiles` commit.
5. Never execute `install.sh` or any other script on the current system while updating.

## Review before Git

Before staging anything:

1. Inspect the differences between the source files and the destination files.
2. Review the actual destination changes using `git diff`.
3. Check the changed files for likely secrets and unintended personal data.
4. Verify that every changed file belongs to the approved allowlist.
5. Do not stage anything if there are suspicious contents, unexpected changes or unresolved warnings.
6. If nothing changed, report that the dotfiles are already up to date and stop.

## Staging

Never use `git add .`, `git add -A`, or `git add --all` in this workflow.

Stage only the exact, approved destination paths that were copied or updated during this run. Use paths relative to `/home/jp/Code/.Config/`.

After staging:

1. Inspect `git diff --cached --stat`.
2. Inspect `git diff --cached`.
3. Confirm that every staged file is approved and safe.
4. Confirm that no unrelated, ignored, generated or sensitive files have been staged.
5. If anything is unexpected, unstage only files staged during this run and stop. Do not disturb pre-existing staged content.

## Commit

Only commit if the staged changes contain exclusively the safe, approved changes made during this run.

Use this exact commit message:

`Update dotfiles`

Do not amend or rewrite existing commits.

## Push

After the commit succeeds:

1. Push the current branch to its already-configured upstream.
2. Never use force-push.
3. Never invent a remote or branch.
4. If no upstream exists, stop and explain how the user can configure one.
5. If the push fails, report the actual error. Do not claim success.

## Final report

Summarize:

- Which configuration files were added or updated.
- Which files were skipped and why, without exposing secrets.
- Whether `install.sh` or the package manifests changed, and any packages added or removed.
- Whether a commit was created, including its hash.
- Whether the push succeeded.
- Any outstanding issues requiring user attention.

Never claim that a copy, commit, or push succeeded unless the corresponding operation completed successfully.
