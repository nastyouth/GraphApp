//
//  ViewController.swift
//  GraphApp
//
//  Created by Анастасия Ильина on 14.05.2021.
//

import UIKit
import Foundation

// MARK: - GraphProtocol
protocol GraphProtocol: AnyObject {
    
    /// Добавить вершину
    /// - Parameter vertex: вершина
    func addVertex(_ vertex: Vertex)
    
    /// Удалить вершину
    /// - Parameter vertex: вершина
    func deleteVertex(_ vertex: Vertex)
    
    /// Удалить ребро
    /// - Parameters:
    ///   - vertex1: вершина 1
    ///   - vertex2: вершина 2
    func deleteEdge(vertex1: Int, vertex2: Int)

    /// Добавить ребро
    /// - Parameters:
    ///   - vertex1: вершина 1
    ///   - vertex2: вершина 2
    ///   - neededAppend: нужно ли добавлять ребра в модель (есть случаи, когда не нужно, см. перерисовку)
    func addEdge(_ vertex1: Int, _ vertex2: Int, _ neededAppend: Bool)
    
    /// Обход графа в ширину начиная с заданной вершины
    /// - Parameter startVertexValue: начальная вершина
    func bfs(_ startVertexValue: Int) -> String
    
    /// Возвращает список вершин, удаленных на расстояние n от вершины v
    /// - Parameters:
    ///   - vertex: вершина
    ///   - n: расстояние
    func d(vertex: Vertex, n: Int) -> String
    
    /// Сделать скриншот
    func takeScreenshot()
    
    /// Количество вершин
    var countVertices: Int { get }
    
    /// Количество ребер
    var countEdges: Int { get }
}

// MARK: - ViewController
class ViewController: UIViewController {
    
    var graph = Graph(vertices: [])
    var alerts: Alerts?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alerts = Alerts(delegate: self)
    }

    // Перерисовка ребер (например, после удаления какой-то вершины)
    func redrawingEdges() {
        graph.vertices.forEach { vertex in
            vertex.edges.forEach { edge in
                guard let findEdge = (graph.vertices.firstIndex { $0.value == edge }) else { return }
                addEdge(vertex.value, graph.vertices[findEdge].value, false)
            }
        }
    }
    
    @IBAction func openMenu(_ sender: Any) {
        alerts?.showActionSheet(self)
    }
}

// MARK: - ViewController + GraphProtocol
extension ViewController: GraphProtocol {
    
    func bfs(_ startVertexValue: Int) -> String {
        guard let index = (graph.vertices.firstIndex { $0.value == startVertexValue }) else { return "Вершина не найдена" }
        let startVertex = graph.vertices[index]
        var visited = [Int]()
        var queue = Queue<Vertex>()
        queue.enqueue(startVertex)
        while !queue.isEmpty {
            let dequeVertex = queue.dequeue()
            guard let dequeVertexValue = dequeVertex?.value else { fatalError() }
            if !visited.contains(dequeVertexValue) {
                dequeVertex?.edges.forEach { edge in
                    guard let edge = (graph.vertices.first { $0.value == edge }) else { fatalError() }
                    queue.enqueue(edge)
                }
                visited.append(dequeVertexValue)
            }
        }
        return visited.map { String($0) }.joined(separator: ", ")
    }
    
    func addVertex(_ vertex: Vertex) {
        guard !graph.vertices.contains(where: { $0.value == vertex.value }) else {
            alerts?.showAlert(with: "Ошибка!", "Вершина \(vertex.value) была добавлена ранее", self)
            return
        }
        graph.addVertex(vertex)
        view.createGraph(&graph, true)
        redrawingEdges()
    }
    
    func deleteVertex(_ vertex: Vertex) {
        graph.deleteVertex(vertex)
        view.createGraph(&graph, true)
        redrawingEdges()
    }
    
    func d(vertex: Vertex, n: Int) -> String {
        graph.d(vertex: vertex, n: n)
    }
    
    func addEdge(_ vertex1: Int, _ vertex2: Int, _ neededAppend: Bool = true) {
        guard let indexV1 = (graph.vertices.firstIndex { $0.value == vertex1 }) else {
            self.alerts?.showAlert(with: "Ошибка!", "Вершина \(vertex1) не найдена", self)
            return
        }
        guard let indexV2 = (graph.vertices.firstIndex { $0.value == vertex2 }) else {
            self.alerts?.showAlert(with: "Ошибка!", "Вершина \(vertex2) не найдена", self)
            return
        }
        if neededAppend {
            graph.vertices[indexV1].edges.append(vertex2)
            graph.vertices[indexV2].edges.append(vertex1)
        }
        view.drawLine(startX: Int(graph.vertices[indexV1].x), endX: Int(graph.vertices[indexV2].x), startY: Int(graph.vertices[indexV1].y), endY: Int(graph.vertices[indexV2].y))
    }
    
    func deleteEdge(vertex1: Int, vertex2: Int) {
        guard let indexV1 = (graph.vertices.firstIndex { $0.value == vertex1 }) else {
            self.alerts?.showAlert(with: "Ошибка!", "Вершина \(vertex1) не найдена", self)
            return
        }
        guard let indexV2 = (graph.vertices.firstIndex { $0.value == vertex2 }) else {
            self.alerts?.showAlert(with: "Ошибка!", "Вершина \(vertex2) не найдена", self)
            return
        }
        guard let indexE1 = (graph.vertices[indexV1].edges.firstIndex { $0 == vertex2 }) else { return }
        guard let indexE2 = (graph.vertices[indexV2].edges.firstIndex { $0 == vertex1 }) else { return }
        graph.vertices[indexV1].deleteEdge(indexE1)
        graph.vertices[indexV2].deleteEdge(indexE2)
        view.createGraph(&graph, true)
        redrawingEdges()
    }
    
    func takeScreenshot() {
        view.takeScreenshot()
    }
    
    var countVertices: Int {
        graph.countVertices
    }
    
    var countEdges: Int {
        graph.countEdges
    }
}
