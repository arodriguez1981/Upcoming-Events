//
//  EventTree.swift
//  Upcoming Events
//
//  Created by Alex Rodriguez on 27/12/21.
//

import Foundation
public struct EventTree {
    private (set) var root: EventModel? = nil
    
    
    // Tiempo de ejecución (O log n)
    // El valor max de cada Nodo se actualiza de ser necesario con la hora fin del evento a insertar y sirve para determinar si debo buscar en la rama derecha o la izquierda del nodo a la hora de determinar el solapamiento haciendo la busqueda mas eficiente
    
    private func insert(_ eventNode: EventModel?, _ newEventNode: EventModel) -> EventModel {
        guard let tempNode = eventNode else { // Si el nodo no es nulo lo guardo en temp
            return newEventNode // de lo contrario retorno el nuevo nodo (nuevo evento)
        }
        
        if newEventNode.end > tempNode.max { // Si la hora a la que termian el evento es mayor que la maxima guardada
            tempNode.max = newEventNode.end  // Actualizo el Max del nodo actual (Este proceso se hara en todos loas ancestros de ese nodo) y permitira durante la busqueda de solapamiento determinar a cual rama moverme
        }
        
        if (tempNode < newEventNode) { // Si la hora a la que comienza el nuevo evento es mayor que la del evento actual debo ubicarlo a la derecha
            if tempNode.right == nil { // si no hay hijo derecho
                tempNode.right = newEventNode // le asigno el nuevo evento (nodo) al hijo derecho del nodo actual
            } else {
                _ = insert(tempNode.right, newEventNode) // llamo recursivamente a l funcion insertar en el subarbol derecho del nodo actual
            }
        } else {  //Si la hora a la que comienza el nuevo evento es menor que la del evento (nodo) actual debo ubicarlo a la izquierda siguiendo el mismo procedimiento 
            if tempNode.left == nil {
                tempNode.left = newEventNode
            } else {
                _ = insert(tempNode.left, newEventNode)
            }
        }
        return tempNode
    }
    
    // Funcion para encontrar los eventos que se solapan
    // eventNode ira tomando los datos del nodo que se esta visitando
    // event es el evento actual con el cual se estara buscando si hay solapamiento
    // Tiempo de ejecucion O(log n)
    private func overlaps(eventNode: EventModel?, _ event: EventModel) {
        guard let tempNode = eventNode else { // mientras haya eventos para comparar con el actual
            return
        }
        
        // Si no es el nodo actual y ademas la fecha de inicio del evento es menor que la fecha fin del evento actual
        // y la fecha de inicio del evento es mayor o igual que la fecha de inicio del evento actual
        if tempNode != event  && ((tempNode.start < event.end) && tempNode.start >= event.start) {
            tempNode.isConflicted = true  // marco el evento como solapado
        }
        if let tempLeft = tempNode.left, tempLeft.max >= event.start {
            
            overlaps(eventNode: tempLeft, event)
        }
        overlaps(eventNode: tempNode.right, event)
    }
    
    mutating func insert(_ event: EventModel) {
        root = insert(root, event)
    }
    
    mutating func overlaps(with event: EventModel){
        overlaps(eventNode: root, event)
    }
}
