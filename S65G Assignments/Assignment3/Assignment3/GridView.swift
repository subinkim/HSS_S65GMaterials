//
//  GridView.swift
//  Assignment3
//
//  Created by 김수빈 on 13/07/2018.
//  Copyright © 2018 Harvard University. All rights reserved.
//

import UIKit

@IBDesignable class GridView: UIView {
    
    @IBInspectable var livingColor: UIColor = .orange
    @IBInspectable var emptyColor: UIColor = .black
    @IBInspectable var bornColor: UIColor = .green
    @IBInspectable var diedColor: UIColor = .red
    
    @IBInspectable var gridColor: UIColor = .blue
    
    @IBInspectable var gridWidth: CGFloat = 1.0
    @IBInspectable var inset: CGFloat = 2.0
    
    @IBInspectable var size: Int = 20 {
        didSet{
            grid = Grid(size,size)
            //set the default state to empty -> declared a initializer called
            //"defaultInitializer" which sets every cell to 'empty' state
            //and used it to call the grid
        }
    }
    
    var grid: Grid = Grid(10,10){
        didSet{
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        //inner rectangle
        let rect = CGRect (
            x: rect.origin.x + (gridWidth/2.0),
            y: rect.origin.y + (gridWidth/2.0),
            width: rect.size.width - gridWidth,
            height: rect.size.height - gridWidth
        )
        
        //constants declared
        let verticalSpacing = rect.size.height / CGFloat(size)
        let horizontalSpacing = rect.size.width / CGFloat(size)
        let horizontalXStart = rect.origin.x
        let horizontalXEnd = rect.origin.x + rect.size.width
        let verticalYStart = rect.origin.y
        let verticalYEnd = rect.origin.y + rect.size.height
        
        //Horizontal lines
        (0 ... size).forEach { index in
            let yStart = CGFloat(index) * verticalSpacing + rect.origin.y
            let startPoint = CGPoint(x: horizontalXStart, y: yStart)
            
            let yEnd = yStart
            let endPoint = CGPoint(x: horizontalXEnd, y: yEnd)
            
            let horizontalPath = UIBezierPath()
            horizontalPath.lineWidth = gridWidth
            horizontalPath.move(to: startPoint)
            horizontalPath.addLine(to: endPoint)
            gridColor.setStroke()
            horizontalPath.stroke()
        }
        
        //Vertical lines
        (0 ... size).forEach { index in
            let xStart = CGFloat(index) * horizontalSpacing + rect.origin.x
            let startPoint = CGPoint(x: xStart, y: verticalYStart)
            
            let xEnd = xStart
            let endPoint = CGPoint(x: xEnd, y: verticalYEnd)
            
            let verticalPath = UIBezierPath()
            verticalPath.lineWidth = gridWidth
            verticalPath.move(to: startPoint)
            verticalPath.addLine(to: endPoint)
            gridColor.setStroke()
            verticalPath.stroke()
        }
        
        //Drawing circles onto the grid
        let positionArray = positionSequence(from: (0,0), to: (size,size))
        positionArray.forEach { (row, col) in
            let xOrigin = (CGFloat(col) * verticalSpacing) + rect.origin.x
            let yOrigin = (CGFloat(row) * horizontalSpacing) + rect.origin.y
            let cellRect = CGRect(
                x: xOrigin + inset + (gridWidth/2.0),
                y: yOrigin + inset + (gridWidth/2.0),
                width: verticalSpacing - ((2.0 * inset) + (gridWidth)),
                height: horizontalSpacing - ((2.0 * inset) + (gridWidth))
            )
            
            var color: UIColor = .clear
            switch grid[(row,col)]{
            case .alive: color = livingColor
            case .born: color = bornColor
            case .empty: color = emptyColor
            case .died: color = diedColor
            }
            
            let path = UIBezierPath(ovalIn: cellRect)
            color.setFill()
            path.fill()
        }
    }
    
    func convert(touch: UITouch) -> Position? {
        let touchY = touch.location(in: self).y - (gridWidth / 2.0)
        let gridH = frame.size.height - gridWidth
        let row = touchY / gridH * CGFloat(size)
        
        let touchX = touch.location(in: self).x - (gridWidth / 2.0)
        let gridW = frame.size.width - gridWidth
        let col = touchX / gridW * CGFloat(size)
        
        let pos = Position(row: Int(row), col: Int(col))
        guard pos.row >= 0 && pos.row < size && pos.col >= 0 && pos.col < size else { return nil }
        
        return pos
    }
    
    var lastTouchedPosition: Position?
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        guard touches.count == 1 else { return }
        let touch = touches.first!
        guard let pos = convert(touch: touch) else { return }
        let state = grid[pos]
        grid[pos] = state.toggle(value: state)
        lastTouchedPosition = pos
        setNeedsDisplay()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard touches.count == 1 else { return }
        let touch = touches.first!
        guard let pos = convert(touch: touch) else { return }
        guard pos.row != lastTouchedPosition?.row || pos.col != lastTouchedPosition?.col else { return }
        let state = grid[pos]
        grid[pos] = state.toggle(value: state)
        lastTouchedPosition = pos
        setNeedsDisplay()
    }
}
