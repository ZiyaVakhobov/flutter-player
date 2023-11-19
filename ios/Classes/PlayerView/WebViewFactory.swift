
import Foundation
import Flutter
import UIKit

class WebViewFactory: NSObject, FlutterPlatformViewFactory {
    private var registrar: FlutterPluginRegistrar

    init(registrar: FlutterPluginRegistrar) {
        self.registrar = registrar
        super.init()
    }

    func create(
        withFrame frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?
    ) -> FlutterPlatformView {
        return FlutterWebView(
            frame: frame,
            viewIdentifier: viewId,
            arguments: args,
            registrar: registrar)
    }
}
