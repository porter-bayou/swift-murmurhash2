# swift-murmurhash2

A memory-safe Swift implementation of little-endian, 32-bit MurmurHash2.
One library target, no dependencies, Foundation, file access, network access,
subprocesses or package plugins. Requires Swift 6.2 or newer.

MurmurHash2 is **not cryptographic**. Do not use it for authentication,
adversarial integrity checking or attacker-controlled dictionary keys.

## Use

Add the package and its library product:

```swift
.package(url: "https://github.com/porter-bayou/swift-murmurhash2.git", from: "1.0.0")
// In the consuming target's dependencies:
.product(name: "MurmurHash2", package: "swift-murmurhash2")
```

```swift
import MurmurHash2

var hasher = MurmurHash2(byteCount: 5, seed: 1)
hasher.update("hel".utf8)
hasher.update("lo".utf8)
let fingerprint = hasher.finalize() // 2788266382
```

The length must be known before hashing: supply the total byte count modulo
2^32, and then feed those bytes in order. Chunk boundaries do not affect the
result. The accumulator retains at most one partial four-byte word, not its
input. `finalize()` returns a digest without changing the accumulator.

Normalization is the caller's responsibility. For CurseForge, the caller removes
ASCII bytes 9, 10, 13 and 32 and uses seed 1; the declared length is the length
**after** filtering. Unknown-length inputs require a counting pass or buffering.

## Development

```sh
swift test
swift build -c release
```

Algorithm correctness belongs here: tests cover independent known-answer
vectors, seeds, unsigned overflow, tails and chunk boundaries. Consumers should
test their integration rather than duplicate these algorithm tests.

GitHub Actions is disabled for this repository. Any future CI must be isolated
from organization infrastructure and credentials before it is enabled.

## License

MIT. See [LICENSE](LICENSE).
