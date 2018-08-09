//
//  XView.swift
//  Lecture4
//
//  Created by 김수빈 on 16/07/2018.
//  Copyright © 2018 김수빈. All rights reserved.
//

import UIKit

protocol GridViewDataSource {
    subscript (pos: Position) -> CellState { get set }
    var row: Int { get set }
    var col: Int { get set }
}

@IBDesignable class GridView: UIView {
    
    @IBInspectable var lineColor: UIColor = .lightGray
    @IBInspectable var aliveColor: UIColor = .green
    @IBInspectable var deadColor: UIColor = .black
    @IBInspectable var size: Int = 10{
        didSet {
            dataSource?.row = size
            dataSource?.col = size
        }
    }
    
    @IBInspectable var lineWidth: CGFloat = 2.0
    @IBInspectable var inset: CGFloat = 2.0
    
    var dataSource: GridViewDataSource?
    
    fileprivate func drawLine(from startPoint: CGPoint, to endPoint: CGPoint) {
        let path = UIBezierPath()
        path.lineWidth = lineWidth
        path.move(to: startPoint)
        path.addLine(to: endPoint)
        lineColor.setStroke()
        path.stroke()
    }
    
    fileprivate func drawCircle(row: Int, col: Int, rect: CGRect) {
        guard let dataSource = dataSource else { return }
        var color: UIColor = .clear
        switch dataSource[(row,col)]{
        case .alive, .born: color = aliveColor
        case .died, .empty: color = deadColor
        }
        
        let path = UIBezierPath(ovalIn: rect)
        color.setFill()
        path.fill()
    }
    
    fileprivate func drawLines(rect: CGRect, hSpacing: CGFloat, hStart: CGFloat, hEnd: CGFloat, vSpacing: CGFloat, vStart: CGFloat, vEnd: CGFloat) {
        (0 ... size).forEach { index in
            let x = CGFloat(index) * hSpacing + rect.origin.x
            let y = CGFloat(index) * vSpacing + rect.origin.y
            
            var startPoint = CGPoint(x: hStart, y: y)
            var endPoint = CGPoint(x: hEnd, y: y)
            drawLine(from: startPoint, to: endPoint)
            
            startPoint = CGPoint(x: x, y: vStart)
            endPoint = CGPoint(x: x, y: vEnd)
            drawLine(from: startPoint, to: endPoint)
        }
    }
    
    override func draw(_ rect: CGRect) {
        
        size = (dataSource?.row)!
        
        let rect = CGRect (
            x: rect.origin.x + (lineWidth/2.0),
            y: rect.origin.y + (lineWidth/2.0),
            width: rect.size.width - lineWidth,
            height: rect.size.height - lineWidth
        )
        
        let hSpacing = rect.size.width / CGFloat(size)
        let hStart = rect.origin.x
        let hEnd = rect.origin.x + rect.size.width
        
        let vSpacing = rect.size.height / CGFloat(size)
        let vStart = rect.origin.y
        let vEnd = rect.origin.y + rect.size.height
        
        drawLines(rect: rect, hSpacing: hSpacing, hStart: hStart, hEnd: hEnd, vSpacing: vSpacing, vStart: vStart, vEnd: vEnd)
        
        //Drawing circles (or ovals) onto the grid
        let positionArray = positionSequence(from: (0,0), to: (size,size))
        positionArray.forEach { (row, col) in
            let xOrigin = (CGFloat(col) * vSpacing) + rect.origin.x
            let yOrigin = (CGFloat(row) * hSpacing) + rect.origin.y
            let cellRect = CGRect(
                x: xOrigin + inset + (lineWidth/2.0),
                y: yOrigin + inset + (lineWidth/2.0),
                width: vSpacing - ((2.0 * inset) + (lineWidth)),
                height: hSpacing - ((2.0 * inset) + (lineWidth))
            )
            
            drawCircle(row: row, col: col, rect: cellRect)
        }
        
    }
    
    func convert(touches: Set<UITouch>) -> Position? {
        guard touches.count == 1 else { return nil }
        let touch = touches.first!
        
        let touchY = touch.location(in: self).y - (lineWidth / 2.0)
        let gridHeight = frame.size.height - lineWidth
        let row = touchY / gridHeight * CGFloat(size)
        
        let touchX = touch.location(in: self).x - (lineWidth / 2.0)
        let gridWidth = frame.size.width - lineWidth
        let col = touchX / gridWidth * CGFloat(size)
        
        let pos = Position(row: Int(row), col: Int(col))
        guard pos.row >= 0 && pos.row < size && pos.col >= 0 && pos.col < size else { return nil }
        
        return pos
    }
    
    func redisplay(position pos: Position) {
        guard var dataSource = dataSource else { return }
        dataSource[pos] = dataSource[pos].isAlive ? .empty : .alive
        lastTouchedPosition = pos
        setNeedsDisplay()
    }
    
    var lastTouchedPosition: Position?
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        guard let pos = convert(touches: touches) else { return }
        redisplay(position: pos)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let pos = convert(touches: touches) else { return }
        guard pos.row != lastTouchedPosition?.row || pos.col != lastTouchedPosition?.col else { return }
        redisplay(position: pos)
    }
}
