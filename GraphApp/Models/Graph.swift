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
    mutating func d(_ startVertexValue: Int, _ n: Int) -> String {
        var resultArray = [Int]()
        var count = 0
        guard let index = (vertices.firstIndex { $0.value == startVertexValue }) else { return "Вершина не найдена" }
        let startVertex = vertices[index]
        var visited = [Int]()
        var queue = Queue<Vertex>()
        queue.enqueue(startVertex)
        while !queue.isEmpty {
            let dequeVertex = queue.dequeue()
            guard let dequeVertexValue = dequeVertex?.value else { fatalError() }
            if !visited.contains(dequeVertexValue) {
                dequeVertex?.edges.forEach { edge in
                    guard let edge = (vertices.first { $0.value == edge }) else { fatalError() }
                    queue.enqueue(edge)
                }
                visited.append(dequeVertexValue)
                count += 1
                if count > n {
                    resultArray.append(dequeVertexValue)
                }
            }
        }
        if resultArray.isEmpty {
            return "Не найдено"
        } else {
            return resultArray.map { String($0) }.joined(separator: ", ")
        }
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
