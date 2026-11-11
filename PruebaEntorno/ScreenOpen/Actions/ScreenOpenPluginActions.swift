//
//  Untitled.swift
//  PruebaEntorno
//
//  Created by Fulgencio Comendeiro, Eduardo on 05/11/2026.
//

import Foundation

public struct ScreenOpenPluginActions {
    
    // Una acción que se ejecuta cuando el plugin procesa correctamente el destino
    public static func performOpen(screenId: String) {
        print("🚀 [Action]: Abriendo la pantalla con identificador -> \(screenId)")
        // Aquí podrías disparar un NotificationCenter, un Router o un closure de navegación
    }
}
