import Foundation

typealias Position = (row: Int, col: Int)

enum CellState {
    case empty, alive, born, died
    
    var isAlive: Bool {
        switch self {
        case .alive, .born: return true
        case .empty, .died: return false
        }
    }
}

struct Cell {
    var position = Position(row: 0, col: 0)
    var state = CellState.empty
}

func norm(_ val: Int, to size: Int) -> Int {
    return ((val % size) + size) % size
}

func positions(rows: Int, cols: Int) -> [Position] {
    return (0 ..< rows)
        .map { zip( [Int](repeating: $0, count: cols) , 0 ..< cols ) }
        .flatMap { $0 }
        .map { Position(row: $0.0,col: $0.1) }
}

struct Grid {
    static let offsets: [Position] = [
        (row: -1, col:  1), (row: 0, col:  1), (row: 1, col:  1),
        (row: -1, col:  0),                    (row: 1, col:  0),
        (row: -1, col: -1), (row: 0, col: -1), (row: 1, col: -1)
    ]
    
    var rows: Int = 10
    var cols: Int = 10
    var cells: [[Cell]] = [[Cell]]()
    
    init(_ rows: Int,
         _ cols: Int,
         cellInitializer: (Int, Int) -> CellState = { _,_ in .empty } ) {
        
        cells = [[Cell]](repeatElement([Cell](repeatElement(Cell(position:Position(row:0, col:0), state: .empty), count: cols)), count: rows))
        
        positions(rows: rows, cols: cols).forEach { row, col in
            cells[row][col].position = Position(row: row, col: col)
            cells[row][col].state = cellInitializer(row, col)
        }
    }
}

extension Grid {
    func neighbors(of cell: Cell) -> [Position] {
        return Grid.offsets.map {
            return Position(row: norm($0.row + cell.position.row, to: self.rows),
                            col: norm($0.col + cell.position.col, to: self.cols))
        }
    }
}

extension Grid {
    var numLiving: Int {
        return positions(rows: self.rows, cols: self.cols).reduce(0) { total, position in
            cells[position.row][position.col].state.isAlive ? total + 1 : total
        }
    }
}

var grid = Grid(10, 10) { row, col in
    return arc4random_uniform(3) == 2 ? CellState.alive : CellState.empty
}

extension Grid {
    subscript (row: Int, col: Int) -> Cell? {
        get {
            return cells[norm(row, to: rows)][norm(col, to: cols)]
        }
        set {
            guard let val = newValue, row >= 0 && row < rows && col >= 0 && col < cols else { return }
            cells[norm(row, to: rows)][norm(col, to: cols)] = val
        }
    }
}

extension Grid {
    func livingNeighbors(of cell: Cell) -> Int {
        return self
            .neighbors(of: cell)
            .reduce(0) {
                guard let neighborCell = self[$1.row, $1.col] else { return $0 }
                return neighborCell.state.isAlive ? $0 + 1 : $0
        }
    }
}

extension Grid {
    func nextState(of cell: Cell) -> CellState {
        switch livingNeighbors(of: cell) {
        case 3,
             2 where cell.state.isAlive:
            return .alive
        default:
            return .empty
        }
    }
}

extension Grid {
    func next() -> Grid {
        var nextGrid = Grid(rows, cols)
        positions(rows: self.rows, cols: self.cols).forEach {
            nextGrid[$0.row,$0.col]!.state = nextState(of: self[$0.row,$0.col]!)
        }
        return nextGrid
    }
}

grid = grid.next()
grid.numLiving
