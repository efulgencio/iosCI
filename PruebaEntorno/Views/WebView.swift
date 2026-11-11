//
//  Untitled.swift
//  PruebaEntorno
//
//  Created by Fulgencio Comendeiro, Eduardo on 06/11/2026.
//

import SwiftUI
import WebKit
import Combine

// Objeto observable corregido con @Published
class WebViewCoordinatorProxy: ObservableObject {
    @Published var evaluateJS: ((String) -> Void)?
}

struct HTMLWebView: UIViewRepresentable {
    let htmlContent: String
    @Binding var receivedText: String // Variable nativa que actualizaremos desde la web
    @ObservedObject var proxy: WebViewCoordinatorProxy

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func makeUIView(context: Context) -> WKWebView {
        let configuration = WKWebViewConfiguration()
        
        // Registramos el manejador de mensajes para escuchar a JS
        configuration.userContentController.add(context.coordinator, name: "iosBridge")
        
        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.navigationDelegate = context.coordinator
        
        #if DEBUG
        if #available(iOS 16.4, *) {
            webView.isInspectable = true
        }
        #endif
        
        // Asignamos el closure para evaluar JavaScript desde fuera
        context.coordinator.webView = webView
        // Evita publicar cambios durante la actualización de la vista
        let weakWebView = webView
        DispatchQueue.main.async { [weak proxy] in
            proxy?.evaluateJS = { script in
                weakWebView.evaluateJavaScript(script, completionHandler: nil)
            }
        }
        
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        if uiView.url == nil {
            uiView.loadHTMLString(htmlContent, baseURL: nil)
        }
    }

    static func dismantleUIView(_ uiView: WKWebView, coordinator: Coordinator) {
        // Limpia el closure publicado para evitar referencias colgantes
        coordinator.parent.proxy.evaluateJS = nil
    }

    // El Coordinator maneja los mensajes enviados desde el entorno web
    class Coordinator: NSObject, WKScriptMessageHandler, WKNavigationDelegate {
        var parent: HTMLWebView
        weak var webView: WKWebView?

        init(parent: HTMLWebView) {
            self.parent = parent
        }

        // Este método se ejecuta cuando JS llama a window.webkit.messageHandlers.iosBridge.postMessage(...)
        func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
            if message.name == "iosBridge", let messageBody = message.body as? String {
                // Actualizamos el estado en SwiftUI desde el hilo principal
                DispatchQueue.main.async {
                    self.parent.receivedText = messageBody
                }
            }
        }
    }
}
