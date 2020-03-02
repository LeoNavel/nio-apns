//
//  APNSPayload.swift
//  NIOAPNS
//
// Edited:
//  author: Filip Klembara (filip@klembara.pro)
//  date:   2. Mar. 2020
//  modifications:
//      APNSPayload is now generic
//      add encode function for APNSPayload
//      add CodingKeys
//


import Foundation

fileprivate struct APS: Encodable {
    var alert: Alert?
    var badge: Int?
    var sound: String?
    var contentAvailable: Int?
    var category: String?
    var threadId: String?
    var mutableContent: Int?
    
    enum CodingKeys: String, CodingKey {
        case alert = "alert"
        case badge = "badge"
        case sound = "sound"
        case contentAvailable = "content-available"
        case category = "category"
        case threadId = "thread-id"
        case mutableContent = "mutable-content"
    }
}

fileprivate struct Alert: Encodable {
    var body: String?
    var title: String?
    var titleLocKey: String?
    var titleLocArgs: [String]?
    var actionLocKey: String?
    var locKey: String?
    var locArgs: [String]?
    var launchImage: String?
    
    enum CodingKeys: String, CodingKey {
        case body = "body"
        case title = "title"
        case titleLocKey = "title-loc-key"
        case titleLocArgs = "title-loc-args"
        case actionLocKey = "action-loc-key"
        case locKey = "loc-key"
        case locArgs = "loc-args"
        case launchImage = "launch-image"
    }
    
    var notEmpty: Bool {
        return body != nil
            || title != nil
            || titleLocKey != nil
            || actionLocKey != nil
            || locKey != nil
            || locArgs != nil
            || launchImage != nil
    }
}

internal struct APNSPayload<T: Encodable>: Encodable {
    private var aps = APS()
    private struct Body: Encodable, Hashable {
        static func == (lhs: APNSPayload<T>.Body, rhs: APNSPayload<T>.Body) -> Bool {
            lhs.key == rhs.key
        }

        func hash(into hasher: inout Hasher) {
            hasher.combine(key)
        }

        let key: String
        let body: T
    }
    private var customKey: String?
    // type is set because we want to prevent key duplication
    private var customs: Set<Body> = []
    
    init(notificationItems items: [APNSNotificationCustomItem<T>]) {
        var alert = Alert()
        for item in items {
            switch item {
            case .alertBody(let body):
                alert.body = body
                
            case .alertTitle(let title):
                alert.title = title
                
            case .alertTitleLoc(let key, let args):
                alert.titleLocKey = key
                alert.titleLocArgs = args
                
            case .alertActionLoc(let key):
                alert.actionLocKey = key
                
            case .alertLoc(let key, let args):
                alert.locKey = key
                alert.locArgs = args
                
            case .alertLaunchImage(let image):
                alert.launchImage = image
                
            case .badge(let number):
                aps.badge = number
                
            case .sound(let sound):
                aps.sound = sound
                
            case .contentAvailable:
                aps.contentAvailable = 1
                
            case .category(let category):
                aps.category = category
                
            case .threadId(let threadId):
                aps.threadId = threadId
                
            case .customPayload(let key, let body):
                customs.insert(.init(key: key, body: body))
                
            case .mutableContent:
                aps.mutableContent = 1
            }
        }
        
        // only add alert payload if it's actually used
        aps.alert = alert.notEmpty ? alert : nil
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(aps, forKey: .aps)
        try customs.forEach { body in
            // never fails
            let key = CodingKeys(stringValue: body.key)!
            try container.encode(body.body, forKey: key)
        }
    }
    
    var jsonString: String? {
        guard let jsonData = try? JSONEncoder().encode(self) else {
            return nil
        }
        
        return String(data: jsonData, encoding: .utf8)
    }
}

private struct CodingKeys: CodingKey {
    var intValue: Int?

    init?(stringValue: String) {
        self.stringValue = stringValue
    }

    init?(intValue: Int) {
        return nil
    }

    var stringValue: String
    static var aps = CodingKeys(stringValue: "aps")!
}
