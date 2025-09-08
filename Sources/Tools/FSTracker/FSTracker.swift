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
    enum Errors: Error {
        case cantCreateStream
        case cantHandleDirectory(String)
        case cantRecognizePaths
        case cantStartTracking
        case cantStopTracking
    }

    public var onReceive: (([FSEvent]) -> Void)?
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
        try? stop()
    }
}

// MARK: - Public
public extension FSTracker {
    func start() throws {
        try checkPaths()
        try configure()

        guard let eventStream else {
            Log.error("Cant start! FS event stream is unexist")
            throw Errors.cantStartTracking
        }

        FSEventStreamSetDispatchQueue(eventStream, queue)
        FSEventStreamStart(eventStream)
        isTracking = true

        Log.success("FS tracking started")
    }

    func stop() throws {
        isTracking = false
        guard let eventStream else {
            Log.error("Cant stop! FS event stream ins't found")
            throw Errors.cantStopTracking
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
    /// Should be with passUnretained because ARC is unavailable here
    func configure() throws {
        let unretainedSelf = Unmanaged.passUnretained(self).toOpaque()
        let unretainedSelfPointer = UnsafeMutableRawPointer(unretainedSelf)

        var context = buildEventStreamContext(with: unretainedSelfPointer)
        eventStream = try buildEventStreamReference(with: &context)
    }

    /// Detect incorrect paths and report this
    func checkPaths() throws {
        let wrongPaths = paths.filter {
            var isDirectory = ObjCBool(true)
            let isDirectoryExist = FileManager.default.fileExists(
                atPath: $0,
                isDirectory: &isDirectory
            )
            return !isDirectoryExist
        }

        guard wrongPaths.isEmpty else {
            Log.error("Selected directories has wrong paths: \(wrongPaths)")
            throw Errors.cantHandleDirectory(wrongPaths.joined(separator: ", "))
        }
        Log.info("Prepare directories tracking: \(paths)")
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
    ) throws {
        let paths = unsafeBitCast(pathPointer, to: NSArray.self)
        guard let eventPaths = paths as? [String] else {
            Log.error("Cant retreive tracking paths")
            throw Errors.cantRecognizePaths
        }

        (0 ..< eventsCount).forEach {
            let path = eventPaths[$0]
            let flags = eventFlags[$0]
            let events = FSFlags.parse(flags)

            onReceive?(events)
            Log.debug("Changes tracked: \(path)\nEvents: \(events.map { $0.text })")
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

    /// C-based callback with tracking process ⚠️
    func buildProcessCallback() throws -> FSEventStreamCallback {
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

            try? unretainedSelf.process(
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
    ) throws -> FSEventStreamRef? {
        let processCallback = try buildProcessCallback()
        let eventStream = FSEventStreamCreate(
            kCFAllocatorDefault,
            processCallback,
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

        guard let eventStream else {
            Log.warning("Failed to create FSEventStream")
            throw Errors.cantCreateStream
        }

        return eventStream
    }
}
