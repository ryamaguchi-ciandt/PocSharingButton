//
//  ViewController.swift
//  PocSharingButton
//
//  Created by Ricardo Yamaguchi on 18/08/20.
//  Copyright © 2020 Ricardo Yamaguchi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - Private properties
    
    private var model = TextViewModel()
    private var viewHeight: CGFloat = 0
    
    // MARK: - Outlets
    
    @IBOutlet private weak var textView: UITextView? {
        didSet {
            textView?.delegate = self
        }
    }
    
    // MARK: - Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupKeyboardListeners()
        setupNavigationBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewHeight = view.frame.size.height
    }
    
    // MARK: - Private methods
    
    private func setupNavigationBar() {
        let shareButton = UIBarButtonItem(barButtonSystemItem: .action,
                                          target: self,
                                          action: #selector(shareButtonTap(_:)))
        
        navigationItem.rightBarButtonItems = [shareButton]
    }
    
    private func setupKeyboardListeners() {

        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardDidShow), name: UIResponder.keyboardDidShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardDidHide), name: UIResponder.keyboardDidHideNotification, object: nil)

    }
    
    @objc
    private func keyboardDidShow(notification: NSNotification) {
        
        guard
            let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        
        view.frame.size.height = viewHeight - keyboardSize.height
        print("did show \(view.frame.size.height)")
    }
    
    @objc
    private func keyboardDidHide(notification: NSNotification) {
        guard
            let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        
        view.frame.size.height = viewHeight + keyboardSize.height
    }
    
    @objc
    private func shareButtonTap(_ sender: Any) {
        guard
            let content = model.content, content.count > 0 else {
                return
        }
        let items = [content]
        let activityViewController = UIActivityViewController( activityItems: items,
                                                               applicationActivities: nil)
        present(activityViewController, animated: true)
        
    }
    
}

// MARK: - Extensions

extension ViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        model.content = textView.text
    }
}


struct TextViewModel {
    
    var content: String?
    
}
