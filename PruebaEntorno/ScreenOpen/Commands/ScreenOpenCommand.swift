//
//  Untitled.swift
//  PruebaEntorno
//
//  Created by Fulgencio Comendeiro, Eduardo on 05/11/2026.
//

import Foundation

public struct ScreenOpenCommand {
    public let params: ScreenOpenParams
    
    public init(payload: [String: AnyObject]) {
        self.params = ScreenOpenParams(serverPayload: payload)
    }
    
    @discardableResult
    public func execute() -> String? {
        // Si tenemos un screenId válido, disparamos la acción de la carpeta Actions
        if let screenId = params.screenId {
            ScreenOpenPluginActions.performOpen(screenId: screenId)
            return screenId
        }
        return nil
    }
}
