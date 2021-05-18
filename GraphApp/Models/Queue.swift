//
//  Queue.swift
//  GraphApp
//
//  Created by Анастасия Ильина on 18.05.2021.
//

// MARK: - Queue
struct Queue<T> {
    
    fileprivate var array = [T]()
    
    var count: Int {
        array.count
    }
    
    var isEmpty: Bool {
        array.isEmpty
    }
    
    mutating func enqueue(_ element: T) {
        array.append(element)
    }
    
    mutating func dequeue() -> T? {
        isEmpty ? nil : array.removeFirst()
    }
    
    var front: T? {
        array.first
    }
}
