//
//  ViewController.swift
//  AppForNotes
//
//  Created by Julia on 23/12/2022.
//

import UIKit

class ViewController: UIViewController {
    
    private let identifierCell = "CellToNote"
    private let contentTableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        configureAddNoteButton()
    }

    private func configureTableView() {
      contentTableView.register(UITableViewCell.self, forCellReuseIdentifier: identifierCell)
      contentTableView.backgroundColor = .clear
      contentTableView.dataSource = self
      contentTableView.delegate = self
      
      contentTableView.clipsToBounds = true
      
      view.addSubview(contentTableView)
      
      contentTableView.translatesAutoresizingMaskIntoConstraints = false
      NSLayoutConstraint.activate([contentTableView.rightAnchor.constraint(equalTo: view.rightAnchor),
                                   contentTableView.leftAnchor.constraint(equalTo: view.leftAnchor),
                                   contentTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
                                   contentTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)])
    }
    
    private func configureAddNoteButton() {
        let addNoteButton = UIButton(type: .custom)
        addNoteButton.setImage(UIImage(named: "Icon"), for: .normal)
        addNoteButton.imageView?.layer.transform = CATransform3DMakeScale(0.4, 0.4, 0.4)
        addNoteButton.setTitleColor(.white, for: .normal)
        addNoteButton.frame = CGRect(x: 75, y: 75, width: 75, height: 75)
        addNoteButton.layer.cornerRadius = addNoteButton.frame.height * 0.5
        addNoteButton.layer.masksToBounds = true
        addNoteButton.backgroundColor = .lightGray
        addNoteButton.addTarget(self, action: #selector(add), for: .touchUpInside)
        
        view.addSubview(addNoteButton)
        
        addNoteButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([addNoteButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -40),
                                     addNoteButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -70),
                                     addNoteButton.widthAnchor.constraint(equalToConstant: 75),
                                     addNoteButton.heightAnchor.constraint(equalToConstant: 75)])
    }
    
    @objc private func add() {
        let addingNoteViewController = AddingNoteViewController()
        self.navigationController?.pushViewController(addingNoteViewController, animated: true)
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifierCell, for: indexPath)
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { //высота ячейки
      return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let editingNoteViewController = EditingNoteViewController()
        self.navigationController?.pushViewController(editingNoteViewController, animated: true)
    }
}

class LabelCell: UITableViewCell {
    private let label = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
      super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell() {
      label.font = .systemFont(ofSize: 22, weight: .medium)
      label.textColor = .black
      label.textAlignment = .center
      label.text = "Notes"

      contentView.addSubview(label)

      label.translatesAutoresizingMaskIntoConstraints = false
      NSLayoutConstraint.activate([label.topAnchor.constraint(equalTo: contentView.topAnchor),
                                   label.rightAnchor.constraint(equalTo: contentView.rightAnchor),
                                   label.leftAnchor.constraint(equalTo: contentView.leftAnchor),
                                   label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)])
    }
}
