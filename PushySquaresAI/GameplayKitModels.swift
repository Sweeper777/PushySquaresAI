
class PlayerModel: NSObject, GKGameModelPlayer {
    var playerId: Int {
        color.rawValue
    }

    let color: Color

    init(color: Color) {
        self.color = color
        super.init()
    }
}

class MoveModel: NSObject, GKGameModelUpdate {
    var value: Int = 0

    let move: Direction

    init(move: Direction) {
        self.move = move
        super.init()
    }
}