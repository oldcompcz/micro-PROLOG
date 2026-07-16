#!/usr/bin/env python3
"""Small helpers for Sinclair .TAP block parsing and rebuilding."""
from __future__ import annotations

from dataclasses import dataclass
from pathlib import Path
from typing import Iterable


@dataclass(frozen=True)
class TapBlock:
    index: int
    file_offset: int
    data: bytes  # flag + payload + XOR checksum

    @property
    def flag(self) -> int:
        return self.data[0]

    @property
    def payload(self) -> bytes:
        return self.data[1:-1]

    @property
    def checksum(self) -> int:
        return self.data[-1]

    @property
    def checksum_ok(self) -> bool:
        value = 0
        for byte in self.data:
            value ^= byte
        return value == 0

    @property
    def is_standard_header(self) -> bool:
        return len(self.data) == 19 and self.flag == 0x00

    def header_fields(self) -> dict[str, int | str] | None:
        if not self.is_standard_header:
            return None
        payload = self.payload
        return {
            "type": payload[0],
            "name": payload[1:11].decode("latin-1"),
            "length": int.from_bytes(payload[11:13], "little"),
            "parameter1": int.from_bytes(payload[13:15], "little"),
            "parameter2": int.from_bytes(payload[15:17], "little"),
        }


def parse_tap(path: str | Path) -> list[TapBlock]:
    raw = Path(path).read_bytes()
    blocks: list[TapBlock] = []
    pos = 0
    while pos < len(raw):
        if pos + 2 > len(raw):
            raise ValueError(f"truncated length field at offset {pos}")
        file_offset = pos
        size = int.from_bytes(raw[pos : pos + 2], "little")
        pos += 2
        if size < 2 or pos + size > len(raw):
            raise ValueError(f"invalid TAP block length {size} at offset {file_offset}")
        data = raw[pos : pos + size]
        pos += size
        blocks.append(TapBlock(len(blocks), file_offset, data))
    return blocks


def with_payload(block: TapBlock, payload: bytes, flag: int | None = None) -> TapBlock:
    actual_flag = block.flag if flag is None else flag
    body = bytes([actual_flag]) + payload
    checksum = 0
    for byte in body:
        checksum ^= byte
    return TapBlock(block.index, block.file_offset, body + bytes([checksum]))


def encode_tap(blocks: Iterable[TapBlock]) -> bytes:
    out = bytearray()
    for block in blocks:
        out += len(block.data).to_bytes(2, "little")
        out += block.data
    return bytes(out)
