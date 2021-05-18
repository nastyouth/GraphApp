//
//  UIView + Graph.swift
//  GraphApp
//
//  Created by Анастасия Ильина on 18.05.2021.
//
import UIKit


// MARK: - UIView
extension UIView {
    
    // Отрисовка графа
    func createGraph(_ graph: inout Graph, _ isNeededUpdate: Bool = false) {
        // Очистка графа при перерисовке
        subviews.forEach { $0.removeFromSuperview() }
        if isNeededUpdate {
            // Очистка от линий при перерисовке
            layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        }
        let center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        let radius = (bounds.width / 2) - 50
        var angle = CGFloat(2 * Double.pi)
        let count = graph.vertices.count
        let step = CGFloat(2 * Double.pi) / CGFloat(count)
        // Расположение элементов по кругу
        for index in 0..<count {
            let x = cos(angle) * radius + center.x
            let y = sin(angle) * radius + center.y
            graph.vertices[index].x = x
            graph.vertices[index].y = y
            let label = UILabel()
            label.text = "\(graph.vertices[index].value)"
            label.textAlignment = .center
            label.frame.size.width = 40
            label.frame.size.height = 40
            label.font = UIFont(name: "Arial", size: 17)
            label.textColor = .white
            label.backgroundColor = .systemBlue
            label.layer.cornerRadius = label.frame.size.height / 2
            label.layer.masksToBounds = true
            label.frame.origin.x = x - label.frame.midX
            label.frame.origin.y = y - label.frame.midY
            addSubview(label)
            angle += step
        }
    }
    
    // Отрисовка ребра
    func drawLine(startX: Int, endX: Int, startY: Int, endY: Int) {
        let layer = CALayer()
        layer.frame = bounds
        let path = UIBezierPath()
        path.move(to: CGPoint(x: startX, y: startY))
        path.addLine(to: CGPoint(x: endX, y: endY))
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = UIColor.systemBlue.cgColor
        shapeLayer.lineWidth = 2
        layer.addSublayer(shapeLayer)
        self.layer.insertSublayer(layer, at: 0)
    }
    
    // Создание скриншота
    func takeScreenshot() {
        // Создаем изображение с нашим контентом
        UIGraphicsBeginImageContext(frame.size)
        guard let graphics = UIGraphicsGetCurrentContext() else { return }
        layer.render(in: graphics)
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else { return }
        UIGraphicsEndImageContext()
        // Сохраняем изображение в галерею
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
    }
}
