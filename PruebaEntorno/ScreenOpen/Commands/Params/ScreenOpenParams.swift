//
//  Untitled.swift
//  PruebaEntorno
//
//  Created by Fulgencio Comendeiro, Eduardo on 05/11/2026.
//

import Foundation

public struct ScreenOpenParams {
    public static let screenIdKey: String = "screenIdentifier"
    public let screenId: String?
    
    public init(serverPayload: [String: AnyObject]) {
        screenId = serverPayload[ScreenOpenParams.screenIdKey] as? String
    }
}
