//
//  AddingNoteViewController.swift
//  AppForNotes
//
//  Created by Julia on 25/12/2022.
//

import Foundation
import UIKit

class AddingNoteViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.backButtonDisplayMode = .minimal
        
        configureTextField()
    }
    
    func configureTextField() {
        let textField = UITextField()
        textField.font = .systemFont(ofSize: 15)
        textField.placeholder = "Enter the text"
        textField.borderStyle = .roundedRect
        textField.autocorrectionType = .yes
        textField.keyboardType = .default
        textField.returnKeyType = .done
        textField.clearButtonMode = .whileEditing
        textField.contentVerticalAlignment = .top
            
        self.view.addSubview(textField)
            
        textField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([textField.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
                                     textField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                                     textField.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
                                     textField.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor)])
    }
}
