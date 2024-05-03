//
//  CustomWebView.swift
//  UserProfileKit
//
//  Created by Narayanamoorthy on 02/05/24.
//

import Foundation
import UIKit
import WebKit

/// Protocol for handling navigation events of the web view.
public protocol WVNavigationDelegate: AnyObject {
    /// Called when the web view finishes loading a URL.
    func webView(_ webView: WebView, didFinishLoading url: URL?)
    
    /// Called when the web view fails to load a URL with an error.
    func webView(_ webView: WebView, didFailLoading url: URL?, withError error: Error)
}

/// Protocol for handling custom actions in the web view.
public protocol WVActionDelegate: AnyObject {
    /// Called when the user selects a profile image action in the web view.
    func didSelectProfileImage()
}

/// Protocol for handling messages received from the web view.
public protocol WVMessageHandler: AnyObject {
    /// Called when an error message is received from the web view.
    func didReceiveError(message: String)
    
    /// Called when user data is received from the web view.
    func didReceiveUserData(data: String)
}

/// Custom WebView class that encapsulates a WKWebView.
public class WebView: UIView {
    private var webView: WKWebView!
    
    /// Delegate for handling navigation events.
    public weak var navDelegate: WVNavigationDelegate?
    
    /// Delegate for handling custom actions.
    public weak var actionDelegate: WVActionDelegate?
    
    /// Delegate for handling messages received from the web view.
    public weak var messageDelegate: WVMessageHandler?
    
    /// Initializes the web view with the specified frame.
    ///
    /// - Parameter frame: The frame rectangle for the web view.
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupWebView()
    }
    
    /// Initializes the web view from data in a given unarchiver.
    ///
    /// - Parameter coder: An unarchiver object.
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupWebView()
    }
    
    // MARK: - Private Methods
    
    private func setupWebView() {
        webView = WKWebView(frame: bounds, configuration: getConfiguration())
        webView.navigationDelegate = self
        addSubview(webView)
        setConstraint()
        
#if DEBUG
        if #available(iOS 16.4, *) {
            webView.isInspectable = true
        }
#endif
    }
    
    private func getConfiguration() -> WKWebViewConfiguration {
        let configuration = WKWebViewConfiguration()
        configuration.userContentController.add(self, name: "openCameraPage")
        configuration.userContentController.add(self, name: "formSubmitted")
        configuration.userContentController.add(self, name: "jsErrorHandler")
        return configuration
    }
    
    private func setConstraint() {
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        webView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        webView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }

    // MARK: - Public Methods
    
    /// Loads the specified URL request.
    ///
    /// - Parameter url: The URL request to load.
    public func loadURL(_ url: URL) {
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    /// Sets the profile image in the web view.
    ///
    /// - Parameter fileUrl: The file URL of the profile image.
    public func setProfileImage(with base64: String) {
        let script = "setProfileImage('\(base64)')"
        webView.evaluateJavaScript(script) { _, error in
            if let error = error {
                print("JavaScript error:", error.localizedDescription)
            }
        }
    }
}

// MARK: - WKNavigationDelegate

extension WebView: WKNavigationDelegate {
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        navDelegate?.webView(self, didFinishLoading: webView.url)
    }
    
    public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        navDelegate?.webView(self, didFailLoading: webView.url, withError: error)
    }
}

// MARK: - WKScriptMessageHandler

extension WebView: WKScriptMessageHandler {
    public func userContentController(_ userContentController: WKUserContentController,
                                      didReceive message: WKScriptMessage) {
        if message.name == "jsErrorHandler", let errorMessage = message.body as? String {
            messageDelegate?.didReceiveError(message: errorMessage)
        } else if message.name == "openCameraPage" {
            actionDelegate?.didSelectProfileImage()
        } else if message.name == "formSubmitted", let userData = message.body as? String {
            messageDelegate?.didReceiveUserData(data: userData)
        }
    }
}
