//
//  PruebaEntornoApp.swift
//  PruebaEntorno
//
//  Created by Fulgencio Comendeiro, Eduardo on 05/11/2026.
//

import SwiftUI
import efcspm
import Then
import UserNotifications

@main
struct PruebaEntornoApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    init() {
        #if STAGING
        print("Modo Staging")
        #elseif DEBUG
        print("Modo Depuración activo")
        #else
        print("Modo Release activo")// Para Release
        #endif
        
        let message = EFCSPM.hello()
        print(message)
        
        let environment = ProcessInfo.processInfo.environment["API_ENVIRONMENT"] ?? "production"

        if environment == "staging" {
            print("Conectando al servidor de pruebas...")
        }
        
        // Ejemplo mínimo de configuración. Si instalas Then (https://github.com/devxoul/Then),
        // para tipos valor (struct) como URLRequest usa `.with { }` en vez de `.then { }`.
        // Ejemplo con Then sería:
        // let request = URLRequest(url: URL(string: "https://example.com")!).with {
        //     $0.timeoutInterval = 15
        //     $0.cachePolicy = URLRequest.CachePolicy.reloadIgnoringLocalCacheData
        // }
        // Mientras no esté añadido el paquete, configuramos el request de forma estándar:
        var request = URLRequest(url: URL(string: "https://example.com")!)
        request.timeoutInterval = 15
        request.cachePolicy = URLRequest.CachePolicy.reloadIgnoringLocalCacheData
        print("URLRequest configurado: ", request.timeoutInterval, request.cachePolicy.rawValue)
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        
        // Configurar delegado de notificaciones
        UNUserNotificationCenter.current().delegate = self
        
        // Solicitar permisos
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            print("Permiso concedido: \(granted)")
            if let error = error {
                print("Error al pedir permisos: \(error.localizedDescription)")
            }
        }
        
        // Registrar para notificaciones remotas en APNs
        application.registerForRemoteNotifications()
        
        return true
    }
    
    // Método que se llama cuando el sistema obtiene el Device Token con éxito
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let token = deviceToken.map { String(format: "%02x", $0) }.joined()
        print("APNs Device Token: \(token)")
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Fallo al registrar en APNs: \(error.localizedDescription)")
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // Permite que aparezca el banner, el sonido y el badge incluso con la app abierta
        completionHandler([.banner, .sound, .badge])
    }
    
}

