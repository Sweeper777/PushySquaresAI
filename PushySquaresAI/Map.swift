public struct Map {
    public let board: Array2D<Tile>
    public let spawnpoints: [Color: Position]
    
    public static let standard = Map(board: [
        [.void, .void,  .void,  .void,  .wall,  .wall,  .void,  .void,  .void,  .void,],
        [.void, .empty, .empty, .empty, .empty, .empty, .empty, .empty, .empty, .void],
        [.void, .empty, .empty, .empty, .empty, .empty, .empty, .empty, .empty, .void],
        [.void, .empty, .empty, .empty, .empty, .empty, .empty, .empty, .empty, .void],
        [.wall, .empty, .empty, .empty, .wall,  .wall,  .empty, .empty, .empty, .wall],
        [.wall, .empty, .empty, .empty, .wall,  .wall,  .empty, .empty, .empty, .wall],
        [.void, .empty, .empty, .empty, .empty, .empty, .empty, .empty, .empty, .void],
        [.void, .empty, .empty, .empty, .empty, .empty, .empty, .empty, .empty, .void],
        [.void, .empty, .empty, .empty, .empty, .empty, .empty, .empty, .empty, .void],
        [.void, .void,  .void,  .void,  .wall,  .wall,  .void,  .void,  .void,  .void,]
        ], spawnpoints: [
            .color1: Position(1, 1),
            .color2: Position(8, 1),
            .color3: Position(8, 8),
            .color4: Position(1, 8)
        ])
    
    public init(board: Array2D<Tile>, spawnpoints: [Color: Position]) {
        self.board = board
        self.spawnpoints = spawnpoints
    }
    
    public init(file name: String) {
        let fileContents = try! String(contentsOfFile: "/Users/mulangsu/Documents/PushySquaresAI/PushySquaresAI/\(name).map")
        let dict: [Character: Tile] = [
            ".": .void,
            "+": .empty,
            "O": .wall,
            "g": .square(.grey)
        ]
        let lines = fileContents.components(separatedBy: "\n").filter({!$0.isEmpty})
        var board = Array2D<Tile>(columns: lines.first!.count, rows: lines.count, initialValue: .void)
        var spawnpoints = [Color: Position]()
        for (x, line) in lines.enumerated() {
            for (y, c) in line.enumerated() {
                board[x, y] = dict[c] ?? .empty
                switch c {
                case "1":
                    spawnpoints[.color1] = Position(x, y)
                case "2":
                    spawnpoints[.color2] = Position(x, y)
                case "3":
                    spawnpoints[.color3] = Position(x, y)
                case "4":
                    spawnpoints[.color4] = Position(x, y)
                default: break
                }
            }
        }
        self.board = board
        self.spawnpoints = spawnpoints
    }
}
