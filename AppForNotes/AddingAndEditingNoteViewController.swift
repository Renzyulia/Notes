//
//  AddingNoteViewController.swift
//  AppForNotes
//
//  Created by Julia on 25/12/2022.
//

import Foundation
import UIKit

final class AddingAndEditingNoteViewController: UIViewController {
    let note: Note
    
    private let textView = UITextView()
    
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
        customMenu()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        let context = CoreData.shared.viewContext
        note.correctText = textView.attributedText
        note.date = Date()
        if textView.attributedText.string == " " {
            context.delete(note)
        }
        do {
            try context.save()
        } catch {
            fatalError("cannot save the object")
        }
    }
    
    private func configureTextView() {
        textView.attributedText = note.correctText
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
    
    private func customMenu() {
        let bold = UIMenuItem(title: "Bold", action: #selector(makeFontBold))
        let italics = UIMenuItem(title: "Italics", action: #selector(makeFontItalics))
        let underline = UIMenuItem(title: "Underline", action: #selector(makeFontUnderlined))
        UIMenuController.shared.menuItems = [bold, italics, underline]
    }
    
    @objc private func makeFontBold() {
        let range = textView.selectedRange
        let string = NSMutableAttributedString(attributedString: textView.attributedText)
        let boldAttribute = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18)]
        string.addAttributes(boldAttribute, range: textView.selectedRange)
        textView.attributedText = string
        textView.selectedRange = range
    }
    
    @objc private func makeFontItalics() {
        let range = textView.selectedRange
        let string = NSMutableAttributedString(attributedString: textView.attributedText)
        let italicsAttribute = [NSAttributedString.Key.font: UIFont.italicSystemFont(ofSize: 18)]
        string.addAttributes(italicsAttribute, range: textView.selectedRange)
        textView.attributedText = string
        textView.selectedRange = range
    }
    
    @objc private func makeFontUnderlined() {
        let range = textView.selectedRange
        let string = NSMutableAttributedString(attributedString: textView.attributedText)
        let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue]
        string.addAttributes(underlineAttribute, range: textView.selectedRange)
        textView.attributedText = string
        textView.selectedRange = range
    }
}
