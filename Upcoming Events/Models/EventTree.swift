//
//  EventTree.swift
//  Upcoming Events
//
//  Created by Alex Rodriguez on 27/12/21.
//

import Foundation
public struct EventTree {
    private (set) var root: Event? = nil
    
    private func insert(_ eventNode: Event?, _ newEventNode: Event) -> Event {
        guard let tmp = eventNode else { // Si el nodo no es nulo lo guardo en temp
            return newEventNode // de lo contrario retorno el nuevo nodo (nuevo evento)
        }
        
        if newEventNode.end > tmp.max { // Si la hora a la que termian el evento es mayor que la maxima guardada
            tmp.max = newEventNode.end  // Actualizo el Max del nodo actual
        }
        
        if (tmp < newEventNode) { // Si la hora a la que comienza el nuevo evento es mayor que la del evento actual debo ubicarlo a la derecha
            if tmp.right == nil { // si no hay hijo derecho
                tmp.right = newEventNode // le asigno el nuevo evento (nodo) al hijo derecho del nodo actual
            } else {
                _ = insert(tmp.right, newEventNode) // llamo recursivamente a l funcion insertar en el subarbol derecho del nodo actual
            }
        } else {  //Si la hora a la que comienza el nuevo evento es menor que la del evento (nodo) actual debo ubicarlo a la izquierda siguiendo el mismo procedimiento 
            if tmp.left == nil {
                tmp.left = newEventNode
            } else {
                _ = insert(tmp.left, newEventNode)
            }
        }
        return tmp
    }
    
    
    
    func overlaps(acc: inout [Event], eventNode: Event?, _ event: Event) {
        guard let tmp = eventNode else {
            return
        }
        
        if tmp != event  && ((tmp.start < event.end) && tmp.start >= event.start) {
            tmp.isConflicted = true
            acc.append(tmp)
        }
        
        if let l = tmp.left, l.max >= event.start {
            
            overlaps(acc: &acc, eventNode: l, event)
        }
        overlaps(acc: &acc, eventNode: tmp.right, event)
    }
    
    private func printTree(_ tree: Event? = nil) {
        if tree == nil {
            print("The tree is empty!")
            return
        }
        
        if let left = tree!.left {
            printTree(left)
        }
        
        print(tree!)
        
        if let right = tree!.right {
            printTree(right)
        }
    }
    
    public func printTree() {
        printTree(root)
    }
    
    mutating func insert(_ event: Event) {
        root = insert(root, event)
    }
    
    func overlaps(with event: Event) -> [Event]{
        var res = [Event]()
        overlaps(acc: &res, eventNode: root, event)
        return res
    }
}
