//
//  PluginView.swift
//  MiPluginUI
//
//  Created by Fulgencio Comendeiro, Eduardo on 05/11/2026.
//

import SwiftUI

public struct PluginView: View {
    public var mensaje: String
    
    // 1. Definimos el closure que ejecutaremos al pulsar el botón
    public var onButtonTapped: (Int) -> Void

    // 2. Actualizamos el inicializador para recibir la acción (con un valor por defecto vacío por si acaso)
    public init(mensaje: String = "¡Hola desde el Plugin!", onButtonTapped: @escaping (Int) -> Void = { _ in }) {
        self.mensaje = mensaje
        self.onButtonTapped = onButtonTapped
    }

    public var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "puzzlepiece.extension")
                .font(.system(size: 40))
                .foregroundColor(.accentColor)
            
            Text("Componente Modular")
                .font(.headline)
            
            Text(mensaje)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            // 3. Añadimos el botón que enviará el número 5
            Button(action: {
                onButtonTapped(5) // Disparamos el closure pasando el 5
            }) {
                Text("Enviar número 5 a la App")
                    .font(.subheadline)
                    .bold()
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color.accentColor)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 4)
    }
}
