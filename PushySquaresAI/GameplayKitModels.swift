import GameplayKit

class GameModel: NSObject, GKGameModel {
    var game: Game

    var myColor: Color {
        game.currentPlayer.color
    }

    required init(game: Game) {
        self.game = game
        super.init()
    }

    var players: [GKGameModelPlayer]? = [PlayerModel(color: .red), PlayerModel(color: .green)]

    var activePlayer: GKGameModelPlayer? {
        if game.currentPlayer.color == .green {
            return players![1]
        } else {
            return players![0]
        }
    }

    func setGameModel(_ gameModel: GKGameModel) {
        game = (gameModel as! GameModel).game.createCopy()
    }

    func gameModelUpdates(for player: GKGameModelPlayer) -> [GKGameModelUpdate]? {
        [Direction.right, .up, .left, .down].map(MoveModel.init)
    }

    func apply(_ gameModelUpdate: GKGameModelUpdate) {
        game.moveInDirection((gameModelUpdate as! MoveModel).move)
    }

    func copy(with zone: NSZone? = nil) -> Any {
        type(of: self).init(game: game.createCopy())
    }

    func isLoss(for player: GKGameModelPlayer) -> Bool {
        game.player(Color(rawValue: player.playerId)!).lives < 1
    }

    func isWin(for player: GKGameModelPlayer) -> Bool {
        game.players.filter { $0.lives > 0 }.first?.color.rawValue == player.playerId
    }

//    func score(for player: GKGameModelPlayer) -> Int {
//        let unclamped = evaluate(game, game.currentPlayer.color,
//                9817,
//                3256,
//                2,
//                6212,
//                3272,
//                4225,
//                6744,
//                2582,
//                5886)
//        return max(GKGameModelMinScore, min(unclamped, GKGameModelMaxScore))
//    }
}

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