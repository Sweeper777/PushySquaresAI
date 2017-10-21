import Foundation

func printBoard(_ board: Array2D<Tile>) {
    for y in 0..<board.columns {
        for x in 0..<board.rows {
            switch board[x, y] {
            case .empty:
                print("⬜️", separator: "", terminator: "")
            case .wall:
                print("🔲", separator: "", terminator: "")
            case .void:
                print("▫️", separator: "", terminator: "")
            case .square(let color):
                switch color {
                case .color1:
                    print("🚹", separator: "", terminator: "")
                case .color2:
                    print("🚺", separator: "", terminator: "")
                case .color3:
                    print("🚼", separator: "", terminator: "")
                case .color4:
                    print("❇️", separator: "", terminator: "")
                case .grey:
                    print("ℹ️", separator: "", terminator: "")
                }
            }
        }
        print("")
    }
}

func printGame(_ game: Game) {
    let colorToCharatcer = [Color.color1: "🚹", .color2: "🚺", .color3: "🚼", .color4: "❇️"]
    print("--------------")
    print("New Square In: \(game.currentPlayer.turnsUntilNewSquare)")
    print("Current Turn: \(colorToCharatcer[game.currentPlayer.color]!)")
    print("Lives: ", separator: "", terminator: "")
    for player in game.players {
        print("\(colorToCharatcer[player.color]!)\(player.lives) ", separator: "", terminator: "")
    }
    print()
    print("--------------")
    printBoard(game.board)
}

