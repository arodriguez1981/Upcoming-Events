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
                    self.events.append(contentsOf: currentEvents.sorted().reversed())
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
    
    func findConflicts1(_ events: [Event]){  // O(n) + O(n log n) = O(n log n)
        for i in 1...events.count - 1{   // O(n)
            // if hay elementos del mismo dia en los que la hora final de uno sea mayor que la hora inicial de otro entonces marco ese evento como conflictivo
            if (events[i - 1].end.day == events[i].start.day) && (events[i - 1].end.hour! > events[i].start.hour!){
                events[i].isConflicted = true
            }
        }
        self.eventsTable.reloadData()
    }
    
    func groupAndSort(){  // Agrupor y ordenar
        eventsByDay = Dictionary(grouping: self.events) { $0.start.day! }
        .sorted(by: {$0.key < $1.key})
        .map {$0.value}

        for i in 0...eventsByDay.count - 1{
            findConflicts(eventsByDay[i])
        }
    }
    
    func findConflicts(_ events: [Event]){
        var greaterElement = 0 // Para encontrar la hora mas alta del dia que voy a analizar
        for i in 0...events.count - 1{
            if greaterElement < events[i].end.hour! {
                greaterElement = events[i].end.hour!
            }
        }
        
        var auxHoursEvents = Array(repeating: 0 , count: greaterElement + 2) // Creo un arreglo del tamaño de la cantidad maxima de horas
        
        for i in 0...events.count - 1{
            let startHour = events[i].start.hour! // Hora inicial del evento
            let endHour = events[i].end.hour!  // Hora final del evento
            
            auxHoursEvents[startHour] = auxHoursEvents[startHour] + 1 // Incremento en 1 la posicion del arreglo que contiene la hora de inicio del evento
            auxHoursEvents[endHour + 1] = auxHoursEvents[endHour] - 1 // Decremento en 1 la posicion del arreglo que contiene la hora siguiente del final del evento
        }
        
        for i in 1...greaterElement - 1{
            auxHoursEvents[i] = auxHoursEvents[i - 1] + auxHoursEvents[i]
            if auxHoursEvents[i] > 1{
                events[i].isConflicted = true
            }
        }
        self.eventsTable.reloadData()
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
