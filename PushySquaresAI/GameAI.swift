
extension Game {
    func createCopy() -> Game {
        return Game(game: self)
    }
    
    func player(_ color: Color) -> Player {
        return players.filter { $0.color == color }.first!
    }
    
    func opponents(to color: Color) -> [Color] {
        return players.filter { $0.color != color }.map { $0.color }
    }
    
    func moveInDirection(_ direction: Direction) {
        switch direction {
        case .up: moveUp()
        case .down: moveDown()
        case .left: moveLeft()
        case .right: moveRight()
        }
    }
}

extension Player {
    func createCopy() -> Player {
        return Player(turnsUntilNewSquare: self.turnsUntilNewSquare, lives: self.lives, color: self.color)
    }
}

class GameAI {
    var gameStates: [Game]
    var game: Game {
        return gameStates.last!
    }
    let wSelfLife: Int
//    let wOpponentLifeLoss: Int
    let wDiffLives: Int
    let wSquareThreshold: Int
    let wSelfSpreadBelowThreshold: Int
    let wSelfSpreadAboveThreshold: Int
    let wOpponentSpread: Int
    let wSelfInDanger: Int
    let wOpponentInDangerBelowThreshold: Int
    let wOpponentInDangerAboveThreshold: Int
//    var wBlockedSpawnPointCount: Int {
//        return game.player(myColor).lives * wSelfLife
//    }
    
    let myColor: Color
    
    init(game: Game, myColor: Color, wSelfLife: Int, /*wOpponentLifeLoss: Int,*/ wDiffLives: Int, wSquareThreshold: Int, wSelfSpreadBelowThreshold: Int, wSelfSpreadAboveThreshold: Int, wOpponentSpread: Int, wSelfInDanger: Int, wOpponentInDangerBelowThreshold: Int, wOpponentInDangerAboveThreshold: Int) {
        self.gameStates = [game]
        self.myColor = myColor
        self.wSelfLife = wSelfLife
//        self.wOpponentLifeLoss = wOpponentLifeLoss
        self.wDiffLives = wDiffLives
        self.wSquareThreshold = wSquareThreshold
        self.wSelfSpreadBelowThreshold = wSelfSpreadBelowThreshold
        self.wSelfSpreadAboveThreshold = wSelfSpreadAboveThreshold
        self.wOpponentSpread = wOpponentSpread
        self.wSelfInDanger = wSelfInDanger
        self.wOpponentInDangerBelowThreshold = wOpponentInDangerBelowThreshold
        self.wOpponentInDangerAboveThreshold = wOpponentInDangerAboveThreshold
    }
    
    func evaluateHeuristics() -> Int {
        let livingPlayers = game.players.filter({ $0.lives > 0 })
        let me = game.player(myColor)
        if me.lives == 0 {
            return Int.min
        }
        if livingPlayers.count == 1 && me.lives > 0 {
            return Int.max
        }
        if livingPlayers.count == 0 {
            return 0
        }
//        let finalSelfLifeLoss = -lifeLosses[myColor]!
        let finalSelfLives = me.lives
    }
}
