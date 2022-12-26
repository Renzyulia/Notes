//
//  AddingNoteViewController.swift
//  AppForNotes
//
//  Created by Julia on 25/12/2022.
//

import Foundation
import UIKit

class AddingAndEditingNoteViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.backButtonDisplayMode = .minimal
        
        configureTextView()
    }
    
    private func configureTextView() {
        let textView = UITextView()
        textView.font = .systemFont(ofSize: 15)
        textView.autocorrectionType = .yes
        textView.keyboardType = .default
        textView.returnKeyType = .done
        textView.textAlignment = .right
            
        view.addSubview(textView)
            
        textView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([textView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
                                     textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                                     textView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
                                     textView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor)])
    }
}
