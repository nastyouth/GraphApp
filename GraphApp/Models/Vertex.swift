//
//  Vertex.swift
//  GraphApp
//
//  Created by Анастасия Ильина on 18.05.2021.
//

import UIKit

// MARK: - Vertex
struct Vertex {
    
    // Значение вершины
    let value: Int
    // Массив ребер этой вершины (индексы вершин, с которыми соединена вершина)
    var edges: [Int]
    // Координаты
    var x: CGFloat
    var y: CGFloat
    var visited: Bool
    
    // Удаление ребра
    mutating func deleteEdge(_ index: Int) {
        edges.remove(at: index)
    }
    
    init(value: Int, edges: [Int] = [], x: CGFloat = 0, y: CGFloat = 0, visited: Bool = false) {
        self.value = value
        self.edges = edges
        self.x = x
        self.y = y
        self.visited = visited
    }
}
