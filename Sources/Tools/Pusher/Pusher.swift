//  Created by Andrew Steellson on 18.05.2025.

import UserNotifications

/// `` ☩ ☩ ☩ ☩ ☩ ☩ ☩ ☩ ``
/// `` ☩   Pusher    ☩ ``
/// `` ☩ ☩ ☩ ☩ ☩ ☩ ☩ ☩ ``

public protocol Push {
    var title: String { get }
    var sound: String? { get }
    var subtitle: String? { get }
    var after: TimeInterval? { get }
}

// MARK: - Impl
public final class Pusher {
    private(set) var isAuthorized: Bool = false
    private let notifications: UNUserNotificationCenter

    public init() {
        notifications = UNUserNotificationCenter.current()
    }
}

// MARK: - Types
public extension Pusher {
    enum Errors: Error {
        case isNotAuthorized
    }
}

// MARK: - Public
public extension Pusher {
    /// Common request for system permissions
    /// - Returns: Is granged or not
    @discardableResult
    func requestPermissions() async throws -> Bool {
        isAuthorized = try await notifications.requestAuthorization(
            options: [.alert, .badge, .sound]
        )
        return isAuthorized
    }

    /// Send system-like notification
    /// Could be scheduled with interval
    /// - Parameter push: Conformed model
    func send(_ push: Push) throws {
        guard isAuthorized else {
            throw Errors.isNotAuthorized
        }

        let content = UNMutableNotificationContent()
        content.title = push.title
        if let subtitle = push.subtitle {
            content.subtitle =  subtitle
        }

        let sound = push.sound ?? "default"
        content.sound = UNNotificationSound(named: UNNotificationSoundName(sound))

        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: UNTimeIntervalNotificationTrigger(
                timeInterval: push.after ?? 1,
                repeats: false
            )
        )

        notifications.add(request)
    }
}
