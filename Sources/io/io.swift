
// Seek whence values.
// https://golang.org/pkg/io/#pkg-constants
public enum SeekMode: Int {
    case start, current, end
}

// Reader is the interface that wraps the basic read() method.
// https://golang.org/pkg/io/#Reader
public protocol Reader {
    /** Reads up to p.byteLength bytes into `p`. It resolves to the number
     * of bytes read (`0` <= `n` <= `p.byteLength`) and any error encountered.
     * Even if `read()` returns `n` < `p.byteLength`, it may use all of `p` as
     * scratch space during the call. If some data is available but not
     * `p.byteLength` bytes, `read()` conventionally returns what is available
     * instead of waiting for more.
     *
     * When `read()` encounters an error or end-of-file condition after
     * successfully reading `n` > `0` bytes, it returns the number of bytes read.
     * It may return the (non-nil) error from the same call or return the error
     * (and `n` == `0`) from a subsequent call. An instance of this general case
     * is that a `Reader` returning a non-zero number of bytes at the end of the
     * input stream may return either `err` == `EOF` or `err` == `null`. The next
     * `read()` should return `0`, `EOF`.
     *
     * Callers should always process the `n` > `0` bytes returned before
     * considering the `EOF`. Doing so correctly handles I/O errors that happen
     * after reading some bytes and also both of the allowed `EOF` behaviors.
     *
     * Implementations of `read()` are discouraged from returning a zero byte
     * count with a `null` error, except when `p.byteLength` == `0`. Callers
     * should treat a return of `0` and `null` as indicating that nothing
     * happened; in particular it does not indicate `EOF`.
     *
     * Implementations must not retain `p`.
     */
    func read(p: [UInt8]) -> (nread: Int, eof: Bool)
}

// Writer is the interface that wraps the basic write() method.
// https://golang.org/pkg/io/#Writer
public protocol Writer {
    /** Writes `p.byteLength` bytes from `p` to the underlying data
     * stream. It resolves to the number of bytes written from `p` (`0` <= `n` <=
     * `p.byteLength`) and any error encountered that caused the write to stop
     * early. `write()` must return a non-null error if it returns `n` <
     * `p.byteLength`. write() must not modify the slice data, even temporarily.
     *
     * Implementations must not retain `p`.
     */
    func write(p: [UInt8]) -> Int
}

// https://golang.org/pkg/io/#Closer
public protocol Closer {
    // The behavior of Close after the first call is undefined. Specific
    // implementations may document their own behavior.
    func close()
}

// https://golang.org/pkg/io/#Seeker
public protocol Seeker {
    /** Seek sets the offset for the next `read()` or `write()` to offset,
     * interpreted according to `whence`: `SeekStart` means relative to the start
     * of the file, `SeekCurrent` means relative to the current offset, and
     * `SeekEnd` means relative to the end. Seek returns the new offset relative
     * to the start of the file and an error, if any.
     *
     * Seeking to an offset before the start of the file is an error. Seeking to
     * any positive offset is legal, but the behavior of subsequent I/O operations
     * on the underlying object is implementation-dependent.
     */
    func seek(offset: Int, whence: SeekMode)
}

// https://golang.org/pkg/io/#ReadCloser
public protocol ReadCloser: Reader, Closer {}

// https://golang.org/pkg/io/#WriteCloser
public protocol WriteCloser: Writer, Closer {}

// https://golang.org/pkg/io/#ReadSeeker
public protocol ReadSeeker: Reader, Seeker {}

// https://golang.org/pkg/io/#WriteSeeker
public protocol WriteSeeker: Writer, Seeker {}

// https://golang.org/pkg/io/#ReadWriteCloser
public protocol ReadWriteCloser: Reader, Writer, Closer {}

// https://golang.org/pkg/io/#ReadWriteSeeker
public protocol ReadWriteSeeker: Reader, Writer, Seeker {}

/** Copies from `src` to `dst` until either `EOF` is reached on `src`
 * or an error occurs. It returns the number of bytes copied and the first
 * error encountered while copying, if any.
 *
 * Because `copy()` is defined to read from `src` until `EOF`, it does not
 * treat an `EOF` from `read()` as an error to be reported.
 */
// https://golang.org/pkg/io/#Copy
public func copy(dst: Writer, src: Reader) -> Int {
    var n = 0
    let b: [UInt8] = []
    var gotEOF = false
    while gotEOF == false {
        let result = src.read(p: b)
        if result.eof {
            gotEOF = true
        }
        n += dst.write(p: Array(b[0 ... result.nread]))
    }
    return n
}
