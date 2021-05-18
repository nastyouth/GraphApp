//
//  Graph.swift
//  GraphApp
//
//  Created by Анастасия Ильина on 18.05.2021.
//

// MARK: - Graph
struct Graph {
    
    // Массив вершин
    var vertices: [Vertex]
    
    // Добавление вершины
    mutating func addVertex(_ vertex: Vertex) {
        vertices.append(vertex)
    }
    
    // Удаление вершины
    mutating func deleteVertex(_ vertex: Vertex) {
        // Индекс удаленной вершины в массиве вершин
        guard let index = (vertices.firstIndex { $0.value == vertex.value }) else { return }
        vertices.remove(at: index)
        // Удаляем у других вершин связь с вершиной, которую мы удаляем
        for i in 0..<vertices.count {
            guard let index = (vertices[i].edges.firstIndex { $0 == vertex.value }) else { return }
            vertices[i].deleteEdge(index)
        }
    }
    
    // Возвращает список вершин, удаленных на расстояние n от вершины v
    mutating func d(vertex: Vertex, n: Int) -> String {
        var resultVertices = [Int]()
        // Индекс вершины в массиве вершин
        guard let index = (vertices.firstIndex { $0.value == vertex.value }) else { return "Вершина не найдена" }
        resultVertices.append(index + n)
        if index - n > 0 {
            resultVertices.append(index - n)
        } else {
            resultVertices.append(vertices.count + index - n)
        }
        return resultVertices.map { String($0) }.joined(separator: ", ")
    }
    
    // Количество вершин
    var countVertices: Int {
        return vertices.count
    }
    
    // Количество ребер
    var countEdges: Int {
        vertices.reduce(0) { $0 + $1.edges.count } / 2
    }
}
