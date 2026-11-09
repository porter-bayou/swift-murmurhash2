import MurmurHash2
import Testing

struct MurmurHash2Tests {
    // Literal results from an independent Python implementation of MurmurHash2.
    @Test("Unsigned mixing and all tail lengths match reference vectors", arguments: [
        ([UInt8](), UInt32(1_540_447_798)),
        ([0x61], 626_045_324),
        ([0x61, 0x62], 1_692_487_918),
        ([0x61, 0x62, 0x63], 1_621_425_345),
        ([0xFF], 3_535_690_993),
        ([0xFF, 0x80, 0x00, 0xFE, 0x81, 0x0B, 0x0C], 714_862_353),
        (Array(repeating: 0xFF, count: 32), 1_880_074_102),
        ([0x20, 0x09, 0x0D, 0x0A], 2_567_189_666),
    ] as [([UInt8], UInt32)])
    func vectors(bytes: [UInt8], expected: UInt32) {
        var hasher = MurmurHash2(byteCount: UInt32(bytes.count), seed: 1)
        hasher.update(bytes)
        #expect(hasher.finalize() == expected)
    }

    @Test("The supplied seed controls the digest", arguments: [
        (UInt32(0), UInt32(3_848_350_155)),
        (UInt32(1), UInt32(2_788_266_382)),
        (UInt32.max, UInt32(2_478_023_965)),
    ])
    func seeds(seed: UInt32, expected: UInt32) {
        var hasher = MurmurHash2(byteCount: 5, seed: seed)
        hasher.update("hello".utf8)
        #expect(hasher.finalize() == expected)
    }

    @Test("Chunk boundaries do not change byte order or partial words", arguments: [1, 2, 3, 4, 5, 63, 64, 65, 256])
    func chunks(size: Int) {
        let bytes = Array(UInt8.min ... UInt8.max) + [0x61, 0x62, 0x63]
        var hasher = MurmurHash2(byteCount: UInt32(bytes.count), seed: 1)
        for start in stride(from: 0, to: bytes.count, by: size) {
            hasher.update(bytes[start ..< min(start + size, bytes.count)])
        }
        #expect(hasher.finalize() == 1_237_929_168)
    }
}
