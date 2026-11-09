/// Incremental, little-endian, 32-bit MurmurHash2.
///
/// This is a noncryptographic hash. Do not use it for authentication, integrity
/// verification against an adversary, or hashing attacker-controlled dictionary keys.
/// Input bytes are hashed exactly as supplied; no normalization is performed.
public struct MurmurHash2: Sendable {
    private static let multiplier: UInt32 = 0x5BD1_E995
    private var hash: UInt32
    private var word: UInt32 = 0
    private var filled = 0

    /// Begins hashing an input whose total length is already known.
    ///
    /// - Parameters:
    ///   - byteCount: Total input length modulo 2^32, before any calls to `update`.
    ///   - seed: The MurmurHash2 seed.
    ///
    /// Feed exactly the declared number of bytes, modulo 2^32. MurmurHash2 mixes
    /// the length before its first block; unknown-length streams need a counting pass.
    public init(byteCount: UInt32, seed: UInt32) {
        hash = seed ^ byteCount
    }

    /// Feeds the next bytes without buffering or copying the input sequence.
    ///
    /// - Parameter bytes: The next input bytes, in their original order.
    public mutating func update(_ bytes: some Sequence<UInt8>) {
        for byte in bytes {
            word |= UInt32(byte) << (8 * filled)
            filled += 1
            if filled == 4 {
                word = word &* Self.multiplier
                word ^= word >> 24
                word = word &* Self.multiplier
                hash = (hash &* Self.multiplier) ^ word
                word = 0
                filled = 0
            }
        }
    }

    /// Returns the unsigned 32-bit digest of the bytes supplied so far.
    ///
    /// Call after supplying the declared input length. This does not mutate
    /// the accumulator and does not allocate storage.
    /// - Returns: The 32-bit MurmurHash2 digest.
    public func finalize() -> UInt32 {
        var result = hash
        if filled > 0 { result = (result ^ word) &* Self.multiplier }
        result ^= result >> 13
        result = result &* Self.multiplier
        result ^= result >> 15
        return result
    }
}
