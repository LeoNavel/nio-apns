//
//  APNSNotificationItem.swift
//  NIOAPNS
//
// Edited:
//  author: Filip Klembara (filip@klembara.pro)
//  date:   2. Mar. 2020
//  modifications:
//      new structure HiddenEncodable
//      new enum APNSNotificationCustomItem
//      APNSNotification item
//          removed .custom
//          add asCustom property
//

struct HiddenEncodable: Encodable { }

///
public enum APNSNotificationCustomItem<T: Encodable> {
    /// The text of the alert message.
    ///
    /// - note: Payload key: `alert.body`
    case alertBody(String)

    /// A short string describing the purpose of the notification.
    ///
    /// - note: Payload key: `alert.title`
    case alertTitle(String)

    /// A title string from the `Localizable.strings` file for the current localization
    /// and the corresponding variables for format specifiers in the title string.
    ///
    /// - note: Payload key: `alert.title-loc-key`, `alert.title-loc-args`
    case alertTitleLoc(String, [String]?)

    /// Display an alert that includes the Close and View buttons.
    ///
    /// The string is used as a key to get a localized string in the current localization to use
    /// for the right button title instead of "View".
    ///
    /// - note: Payload key: `alert.action-loc-key`
    case alertActionLoc(String)

    /// An alert message from the `Localizable.strings` file for the current localization
    /// and the corresponding variables for format specifiers in the message string.
    ///
    /// - note: Payload key: `alert.loc-key`, `alert.loc-args`
    case alertLoc(String, [String]?)

    /// Display a different launch image instead of the default one.
    ///
    /// - note: Payload key: `alert.launch-image`
    case alertLaunchImage(String)

    /// Modify the badge of the app icon.
    ///
    /// If this key is not in the dictionary, the badge is not changed.
    ///
    /// To remove the badge, set the value of this key to `0`.
    ///
    /// - note: Payload key: `badge`
    case badge(Int)

    /// Play a sound.
    ///
    /// The value is the name of a sound file in the app's main bundle or in `Library/Sounds` folder of the app's data contianer.
    /// If the sound file cannot be found, or if you sepcify default for the value, the system plays the default alert sound.
    ///
    /// - note: Payload key: `sound`
    case sound(String)

    /// Wake up the app in the background and deliver the notification to it's app delegate.
    case contentAvailable

    /// Category representing the notification type.
    ///
    /// This value corresponds to the value in the `identifier` property of one of the app's registered categories.
    ///
    /// - note: Payload key: `category`
    case category(String)

    /// Group multiple notifications by using the same `threadId`.
    ///
    /// This key corresponds to the `threadIdentifier` property of the `UNNotificationContent` object.
    ///
    /// - note: Payload key: `thread-id`
    case threadId(String)

    /// Custom payload for the notification.
    case customPayload(String, T)

    /// Allow modification of the notification by a notification service app extension.
    ///
    /// - note: Payload key: `mutable-content`
    case mutableContent
}

/// 
public enum APNSNotificationItem {
    /// The text of the alert message.
    ///
    /// - note: Payload key: `alert.body`
    case alertBody(String)
    
    /// A short string describing the purpose of the notification.
    ///
    /// - note: Payload key: `alert.title`
    case alertTitle(String)
    
    /// A title string from the `Localizable.strings` file for the current localization
    /// and the corresponding variables for format specifiers in the title string.
    ///
    /// - note: Payload key: `alert.title-loc-key`, `alert.title-loc-args`
    case alertTitleLoc(String, [String]?)
    
    /// Display an alert that includes the Close and View buttons.
    ///
    /// The string is used as a key to get a localized string in the current localization to use
    /// for the right button title instead of "View".
    ///
    /// - note: Payload key: `alert.action-loc-key`
    case alertActionLoc(String)
    
    /// An alert message from the `Localizable.strings` file for the current localization
    /// and the corresponding variables for format specifiers in the message string.
    ///
    /// - note: Payload key: `alert.loc-key`, `alert.loc-args`
    case alertLoc(String, [String]?)
    
    /// Display a different launch image instead of the default one.
    ///
    /// - note: Payload key: `alert.launch-image`
    case alertLaunchImage(String)
    
    /// Modify the badge of the app icon.
    ///
    /// If this key is not in the dictionary, the badge is not changed.
    ///
    /// To remove the badge, set the value of this key to `0`.
    ///
    /// - note: Payload key: `badge`
    case badge(Int)
    
    /// Play a sound.
    ///
    /// The value is the name of a sound file in the app's main bundle or in `Library/Sounds` folder of the app's data contianer.
    /// If the sound file cannot be found, or if you sepcify default for the value, the system plays the default alert sound.
    ///
    /// - note: Payload key: `sound`
    case sound(String)
    
    /// Wake up the app in the background and deliver the notification to it's app delegate.
    case contentAvailable
    
    /// Category representing the notification type.
    ///
    /// This value corresponds to the value in the `identifier` property of one of the app's registered categories.
    ///
    /// - note: Payload key: `category`
    case category(String)
    
    /// Group multiple notifications by using the same `threadId`.
    ///
    /// This key corresponds to the `threadIdentifier` property of the `UNNotificationContent` object.
    ///
    /// - note: Payload key: `thread-id`
    case threadId(String)
    
    /// Allow modification of the notification by a notification service app extension.
    ///
    /// - note: Payload key: `mutable-content`
    case mutableContent

    var asCustom: APNSNotificationCustomItem<HiddenEncodable> {
        switch self {
        case .alertBody(let str):
            return .alertBody(str)
        case .alertTitle(let str):
            return .alertTitle(str)
        case .alertTitleLoc(let a, let b):
            return .alertTitleLoc(a, b)
        case .alertActionLoc(let str):
            return .alertActionLoc(str)
        case .alertLoc(let a, let b):
            return .alertLoc(a, b)
        case .alertLaunchImage(let s):
            return .alertLaunchImage(s)
        case .badge(let i):
            return .badge(i)
        case .sound(let s):
            return .sound(s)
        case .contentAvailable:
            return .contentAvailable
        case .category(let c):
            return .category(c)
        case .threadId(let id):
            return .threadId(id)
        case .mutableContent:
        return .mutableContent
        }
    }
}
