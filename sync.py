#!/usr/bin/env python3
"""Apply selected chezmoi source changes to this machine."""

from __future__ import annotations

import argparse
import subprocess
from dataclasses import dataclass
from pathlib import Path


REPO_DIR = Path(__file__).resolve().parent


@dataclass(frozen=True)
class SyncItem:
    input_path: str
    source_path: Path
    target_path: Path


def run_chezmoi(args: list[str]) -> str:
    command = ["chezmoi", "-S", str(REPO_DIR), *args]
    try:
        result = subprocess.run(
            command,
            check=True,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            text=True,
        )
    except FileNotFoundError:
        raise SystemExit("chezmoi was not found on PATH") from None
    except subprocess.CalledProcessError as error:
        message = error.stderr.strip() or error.stdout.strip()
        raise SystemExit(f"{' '.join(command)} failed\n{message}") from None
    return result.stdout.strip()


def resolve_existing_path(raw_path: str) -> Path:
    return Path(raw_path).expanduser().resolve()


def is_inside_repo(path: Path) -> bool:
    try:
        path.relative_to(REPO_DIR)
    except ValueError:
        return False
    return True


def resolve_source_input(raw_path: str, source_path: Path) -> SyncItem:
    target = run_chezmoi(["target-path", str(source_path)])
    if not target:
        raise SystemExit(f"No chezmoi target found for source path: {raw_path}")
    return SyncItem(raw_path, source_path, Path(target).expanduser().resolve())


def resolve_target_input(raw_path: str) -> SyncItem:
    target_path = resolve_existing_path(raw_path)
    source = run_chezmoi(["source-path", str(target_path)])
    if not source:
        raise SystemExit(f"No chezmoi source found for target path: {raw_path}")

    source_path = Path(source).expanduser().resolve()
    if not is_inside_repo(source_path) or not source_path.exists():
        raise SystemExit(f"Target is not managed by this repo: {raw_path}")

    return SyncItem(raw_path, source_path, target_path)


def resolve_item(raw_path: str) -> SyncItem:
    candidate = resolve_existing_path(raw_path)
    if is_inside_repo(candidate):
        if not candidate.exists():
            raise SystemExit(f"Source path does not exist: {raw_path}")
        return resolve_source_input(raw_path, candidate)
    return resolve_target_input(raw_path)


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description=(
            "Apply selected files from this chezmoi source repo to their live "
            "targets. Pass either source paths in the repo or target paths in $HOME."
        ),
        epilog=(
            "Examples:\n"
            "  ./sync.py dot_config/ghostty/config.tmpl\n"
            "  ./sync.py ~/.config/ghostty/config\n"
            "  ./sync.py --dry-run dot_config/zsh/dot_zshrc.tmpl"
        ),
        formatter_class=argparse.RawDescriptionHelpFormatter,
    )
    parser.add_argument(
        "paths",
        nargs="+",
        help="chezmoi source paths or managed target paths to apply",
    )
    parser.add_argument(
        "-n",
        "--dry-run",
        action="store_true",
        help="show what would be applied without changing files",
    )
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    items = [resolve_item(path) for path in args.paths]

    for item in items:
        print(f"{item.source_path} -> {item.target_path}")

    command = [
        "chezmoi",
        "-S",
        str(REPO_DIR),
        "apply",
        "--force",
        *[str(item.target_path) for item in items],
    ]

    if args.dry_run:
        print("dry-run:", " ".join(command))
        return 0

    subprocess.run(command, check=True)
    return 0


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except subprocess.CalledProcessError as error:
        raise SystemExit(error.returncode) from None
