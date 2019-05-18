//
//  VideoViewController.swift
//  Movies
//
//  Created by Raul Mena on 5/17/19.
//  Copyright © 2019 Raul Mena. All rights reserved.
//

import UIKit
import WebKit

class VideoViewController: UIViewController, WKNavigationDelegate{
    var webView: WKWebView!
    var videoURL: URL?
    
    init(url: URL) {
        super.init(nibName: nil, bundle: nil)
        self.videoURL = url
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        guard let url = videoURL else {return}
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
        
        view.addSubview(navBarView)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: navBarView)
        view.addConstraintsWithFormat(format: "V:|[v0(75)]", views: navBarView)
        
        navBarView.addSubview(backButton)
        navBarView.addConstraintsWithFormat(format: "H:|-20-[v0(30)]", views: backButton)
        navBarView.addConstraintsWithFormat(format: "V:[v0(30)]-8-|", views: backButton)
        backButton.addTarget(self, action: #selector(handleBackButtonTap), for: .touchUpInside)
    }
    
    @objc private func handleBackButtonTap(){
        navigationController?.popViewController(animated: true)
    }
    
    let navBarView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    let backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Back"), for: .normal)
        return button
    }()
}
