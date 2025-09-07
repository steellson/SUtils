//  Created by Andrew Steellson on 07.09.2025.
//

import Log
import Foundation
import CoreServices

/// `` ☩ ☩ ☩ ☩ ☩ ☩ ☩ ☩ ☩ ☩ ``
/// `` ☩    FSTracker    ☩ ``
/// `` ☩ ☩ ☩ ☩ ☩ ☩ ☩ ☩ ☩ ☩ ``

/// Tracking target directories changes
/// Based on low level file system C-API
public final class FSTracker {
    public var isTracking: Bool = false

    private var eventStream: FSEventStreamRef?

    private let paths: [String]
    private let queue: DispatchQueue
    private let latency: CFTimeInterval

    public init(_ directories: [String]) {
        paths = directories
        queue = DispatchQueue(label: "com.sutils.fstracker")
        latency = CFTimeInterval(1.0)
    }

    deinit {
        stop()
    }
}

// MARK: - Public
public extension FSTracker {
    func start() {
        configure()
        guard let eventStream else { return }

        FSEventStreamSetDispatchQueue(eventStream, queue)
        FSEventStreamStart(eventStream)
        isTracking = true

        Log.success("FS tracking started for directories: \(paths)")
    }

    func stop() {
        isTracking = false
        guard let eventStream else {
            Log.error("FS event stream ins't found")
            return
        }

        FSEventStreamStop(eventStream)
        FSEventStreamInvalidate(eventStream)
        FSEventStreamRelease(eventStream)

        self.eventStream = nil

        Log.info("FS tracking stopped")
    }
}

// MARK: - Process
private extension FSTracker {
    /// Initial configuration with context
    /// Should be with passUnretained because of C-Api (with no ARC)
    func configure() {
        let unretainedSelf = Unmanaged.passUnretained(self).toOpaque()
        let unretainedSelfPointer = UnsafeMutableRawPointer(unretainedSelf)

        var context = buildEventStreamContext(with: unretainedSelfPointer)
        eventStream = buildEventStreamReference(with: &context)
    }
    
    /// Tracking process, will be executed into `FSEventStreamCallback`
    /// - Parameters:
    ///   - pathPointer: Directory pointer
    ///   - eventFlags: UInt32 system required flats
    ///   - eventsCount: Number of received events
    func process(
        pathPointer: UnsafeMutableRawPointer,
        eventFlags: UnsafePointer<FSEventStreamEventFlags>,
        eventsCount: Int
    ) {
        let paths = unsafeBitCast(pathPointer, to: NSArray.self)
        guard let eventPaths = paths as? [String] else {
            Log.error("Cant retreive tracking paths")
            return
        }

        (0 ..< eventsCount).forEach {
            let path = eventPaths[$0]
            let flag = eventFlags[$0]

            Log.debug("[\(flag)] Changes tracked: \(path)")
        }
    }
}

// MARK: - Building
private extension FSTracker {
    /// Create context with properties
    /// - Parameter unretainedSelf: Because `weak self` is unavailable
    /// - Returns: Required stream context
    func buildEventStreamContext(
        with unretainedSelf: UnsafeMutableRawPointer
    ) -> FSEventStreamContext {
        return FSEventStreamContext(
            version: .zero,
            info: unretainedSelf,
            retain: nil,
            release: nil,
            copyDescription: nil
        )
    }

    func buildProcessCallback() -> FSEventStreamCallback {
        return { (
            streamRef,
            clientCallBackInfo,
            eventsCount,
            eventPathsPointer,
            eventFlags,
            eventIds
        ) in
            guard let clientCallBackInfo else {
                Log.warning("FS client callback info is unexist")
                return
            }

            let unretainedSelf = Unmanaged<FSTracker>
                .fromOpaque(clientCallBackInfo)
                .takeUnretainedValue()

            unretainedSelf.process(
                pathPointer: eventPathsPointer,
                eventFlags: eventFlags,
                eventsCount: eventsCount
            )
        }
    }

    /// Try to create stream reference
    /// - Parameter context: Stream context with unretained `self`
    /// - Returns: Configured stream
    func buildEventStreamReference(
        with context: inout FSEventStreamContext
    ) -> FSEventStreamRef? {
        let eventStream = FSEventStreamCreate(
            kCFAllocatorDefault,
            buildProcessCallback(),
            &context,
            paths as CFArray,
            FSEventStreamEventId(kFSEventStreamEventIdSinceNow),
            latency,
            FSEventStreamCreateFlags(
                kFSEventStreamCreateFlagFileEvents |
                kFSEventStreamCreateFlagUseCFTypes |
                kFSEventStreamCreateFlagNoDefer
            )
        )

        if eventStream == nil {
            Log.warning("Failed to create FSEventStream")
        }

        return eventStream
    }
}
