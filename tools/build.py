#!/usr/bin/env python3
"""Build the byte-exact ZX Spectrum micro-PROLOG interpreter and TAP."""
from __future__ import annotations

import argparse
import hashlib
import shutil
import subprocess
from pathlib import Path

from taplib import encode_tap, parse_tap, with_payload

ROOT = Path(__file__).resolve().parents[1]
SOURCE = ROOT / "src" / "prolog.asm"
REFERENCE_TAP = ROOT / "tapes" / "micro-PROLOG.tap"
BUILD_DIR = ROOT / "build"

PCODE_ORIGIN = 0x6000
PCODE_LENGTH = 14_200
PCODE_END = PCODE_ORIGIN + PCODE_LENGTH - 1
PCODE_SHA256 = "35cb4bde74ddbfe75875bdfa339e18a7fdf320526f31d2dbcb0862271b5b7174"
TAP_SHA256 = "a9908f53eaecc51144e9f059833e7e55f5c7e06ca3c3c512833bf409b4de0d86"
PCODE_TAP_BLOCK_INDEX = 5


def sha256_bytes(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def require_program(name: str) -> None:
    if shutil.which(name) is None:
        raise SystemExit(f"required assembler not found: {name}")


def choose_assembler(requested: str) -> str:
    if requested != "auto":
        require_program(requested)
        return requested
    for name in ("z80asm", "pasmo"):
        if shutil.which(name):
            return name
    raise SystemExit("install either z80asm or pasmo")


def assemble(assembler: str, output: Path) -> bytes:
    output.parent.mkdir(parents=True, exist_ok=True)
    if assembler == "z80asm":
        command = ["z80asm", "-o", str(output), str(SOURCE)]
    elif assembler == "pasmo":
        command = ["pasmo", "--bin", str(SOURCE), str(output)]
    else:
        raise ValueError(f"unsupported assembler: {assembler}")

    subprocess.run(command, cwd=ROOT, check=True)
    image = output.read_bytes()
    if len(image) != PCODE_LENGTH:
        raise SystemExit(
            f"wrong interpreter size: {len(image)} bytes; expected {PCODE_LENGTH}"
        )
    digest = sha256_bytes(image)
    if digest != PCODE_SHA256:
        raise SystemExit(
            "interpreter differs from the original image:\n"
            f"  generated: {digest}\n"
            f"  expected:  {PCODE_SHA256}"
        )
    return image


def rebuild_tap(image: bytes, output: Path) -> bytes:
    blocks = parse_tap(REFERENCE_TAP)
    if len(blocks) <= PCODE_TAP_BLOCK_INDEX:
        raise SystemExit("reference TAP does not contain the interpreter block")

    rebuilt = list(blocks)
    rebuilt[PCODE_TAP_BLOCK_INDEX] = with_payload(
        rebuilt[PCODE_TAP_BLOCK_INDEX], image
    )
    tap = encode_tap(rebuilt)
    output.write_bytes(tap)

    digest = sha256_bytes(tap)
    if digest != TAP_SHA256 or tap != REFERENCE_TAP.read_bytes():
        raise SystemExit(
            "rebuilt TAP differs from the original distribution tape:\n"
            f"  generated: {digest}\n"
            f"  expected:  {TAP_SHA256}"
        )
    return tap


def build_one(assembler: str, stem: str) -> tuple[bytes, bytes, Path, Path]:
    bin_path = BUILD_DIR / f"{stem}.bin"
    tap_path = BUILD_DIR / f"{stem}.tap"
    image = assemble(assembler, bin_path)
    tap = rebuild_tap(image, tap_path)
    return image, tap, bin_path, tap_path


def normal_build(requested: str) -> None:
    assembler = choose_assembler(requested)
    image, _tap, temporary_bin, temporary_tap = build_one(assembler, "micro-PROLOG")

    # Give the interpreter image a descriptive companion filename as well.
    pcode_path = BUILD_DIR / "pcode.bin"
    pcode_path.write_bytes(image)

    print(f"assembler: {assembler}")
    print(f"image:     0x{PCODE_ORIGIN:04X}-0x{PCODE_END:04X} ({len(image)} bytes)")
    print(f"binary:    {pcode_path.relative_to(ROOT)}")
    print(f"TAP:       {temporary_tap.relative_to(ROOT)}")
    print(f"SHA-256:   {PCODE_SHA256}")

    # The temporary binary name is redundant with pcode.bin.
    temporary_bin.unlink(missing_ok=True)


def verify_all() -> None:
    for assembler in ("z80asm", "pasmo"):
        require_program(assembler)

    z_image, z_tap, z_bin, z_tap_path = build_one("z80asm", "micro-PROLOG-z80asm")
    p_image, p_tap, p_bin, p_tap_path = build_one("pasmo", "micro-PROLOG-pasmo")

    if z_image != p_image:
        raise SystemExit("z80asm and pasmo generated different interpreter images")
    if z_tap != p_tap:
        raise SystemExit("z80asm and pasmo generated different TAP files")

    (BUILD_DIR / "pcode.bin").write_bytes(z_image)
    (BUILD_DIR / "micro-PROLOG.tap").write_bytes(z_tap)

    print("verified byte-exact output with z80asm and pasmo")
    print(f"binary: {z_bin.relative_to(ROOT)} = {p_bin.relative_to(ROOT)}")
    print(f"TAP:    {z_tap_path.relative_to(ROOT)} = {p_tap_path.relative_to(ROOT)}")
    print(f"SHA-256: {PCODE_SHA256}")


def main() -> int:
    parser = argparse.ArgumentParser(
        description="Build the byte-exact Sinclair ZX Spectrum micro-PROLOG TAP"
    )
    parser.add_argument(
        "--assembler",
        choices=("auto", "z80asm", "pasmo"),
        default="auto",
        help="assembler used for a normal build (default: first one installed)",
    )
    parser.add_argument(
        "--verify-all",
        action="store_true",
        help="build with both assemblers and compare their outputs",
    )
    args = parser.parse_args()

    BUILD_DIR.mkdir(exist_ok=True)
    if args.verify_all:
        verify_all()
    else:
        normal_build(args.assembler)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
