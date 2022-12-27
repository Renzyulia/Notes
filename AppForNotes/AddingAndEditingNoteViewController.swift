//
//  AddingNoteViewController.swift
//  AppForNotes
//
//  Created by Julia on 25/12/2022.
//

import Foundation
import UIKit

class AddingAndEditingNoteViewController: UIViewController {
    let note: Note
    let textView = UITextView()
    
    init(note: Note) {
      self.note = note
      super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        navigationController?.navigationBar.tintColor = .black
        
        configureTextView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    
        let context = CoreData.shared.viewContext
        note.text = textView.text
        note.date = Date()
        if note.text! == "" {
            context.delete(note)
        }
        do {
            try context.save()
        } catch {
            fatalError("cannot save the object")
        }
    }
    
    private func configureTextView() {
        if note.text != nil {
            textView.text = note.text
        }
        textView.font = .systemFont(ofSize: 18)
        textView.autocorrectionType = .yes
        textView.keyboardType = .default
        textView.returnKeyType = .done
        textView.textAlignment = .left
            
        view.addSubview(textView)
            
        textView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([textView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                                     textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                                     textView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
                                     textView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor)])
    }
}
