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
    private var fetchResultsController: NSFetchedResultsController<Note>?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .lightGray
        navigationItem.title = "Notes"
        navigationItem.backButtonDisplayMode = .minimal
        
        configureTableView()
        configureAddNoteButton()
        getNotesFromDataBases()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        contentTableView.reloadData()
    }
    
    private func getNotesFromDataBases() {
        let context = CoreData.shared.viewContext
        let fetchRequest = Note.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        self.fetchResultsController = controller
        controller.delegate = self
        do {
            try controller.performFetch()
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
        let object = Note(context: context)
        let note = object
        note.correctText = NSAttributedString(string: " ", attributes: [.font: UIFont(name: "Helvetica", size: 18)!])
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
        if let frc = fetchResultsController {
            return frc.sections!.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = self.fetchResultsController?.sections else {
            fatalError("No sections in fetchedResultsController")
        }
        let sectionInfo = sections[section]
        return sectionInfo.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        guard let object = fetchResultsController?.object(at: indexPath) else {
            fatalError("Attempt to configure cell without a managed object")
        }
        
        var content = cell.defaultContentConfiguration()
        content.text = object.correctText.string
        cell.contentConfiguration = content
        
        return cell
    }
}

extension ListNotesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let object = fetchResultsController?.object(at: indexPath) else { return }
        let note = object
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
        let object = fetchResultsController?.object(at: indexPath)
        context.delete(object!)
        do {
            try context.save()
        } catch {
            fatalError("cannot save the object")
        }
    }
}

class CoreData {
    static let shared = CoreData()
    private init () {}

    lazy private var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ModelCoreData")
        if FileManager.default.fileExists(atPath: container.persistentStoreDescriptions[0].url!.path) {
            container.loadPersistentStores(completionHandler: { (StoreDescription, error) in
              if let error = error as NSError? {
              fatalError("Unresolved error \(error), \(error.userInfo)")
              }
            })
        } else {
            container.loadPersistentStores(completionHandler: { (StoreDescription, error) in
              if let error = error as NSError? {
              fatalError("Unresolved error \(error), \(error.userInfo)")
              }
            })
            let context = container.viewContext
            let object = Note(context: context)
            object.correctText = NSAttributedString(string: "Welcome to Notes!", attributes: [.font: UIFont(name: "Helvetica", size: 18)!])
            object.date = Date()
            do {
                try context.save()
            } catch {
                fatalError("cannot save the object")
            }
        }
        return container
    }()
  
    var viewContext:NSManagedObjectContext { CoreData.shared.persistentContainer.viewContext }
}
