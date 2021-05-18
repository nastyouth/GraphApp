//
//  Alerts.swift
//  GraphApp
//
//  Created by Анастасия Ильина on 18.05.2021.
//

import UIKit

// MARK: - Alerts
class Alerts {
    
    enum AlertType {
        case addVertex
        case deleteVertex
        case addEdge
        case deleteEdge
        case countVertex
        case countEdge
        case dvn
        case bfs
        case save
        
        var title: String {
            switch self {
            case .addEdge:
                return "Добавить ребро"
            case .addVertex:
                return "Добавить вершину"
            case .deleteVertex:
                return "Удалить вершину"
            case .deleteEdge:
                return "Удалить ребро"
            case .countVertex:
                return "Количество вершин"
            case .countEdge:
                return "Количество ребер"
            case .dvn:
                return "Cписок вершин, удаленных на расстояние n от вершины v"
            case .bfs:
                return "Обход графа в ширину начиная с заданной вершины"
            case .save:
                return "Сохранение графа"
            }
        }
        var message: String {
            switch self {
            case .addEdge:
                return "Введите 2 вершины, которые хотите соединить"
            case .addVertex:
                return "Введите вершину, которую хотите добавить"
            case .deleteVertex:
                return "Введите вершину, которую хотите удалить"
            case .deleteEdge:
                return "Введите вершины ребра, которые хотите удалить"
            case .countVertex:
                return "Количество вершин"
            case .countEdge:
                return "Количество ребер"
            case .dvn:
                return "Введите вершину и расстояние"
            case .bfs:
                return "Обход графа в ширину начиная с заданной вершины"
            case .save:
                return "Граф сохранен!"
            }
        }
        var buttonTitle: String {
            switch self {
            case .addEdge, .addVertex:
                return "Добавить"
            case .deleteVertex, .deleteEdge:
                return "Удалить"
            case .countVertex, .countEdge, .dvn:
                return "Получить"
            case .bfs:
                return "Обойти"
            case .save:
                return "Сохранить"
            }
        }
    }
    
    private weak var delegate: GraphProtocol?
    
    init(delegate: GraphProtocol) {
        self.delegate = delegate
    }
    
    func showActionSheet(_ controller: UIViewController) {
        let alert = UIAlertController(title: "Меню", message: "Выберите действие", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Добавить вершину", style: .default) { _ in
            self.showAlert(with: .addVertex, controller)
        })
        alert.addAction(UIAlertAction(title: "Соединить две вершины", style: .default) { _ in
            self.showAlert(with: .addEdge, controller)
        })
        alert.addAction(UIAlertAction(title: "Получить количество вершин", style: .default) { _ in
            guard let count = self.delegate?.countVertices else { return }
            self.showAlert(with: AlertType.countVertex.title, String(count), controller)
        })
        alert.addAction(UIAlertAction(title: "Получить количество ребер", style: .default) { _ in
            guard let count = self.delegate?.countEdges else { return }
            self.showAlert(with: AlertType.countEdge.title, String(count), controller)
        })
        alert.addAction(UIAlertAction(title: "Список вершин, удаленных от вершины на расстояние n", style: .default) { _ in
            self.showAlert(with: .dvn, controller)
        })
        alert.addAction(UIAlertAction(title: "Обход в ширину", style: .default) { _ in
            self.showAlert(with: .bfs, controller)
        })
        alert.addAction(UIAlertAction(title: "Сохранить граф", style: .default) { _ in
            self.delegate?.takeScreenshot()
            self.showAlert(with: AlertType.save.title, AlertType.save.message, controller)
        })
        alert.addAction(UIAlertAction(title: "Удалить вершину", style: .destructive) { _ in
            self.showAlert(with: .deleteVertex, controller)
        })
        alert.addAction(UIAlertAction(title: "Удалить ребро", style: .destructive) { _ in
            self.showAlert(with: .deleteEdge, controller)
        })
        alert.addAction(UIAlertAction(title: "Закрыть", style: .cancel))
        
        controller.present(alert, animated: true)
    }
    
    func showAlert(with title: String, _ message: String, _ controller: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(.init(title: "Ок", style: .default, handler: nil))
        controller.present(alert, animated: true, completion: nil)
    }
    
    func showAlert(with type: AlertType, _ controller: UIViewController) {
        let alert = UIAlertController(title: type.title, message: type.message, preferredStyle: .alert)
        var firstPlaceholder = ""
        var secondPlaceholder = ""
        var neededSecondPlaceholder = false
        switch type {
        case .addVertex, .deleteVertex:
            firstPlaceholder = "Название вершины"
            neededSecondPlaceholder = false
        case .addEdge, .deleteEdge:
            firstPlaceholder = "Вершина 1"
            secondPlaceholder = "Вершина 2"
            neededSecondPlaceholder = true
        case .dvn:
            firstPlaceholder = "Вершина"
            secondPlaceholder = "Расстояние"
            neededSecondPlaceholder = true
        case .bfs, .countVertex, .save, .countEdge:
            break
        }
        alert.addTextField { $0.placeholder = firstPlaceholder }
        if neededSecondPlaceholder {
            alert.addTextField { $0.placeholder = secondPlaceholder }
        }

        alert.addAction(UIAlertAction(title: "Закрыть", style: .cancel))
        alert.addAction(UIAlertAction(title: type.buttonTitle, style: .default) { [weak alert] _ in
            let firstTextField = alert?.textFields?.first
            var secondTextField: UITextField?
            if neededSecondPlaceholder {
                secondTextField = alert?.textFields?[1]
            }
            switch type {
            case .addVertex:
                guard let vertex = Int(firstTextField?.text ?? "") else { return }
                self.delegate?.addVertex(.init(value: vertex))
            case .deleteVertex:
                guard let vertex = Int(firstTextField?.text ?? "") else { return }
                self.delegate?.deleteVertex(.init(value: vertex))
            case .addEdge:
                guard let firstVertex = Int(firstTextField?.text ?? "") else { return }
                guard let secondVertex = Int(secondTextField?.text ?? "") else { return }
                self.delegate?.addEdge(firstVertex, secondVertex, true)
            case .deleteEdge:
                guard let vertex1 = Int(firstTextField?.text ?? "") else { return }
                guard let vertex2 = Int(secondTextField?.text ?? "") else { return }
                self.delegate?.deleteEdge(vertex1: vertex1, vertex2: vertex2)
            case .dvn:
                guard let vertex = Int(firstTextField?.text ?? "") else { return }
                guard let n = Int(secondTextField?.text ?? "") else { return }
                guard let vertices = self.delegate?.d(vertex: .init(value: vertex), n: n) else { return }
                self.showAlert(with: type.title, vertices, controller)
            case .bfs:
                guard let vertex = Int(firstTextField?.text ?? "") else { return }
                guard let bfsResult = self.delegate?.bfs(vertex) else { return }
                self.showAlert(with: type.title, bfsResult, controller)
            case .countVertex, .countEdge, .save:
                 break
            }
        })
        controller.present(alert, animated: true)
    }
}
