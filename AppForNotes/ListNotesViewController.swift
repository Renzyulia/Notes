//
//  ViewController.swift
//  AppForNotes
//
//  Created by Julia on 23/12/2022.
//

import UIKit

class ListNotesViewController: UIViewController {
    
    private let cellIdentifier = "CellToNote"
    private let contentTableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        configureAddNoteButton()
    }

    private func configureTableView() {
        contentTableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        contentTableView.backgroundColor = .clear
        contentTableView.dataSource = self
        contentTableView.delegate = self
      
        view.addSubview(contentTableView)
      
        contentTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([contentTableView.rightAnchor.constraint(equalTo: view.rightAnchor),
                                     contentTableView.leftAnchor.constraint(equalTo: view.leftAnchor),
                                     contentTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
                                     contentTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)])
    }
    
    private func configureAddNoteButton() {
        let addNoteButton = UIButton(type: .custom)
        addNoteButton.setImage(UIImage(named: "Icon"), for: .normal)
        addNoteButton.imageView?.layer.transform = CATransform3DMakeScale(0.4, 0.4, 0.4)
        addNoteButton.setTitleColor(.white, for: .normal)
        addNoteButton.layer.cornerRadius = addNoteButton.frame.height * 0.5
        addNoteButton.layer.masksToBounds = true
        addNoteButton.backgroundColor = .lightGray
        addNoteButton.addTarget(self, action: #selector(add), for: .touchUpInside)
        
        view.addSubview(addNoteButton)
        
        addNoteButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([addNoteButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
                                     addNoteButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -70),
                                     addNoteButton.widthAnchor.constraint(equalToConstant: 75),
                                     addNoteButton.heightAnchor.constraint(equalToConstant: 75)])
    }
    
    @objc private func add() {
        let addingNoteViewController = AddingNoteViewController()
        self.navigationController?.pushViewController(addingNoteViewController, animated: true)
    }
}

extension ListNotesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        return cell
    }
}

extension ListNotesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { //высота ячейки
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let editingNoteViewController = EditingNoteViewController()
        self.navigationController?.pushViewController(editingNoteViewController, animated: true)
    }
}
