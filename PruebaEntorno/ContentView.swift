//
//  ContentView.swift
//  PruebaEntorno
//
//  Created by Fulgencio Comendeiro, Eduardo on 05/11/2026.
//


import SwiftUI
import MiPluginUI // Tu paquete local

struct ContentView: View {
    // 1. Estado para guardar el número recibido desde el plugin
    @State private var numeroRecibido: Int = 0
    @State private var resultadoPlugin: String = "Esperando acción..."
    @State private var webInputText: String = "" // Texto recibido desde la web
    @State private var inputToWeb: String = ""   // Texto para enviar hacia la web (lo usaremos en el siguiente paso)
    @StateObject private var webProxy = WebViewCoordinatorProxy()
    
    private let sampleHTML = """
        <!DOCTYPE html>
        <html>
        <head>
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <style>
                body {
                    font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
                    padding: 20px;
                    background-color: #f2f2f7;
                    color: #1c1c1e;
                }
                .card {
                    background: white;
                    padding: 20px;
                    border-radius: 12px;
                    box-shadow: 0 4px 6px rgba(0,0,0,0.1);
                }
                h1 { color: #007aff; margin-top: 0; }
            </style> 
        </head>
        <body>
        <div class="card">
                    <h2>Prueba Web -> Nativo</h2>
                    <p>Escribe algo y mándalo a Swift:</p>
                    <input type="text" id="userInput" placeholder="Escribe aquí...">
                    <button onclick="sendToNative()">Enviar a Nativo</button>
                </div>

        <!-- Sección Nativo -> Web -->
                <div class="card">
                    <h3>Nativo ➔ Web</h3>
                    <p>Recibido desde Swift:</p>
                    <div id="nativeOutput" class="result-box">Esperando datos de Swift...</div>
                </div>
        
                <script>
                    function sendToNative() {
                        const text = document.getElementById('userInput').value;
                        // Llamada al puente nativo configurado en Swift
                        window.webkit.messageHandlers.iosBridge.postMessage(text);
                    }
        
                    // Función expuesta globalmente para que Swift la invoque
                    function updateWebText(text) {
                       document.getElementById('nativeOutput').innerText = text;
                    }
                </script>
        </body>
        </html>
        """

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    Text("Mi App Principal")
                        .font(.largeTitle)
                        .bold()
                    /*
                    // Mostramos el valor que va llegando
                    Text("Número recibido del plugin: \(numeroRecibido)")
                        .font(.headline)
                        .foregroundColor(.blue)
                    */
                    // Mostramos lo que devuelve el plugin de comandos
                                    Text(resultadoPlugin)
                                        .font(.headline)
                                        .foregroundColor(.blue)
                                        .padding()
                    
                    // Botón para simular la ejecución del plugin
                    Button(action: {
                        // 1. Creamos un payload simulado con el identificador de pantalla
                        let payloadFalso: [String: AnyObject] = [
                            ScreenOpenParams.screenIdKey: "ConfiguracionScreen" as AnyObject
                        ]
                        
                        // 2. Invocamos el manager del plugin
                        if let screenId = ScreenOpenPluginManager.shared.processPayload(payloadFalso) {
                            resultadoPlugin = "Plugin ejecutado con éxito. Destino: \(screenId)"
                        } else {
                            resultadoPlugin = "No se reconoció el identificador"
                        }
                    }) {
                        Text("Ejecutar ScreenOpenPlugin")
                            .bold()
                            .padding()
                            .background(Color.accentColor)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                                    }
                    
                    /*
                    // 2. Invocamos el plugin y capturamos el valor en el closure
                    PluginView(mensaje: "Pulsa el botón para enviar datos") { valor in
                        // Esto se ejecuta exactamente cuando pulsan el botón dentro del plugin
                        self.numeroRecibido = valor
                    }
                    .padding()
                    */
                    
                    Divider()
                    
                   //  ItemListView()
                    
                    VStack {
                        HTMLWebView(htmlContent: sampleHTML, receivedText: $webInputText, proxy: webProxy)
                                            .frame(height: 280)
                                            .cornerRadius(12)
                                            .padding(.horizontal)
                        
                        // 2. Elemento nativo de SwiftUI que muestra lo que envió la web
                                        VStack(alignment: .leading, spacing: 10) {
                                            Text("Vista Nativa (SwiftUI)")
                                                .font(.headline)
                                                .foregroundColor(.secondary)
                                            
                                            Text(webInputText.isEmpty ? "Esperando texto desde la web..." : webInputText)
                                                .padding()
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                                .background(Color(.systemGray6))
                                                .cornerRadius(8)
                                        }
                                        .padding(.horizontal)
                        
                                        TextField("Texto para la web...", text: $inputToWeb)
                                                .textFieldStyle(.roundedBorder)
                    
                                        Button(action: {
                                                // Construimos la sentencia JS escapando comillas si es necesario
                                                // y llamamos a la función global 'updateWebText' definida en el HTML
                                                // let jsCommand = "updateWebText('\(inputToWeb)');"
                                                // webProxy.evaluateJS?(jsCommand)
                                                let textoAEnviar = inputToWeb
                                                let jsCommand = "updateWebText('\(textoAEnviar)');"
                                                
                                                if let evaluator = webProxy.evaluateJS {
                                                    evaluator(jsCommand)
                                                    print("Comando JS enviado: \(jsCommand)")
                                                } else {
                                                    print("Error: El proxy web aún no está inicializado.")
                                                }
                                            
                                            }) {
                                                Text("Enviar a la Web")
                                                    .font(.headline)
                                                    .frame(maxWidth: .infinity)
                                                    .padding(10)
                                                    .background(Color.blue)
                                                    .foregroundColor(.white)
                                                    .cornerRadius(8)
                                            }
                        
                    }
                    
                    Divider()

                    // Ejemplo: Acoplamiento vs Inyección de Dependencias
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Acoplamiento vs DI")
                            .font(.title3)
                            .bold()
                        Text("Primero cargamos con clases acopladas y luego con DI (inyectando un repositorio mock)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        DIDemoView()
                            .padding(.top, 4)
                    }
                    .padding(.horizontal)
                }
                .padding()
            }
            .navigationTitle("Vista Híbrida")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
}

#Preview {
    ContentView()
}
