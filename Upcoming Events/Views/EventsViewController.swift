//
//  EventsViewController.swift
//  Upcoming Events
//
//  Created by Alex Rodriguez on 22/12/21.
//

import UIKit

class EventsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var eventsTable: UITableView!
    var eventsViewModel : EventsViewModel! // Relacion solo con ViewModel
    
    override func viewDidLoad() {
        super.viewDidLoad()
        eventsViewModel = EventsViewModel()
        eventsViewModel.loadEvents()
        self.eventsTable.reloadData()
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        eventsViewModel.eventsByDay.count 
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let day = Formatter.customDate.string(from: eventsViewModel.eventsByDay[section][0].start)
        let label = UILabel()
        label.text = day
        return label
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventsViewModel.eventsByDay[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let eventCell = (tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath ) as? EventCell)!
        
        eventCell.eventName.text = "Event: ".appending(eventsViewModel.eventsByDay[indexPath.section][indexPath.row].title!)
        eventCell.eventDateTime.text = eventsViewModel.eventsByDay[indexPath.section][indexPath.row].description
        eventCell.eventConflict.isHidden = !eventsViewModel.eventsByDay[indexPath.section][indexPath.row].isConflicted
        
        return eventCell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }

}
