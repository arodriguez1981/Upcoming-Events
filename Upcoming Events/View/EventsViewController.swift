//
//  EventsViewController.swift
//  Upcoming Events
//
//  Created by Alex Rodriguez on 22/12/21.
//

import UIKit

class EventsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var eventsTable: UITableView!
    
    
    
    
    var events = [Event]()
    var eventsByDay = Array<[Event]>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadJSON()
        
        // Do any additional setup after loading the view.
    }
    
    func loadJSON(){
        if let path = Bundle.main.path(forResource: "mock", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .formatted(Formatter.customDateTime)
                // Ahora obtendre los datos desde el JSON utilizando la estructura Event y Codable
                do {
                    self.events.removeAll(keepingCapacity: false)
                    let currentEvents = try decoder.decode([Event].self, from: data)
                    self.events.append(contentsOf: currentEvents.sorted())
                    //self.findConflicts1()
                    groupAndSort()
                    
                    
                }catch{
                    print(error)
                    print("Fallo la decodificacion")
                }
                
            } catch {
                print(error)
                print("No se pudo leer desde el fichero")
            }
        }
    }
    
    
    func groupAndSort(){  // Agrupor y ordenar
        
        eventsByDay = Dictionary(grouping: self.events) { $0.start.day! }
        .sorted(by: {$0.key < $1.key})
        .map {$0.value}
        
//
//
//        for i in 0...currentEventsByDay.count - 1{
//            let current = currentEventsByDay[i].sorted()
//            eventsByDay.append(contentsOf: current)
//        }

        for i in 0...eventsByDay.count - 1{
            findConflicts(eventsByDay[i])
        }
        self.eventsTable.reloadData()
    }
    
    func findConflicts(_ events: [Event]){
        var eventTree = EventTree()
        for event in events {
            eventTree.insert(event)
        }
        //eventTree.printTree()
        var overlaps = [Event]()

        for event in events {
            print("Intersections with \(event): \(eventTree.overlaps(with:event))")
            overlaps.append(contentsOf: eventTree.overlaps(with:event))
            //eventTree.overlaps(with:event)
            //print(overlaps)
        }
        
        
        
        
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        eventsByDay.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let day = Formatter.customDate.string(from: eventsByDay[section][0].start)
        let label = UILabel()
        label.text = day
        return label
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventsByDay[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let eventCell = (tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath ) as? EventCell)!
        
        eventCell.eventName.text = "Event: ".appending(eventsByDay[indexPath.section][indexPath.row].title!)
        eventCell.eventDateTime.text = eventsByDay[indexPath.section][indexPath.row].description
        eventCell.eventConflict.isHidden = !eventsByDay[indexPath.section][indexPath.row].isConflicted
        
        return eventCell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
