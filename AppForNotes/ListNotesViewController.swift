//
//  ViewController.swift
//  AppForNotes
//
//  Created by Julia on 23/12/2022.
//

import UIKit
import CoreData

class ListNotesViewController: UIViewController, NSFetchedResultsControllerDelegate {
    
    private let cellIdentifier = "CellToNote"
    private let contentTableView = UITableView()
    private lazy var fetchResultsController: NSFetchedResultsController<Note> = {
        let context = CoreData.shared.viewContext
        let fetchRequest = Note.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        self.fetchResultsController = controller
        controller.delegate = self
        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .lightGray
        navigationItem.title = "Notes"
        navigationItem.backButtonDisplayMode = .minimal
        
        configureTableView()
        configureAddNoteButton()
        getNotesFromDatabase()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        contentTableView.reloadData()
    }
    
    private func getNotesFromDatabase() {
        do {
            try fetchResultsController.performFetch()
        } catch {
            fatalError("Failed to fetch entities: \(error)")
        }
    }
    
    private func configureTableView() {
        contentTableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        contentTableView.backgroundColor = .white
        contentTableView.dataSource = self
        contentTableView.delegate = self
        
        view.addSubview(contentTableView)
        
        contentTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([contentTableView.rightAnchor.constraint(equalTo: view.rightAnchor),
                                     contentTableView.leftAnchor.constraint(equalTo: view.leftAnchor),
                                     contentTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                                     contentTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)])
    }
    
    private func configureAddNoteButton() {
        let addNoteButton = UIButton(type: .custom)
        addNoteButton.setImage(UIImage(named: "Icon"), for: .normal)
        addNoteButton.imageView?.layer.transform = CATransform3DMakeScale(0.4, 0.4, 0.4)
        addNoteButton.setTitleColor(.white, for: .normal)
        addNoteButton.frame = CGRect(x: 100, y: 100, width: 75, height: 75)
        addNoteButton.layer.cornerRadius = 0.5 * addNoteButton.bounds.size.width
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
        let context = CoreData.shared.viewContext
        let object = Note(context: context, note: " ", date: Date())
        let note = object
        do {
            try context.save()
        } catch {
            fatalError("cannot save the object")
        }
        let addingAndEditingNoteViewController = AddingAndEditingNoteViewController(note: note)
        self.navigationController?.pushViewController(addingAndEditingNoteViewController, animated: true)
    }
}

extension ListNotesViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
            return fetchResultsController.sections!.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = fetchResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        var content = cell.defaultContentConfiguration()
        content.text = fetchResultsController.object(at: indexPath).correctText.string
        cell.contentConfiguration = content
        
        return cell
    }
}

extension ListNotesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let note = fetchResultsController.object(at: indexPath)
        let addingAndEditingNoteViewController = AddingAndEditingNoteViewController(note: note)
        self.navigationController?.pushViewController(addingAndEditingNoteViewController, animated: true)
    }
    
    func tableView(
        _ tableView: UITableView,
        contextMenuConfigurationForRowAt indexPath: IndexPath,
        point: CGPoint
    ) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil, actionProvider: { [weak self] suggestedActions in
            let deleteAction = UIAction(title: NSLocalizedString("DeleteThing", comment: ""),
                                        image: UIImage(systemName: "trash"),
                                        attributes: .destructive) { action in
                self?.deleteNote(indexPath: indexPath)
            }
            return UIMenu(title: "", children: [deleteAction])
        })
    }
    
    private func deleteNote(indexPath: IndexPath) {
        let context = CoreData.shared.viewContext
        let object = fetchResultsController.object(at: indexPath)
        context.delete(object)
        do {
            try context.save()
        } catch {
            fatalError("cannot save the object")
        }
    }
}
