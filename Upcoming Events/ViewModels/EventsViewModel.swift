//
//  EventsViewModel.swift
//  Upcoming Events
//
//  Created by Alex Rodriguez on 28/12/21.
//

import Foundation
import UIKit

struct EventsViewModel{
    var events : [EventModel]  // Relcion solo con el Model
    var eventsByDay : Array<[EventModel]>
    
    init(){
        self.events = [EventModel]()
        self.eventsByDay = Array<[EventModel]>()
    }
    
    mutating func loadEvents(){  // Cargo los datos del fichero JSON
        if let path = Bundle.main.path(forResource: "mock", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .formatted(Formatter.customDateTime)
                // Ahora obtendre los datos desde el JSON utilizando la estructura EventModel y Codable
                do {
                    events.removeAll(keepingCapacity: false)
                    events = try decoder.decode([EventModel].self, from: data).sorted() //guardo todos los eventos en el arreglo (ya ordenados)
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
    
    mutating func groupAndSort(){  // Agrupar y ordenar
        
        self.eventsByDay = Dictionary(grouping: self.events) { $0.start.day! } // Creo un diccionario utilizando el día como llave
        .sorted(by: {$0.key < $1.key}) // y lo ordeno de menor a mayor
        .map {$0.value} // mapeando solo los valores (Que se almacenan en el arreglo de eventos)

        for i in 0...eventsByDay.count - 1{ // Recorro el arreglo de eventos ya agrupados por dias del mes
            findConflicts(eventsByDay[i]) // Y por cada día busco los conflictos entre ellos
        }
    }
    
    func findConflicts(_ events: [EventModel]){
        var eventTree = EventTree() // Se creara un arbol por cada dia
        for event in events { // Por cada evento inserto un nodo en el arbol
            eventTree.insert(event) // La insercion en un arbol aumentado tomo O(log n) siendo n el numero de nodos en el arbol antes de la insercion
        }
        for event in events {
            eventTree.overlaps(with:event)
        }
    }
    
}
