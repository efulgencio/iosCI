//
//  ScreenOpenPluginManager.swift
//  PruebaEntorno
//
//  Created by Fulgencio Comendeiro, Eduardo on 05/11/2026.
//

import Foundation

public class ScreenOpenPluginManager {
    public static let shared = ScreenOpenPluginManager()
    
    private init() {}
    
    public func processPayload(_ payload: [String: AnyObject]) -> String? {
        let command = ScreenOpenCommand(payload: payload)
        return command.execute()
    }
}
