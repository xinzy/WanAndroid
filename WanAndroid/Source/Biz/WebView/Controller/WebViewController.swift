//
//  WebViewController.swift
//  WanAndroid
//
//  Created by Yang on 2021/7/27.
//

import UIKit
import WebKit
import SnapKit
import Commons

class WebViewController: UIViewController {

    private var observes: [NSKeyValueObservation] = []
    private var url: String?

    deinit {
        for item in observes {
            item.invalidate()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        initAction()
        loadUrl()
    }

    private func loadUrl() {
        if let url = url, let requestUrl = URL(string: url) {
            let request = URLRequest(url: requestUrl)
            webView.load(request)
        }
    }

    private lazy var titleLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: ScreenWidth - 144, height: 44))
        label.textColor = Colors.textPrimary
        label.font = .font(ofSize: 17)
        label.textAlignment = .center
        return label
    }()

    private lazy var progressBar: UIProgressView = {
        let view = UIProgressView(progressViewStyle: .bar)
        view.isHidden = true
        view.progress = 0
        view.tintColor = Colors.red_500
        view.trackTintColor = Colors.separator
        return view
    }()

    private lazy var webView: WKWebView = {
        let preference = WKPreferences()
        preference.javaScriptEnabled = true
        preference.javaScriptCanOpenWindowsAutomatically = true

        let config = WKWebViewConfiguration()
        config.allowsAirPlayForMediaPlayback = true
        config.allowsInlineMediaPlayback = true
        config.allowsPictureInPictureMediaPlayback = true
        config.selectionGranularity = .dynamic
        config.preferences = preference

        let webView = WKWebView(frame: .zero, configuration: config)
        webView.allowsBackForwardNavigationGestures = true
        webView.allowsLinkPreview = true
        webView.uiDelegate = self
        webView.navigationDelegate = self
        return webView
    }()

    private lazy var closeBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(.iconClose, for: .normal)
        btn.addTarget(self, action: #selector(popSelf), for: .touchUpInside)
        return btn
    }()
}

extension WebViewController: WKNavigationDelegate, WKUIDelegate {

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
    }

    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        if let serverTrust = challenge.protectionSpace.serverTrust {
            let card = URLCredential(trust: serverTrust)
            completionHandler(.useCredential, card)
        }
    }

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {

        if let url = navigationAction.request.url {
            if url.absoluteString.contains("//itunes.apple.com/") {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                decisionHandler(.cancel)
                return
            } else if let scheme = url.scheme, !scheme.hasPrefix("http") {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                decisionHandler(.cancel)
                return
            }
        }
        decisionHandler(.allow)
    }

    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if let frameInfo = navigationAction.targetFrame {
            if !frameInfo.isMainFrame {
                webView.load(navigationAction.request)
            }
        } else {
            webView.load(navigationAction.request)
        }

        return nil
    }
}

extension WebViewController {
    static func showController(_ navigationController: UINavigationController?, _ url: String) {
        let controller = WebViewController()
        controller.hidesBottomBarWhenPushed = true
        controller.url = url
        navigationController?.pushViewController(controller, animated: true)
    }

    private func setupView() {
        navigationItem.titleView = titleLabel
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: closeBtn)

        view.addSubview(webView)
        webView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        view.addSubview(progressBar)
        progressBar.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(2)
        }
    }

    private func initAction() {
        observes.append(webView.observe(\.estimatedProgress, options: .new) { [weak self] (webview, _) in
            guard let `self` = self else { return }
            let progress = webview.estimatedProgress > 0.1 ? webview.estimatedProgress : 0.1
            let completed = progress == 1.0
            self.progressBar.setProgress(completed ? 0.0 : Float(progress), animated: !completed)
            self.progressBar.isHidden = completed
        })

        observes.append(webView.observe(\.title, options: .new, changeHandler: { [weak self] (webview, _) in
            guard let `self` = self else { return }
            self.titleLabel.text = webview.title
        }))
    }

    @objc private func popSelf() {
        navigationController?.popViewController(animated: true)
    }
}
