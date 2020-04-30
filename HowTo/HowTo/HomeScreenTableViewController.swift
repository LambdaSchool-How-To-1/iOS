//
//  HomeScreenTableViewController.swift
//  HowTo
//
//  Created by Tobi Kuyoro on 29/04/2020.
//  Copyright © 2020 Tobi Kuyoro. All rights reserved.
//

import UIKit
import CoreData

class HomeScreenTableViewController: UITableViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var signOutButton: UIBarButtonItem!
    @IBOutlet weak var searchBar: UISearchBar!

    // MARK: - Properties

//    var frc = NSFetchedResultsController<Tutorial>()
    
    let userController = UserController()
    let tutorialController = TutorialController()

    lazy var fetchedResultsController: NSFetchedResultsController<Tutorial> = {
        let fetchRequest: NSFetchRequest<Tutorial> = Tutorial.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]

        if searchBar.text != "" {
            fetchRequest.predicate = NSPredicate(format: "title CONTAINS[c] %@", searchBar.text ?? "")
        }

        let context = CoreDataStack.shared.mainContext
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest,
                                             managedObjectContext: context,
                                             sectionNameKeyPath: "title",
                                             cacheName: nil)
        frc.delegate = self

        do {
            try frc.performFetch()
        } catch {
            fatalError("Error performing fetch:\(error)")
        }

        return frc
    }()

    // MARK: - Actions

    @IBAction func addButtonTapped(_ sender: Any) {
    }

    func titleView() {
        let label = UILabel(frame: CGRect(x: 10, y: 0, width: 50, height: 40))
        label.backgroundColor = .clear
        label.font = UIFont(name: "Play-Bold", size: 22)

        label.text = "Guides"
        label.numberOfLines = 2
        label.textColor = .black
        label.sizeToFit()
        label.textAlignment = .center

        self.navigationItem.titleView = label
    }

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        titleView()
        //        setupFRC()
        
        if userController.bearer == nil {
            self.navigationItem.leftBarButtonItem = nil
        } else {
            self.navigationItem.leftBarButtonItem = self.signOutButton
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       guard let cell = tableView.dequeueReusableCell(withIdentifier: "TutorialCell", for: indexPath) as? TutorialTableViewCell else {
            fatalError("Can't dequeue cell of type TutorialCell")
        }
         
        let tutorial = fetchedResultsController.object(at: indexPath)
        cell.tutorial = tutorial

        return cell
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let tutorial = fetchedResultsController.object(at: indexPath)
            tutorialController.deleteTutorialFromServer(tutorial: tutorial)
            tutorialController.delete(tutorial: tutorial)
        }
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowCreateTutorialSegue" {
            if let destinationVC = segue.destination as? CreateTutorialViewController {
                destinationVC.userController = userController
                destinationVC.tutorialController = tutorialController
            }
        } else if segue.identifier == "ShowTutorialDetailSegue" {

        }
    }
    
    // MARK: - Private Functions
    
//    func setupFRC() {
//        let request: NSFetchRequest<Tutorial> = Tutorial.fetchRequest()
//        // filter what we want from CoreData
//        if searchBar.text != "" {
//            request.predicate = NSPredicate(format: "title CONTAINS[c] %@", searchBar.text ?? "")
//        }
//        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//        let moc = CoreDataStack.shared.mainContext
//        let fetchedResultsController = NSFetchedResultsController(fetchRequest: request,
//                                                                  managedObjectContext: moc,
//                                                                  sectionNameKeyPath: nil,
//                                                                  cacheName: nil)
//        do {
//            try fetchedResultsController.performFetch()
//        } catch {
//            print("could not fetch: \(error)")
//        }
//        frc = fetchedResultsController
//        tableView.reloadData()
//    }
}

extension HomeScreenTableViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .delete:
            guard let indexPath = indexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .automatic)
        case .move:
            guard let indexPath = indexPath,
                let newIndexPath = newIndexPath else { return }
            tableView.moveRow(at: indexPath, to: newIndexPath)
        case .update:
            guard let indexPath = indexPath else { return }
            tableView.reloadRows(at: [indexPath], with: .automatic)
        @unknown default:
            return
        }
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange sectionInfo: NSFetchedResultsSectionInfo,
                    atSectionIndex sectionIndex: Int,
                    for type: NSFetchedResultsChangeType) {

        let sectionSet = IndexSet(integer: sectionIndex)

        switch type {
        case .insert:
            tableView.insertSections(sectionSet, with: .automatic)
        case .delete:
            tableView.deleteSections(sectionSet, with: .automatic)
        default:
            return
        }
    }
}

extension HomeScreenTableViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        setupFRC()
    }
}
