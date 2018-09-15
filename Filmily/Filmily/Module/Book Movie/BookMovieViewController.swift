//
//  BookMovieViewController.swift
//  Filmily
//
//  Created by Azules on 2018/9/13.
//  Copyright © 2018年 Azules. All rights reserved.
//

import UIKit
import WebKit

class BookMovieViewController: UIViewController, WKNavigationDelegate, Alertable {

    private var webView: WKWebView!
    
    lazy private var progressView: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .bar)
        progressView.progress = 0.0
        progressView.isHidden = true
        
        return progressView
    }()
    
    private let progressKey = "estimatedProgress"
    
    override func loadView() {
        super.loadView()

        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(dismissViewController))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        
        loadOfficialWebsite()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.addSubview(progressView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let bounds = navigationController?.navigationBar.bounds
        progressView.frame = CGRect(x: 0.0, y: (bounds?.maxY)! - 2.0, width: (bounds?.width)!, height: 2.0)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        progressView.removeFromSuperview()
    }
    
    deinit {
        webView.removeObserver(self, forKeyPath: progressKey)
    }
    
    @objc func dismissViewController() {
        dismiss(animated: true, completion: nil)
    }
    
    func loadOfficialWebsite() {
        let url = URL(string: "https://www.cathaycineplexes.com.sg")
        webView.load(URLRequest(url: url!))
        webView.addObserver(self, forKeyPath: progressKey, options: .new, context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == progressKey {
            progressView.setProgress(Float(webView.estimatedProgress), animated: true)
            progressView.isHidden = progressView.progress == 1.0
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    // MARK: - WKNavigationDelegate
        
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        progressView.isHidden = true
        progressView.progress = 0.0
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        progressView.isHidden = true
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        progressView.isHidden = true
        showAlert(title: "", message: error.localizedDescription)
    }
    
}
