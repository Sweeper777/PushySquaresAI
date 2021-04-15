import Foundation

extension Game {
    func createCopy() -> Game {
        Game(game: self)
    }

    func player(_ color: Color) -> Player {
        players.filter { $0.color == color }.first!
    }

    func opponents(to color: Color) -> [Color] {
        players.filter { $0.color != color }.map { $0.color }
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

public class GameAI {
    var gameStates: [Game]
    var game: Game {
        gameStates.last!
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
    let searchDepth = 6

    let myColor: Color

    var nodesPruned = [Int]()

    public init(game: Game, myColor: Color, wSelfLife: Int, wDiffLives: Int, wSquareThreshold: Int, wSelfSpreadBelowThreshold: Int, wSelfSpreadAboveThreshold: Int, wOpponentSpread: Int, wSelfInDanger: Int, wOpponentInDangerBelowThreshold: Int, wOpponentInDangerAboveThreshold: Int) {
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

    public convenience init(game: Game, myColor: Color, _ arr: [Int]) {
        self.init(game: game, myColor: myColor, wSelfLife: arr[0], wDiffLives: arr[1], wSquareThreshold: arr[2], wSelfSpreadBelowThreshold: arr[3], wSelfSpreadAboveThreshold: arr[4], wOpponentSpread: arr[5], wSelfInDanger: arr[6], wOpponentInDangerBelowThreshold: arr[7], wOpponentInDangerAboveThreshold: arr[8])
    }

    func evaluateHeuristics() -> Int {
        evaluate(game, myColor,
                wSelfLife,
                wDiffLives,
                wSquareThreshold,
                wSelfSpreadBelowThreshold,
                wSelfSpreadAboveThreshold,
                wOpponentSpread,
                wSelfInDanger,
                wOpponentInDangerBelowThreshold,
                wOpponentInDangerAboveThreshold)
    }



    private func minimaxWithAlphaBeta(depth: Int, color: Color, alpha: Int = Int.min, beta: Int = Int.max) -> (score: Int, direction: Direction) {
        var score = 0
        var bestDirection: Direction?
        if game.players.filter({$0.lives > 0}).count < 2 || depth == 0 {
            score = evaluateHeuristics()
            return (score, bestDirection ?? .left)
        } else {
            var alphaCopy = alpha
            var betaCopy = beta
            var pruned = 3
            for move in (game.boardState.indices(ofColor: color).count == 0 ? [Direction.up] : [Direction.up, .down, .left, .right]) {
                let gameCopy = game.createCopy()
                switch move {
                case .up: gameCopy.moveUp()
                case .down: gameCopy.moveDown()
                case .left: gameCopy.moveLeft()
                case .right: gameCopy.moveRight()
                }
                gameStates.append(gameCopy)
                if color == myColor {
                    score = minimaxWithAlphaBeta(depth: depth - 1, color: game.currentPlayer.color, alpha: alphaCopy, beta: betaCopy).score
                    if score > alphaCopy {
                        alphaCopy = score
                        bestDirection = move
                    }
                } else {
                    score = minimaxWithAlphaBeta(depth: depth - 1, color: game.currentPlayer.color, alpha: alphaCopy, beta: betaCopy).score
                    if score < betaCopy {
                        betaCopy = score
                        bestDirection = move
                    }
                }
                gameStates.removeLast()
                if alphaCopy >= betaCopy {
                    nodesPruned.append(pruned)
                    break
                }
                pruned -= 1
            }
            return (color == myColor ? alphaCopy : betaCopy, bestDirection ?? .left)
        }
    }

    private func minimax(depth: Int, color: Color) -> (score: Int, direction: Direction) {
        var bestScore = color == myColor ? Int.min : Int.max
        var currentScore: Int
        var bestDirection: Direction?
        if game.players.filter({$0.lives > 0}).count < 2 || depth == 0 {
            bestScore = evaluateHeuristics()
        } else {
            for move in (game.boardState.indices(ofColor: color).count == 0 ? [Direction.up] : [Direction.up, .down, .left, .right]) {
                let gameCopy = game.createCopy()
                switch move {
                case .up: gameCopy.moveUp()
                case .down: gameCopy.moveDown()
                case .left: gameCopy.moveLeft()
                case .right: gameCopy.moveRight()
                }
                gameStates.append(gameCopy)
                if color == myColor {
                    currentScore = minimax(depth: depth - 1, color: game.currentPlayer.color).score
                    if currentScore > bestScore {
                        bestScore = currentScore
                        bestDirection = move
                    }
                } else {
                    currentScore = minimax(depth: depth - 1, color: game.currentPlayer.color).score
                    if currentScore < bestScore {
                        bestScore = currentScore
                        bestDirection = move
                    }
                }
                gameStates.removeLast()
            }
        }
        return (bestScore, bestDirection ?? .left)
    }

    public func getNextMove(on dispatchQueue: DispatchQueue, completion: @escaping (Direction) -> Void) {
        dispatchQueue.async { [weak self] in
            guard let `self` = self else { return }
            completion(self.minimaxWithAlphaBeta(depth: self.searchDepth, color: self.myColor).direction)
        }
    }

    public func getNextMove() -> Direction {
        minimaxWithAlphaBeta(depth: searchDepth, color: myColor).direction
    }
}

public let multiplayerAIArrays = [
    [9817,3256,2,6212,3272,4225,6744,2582,5886],
    [9264,2083,3,2111,1915,4922,3956,397,3952],
    [8420,9285,0,181,4669,5890,4306,4200,7995],
    [9062,3260,0,2634,4669,8793,1705,2725,6083]
]

public let twoPlayerAIArray = [9817,3256,2,6212,3272,4225,6744,2582,5886]


func evaluate(_ game: Game, _ myColor: Color, _ wSelfLife: Int, _ wDiffLives: Int, _ wSquareThreshold: Int, _ wSelfSpreadBelowThreshold: Int, _ wSelfSpreadAboveThreshold: Int, _ wOpponentSpread: Int, _ wSelfInDanger: Int, _ wOpponentInDangerBelowThreshold: Int, _ wOpponentInDangerAboveThreshold: Int) -> Int {

    func spread(of positions: [Position], pivot: Position) -> Int {
        if let maxX = positions.map({ abs($0.x - pivot.x) }).max(), let maxY = positions.map({ abs($0.y - pivot.y) }).max() {
            return max(maxX, maxY)
        }
        return 0
    }

    func isInDanger(position: Position, directionsOfEdge: [Direction], myColor: Color) -> Bool {
        directionLoop: for direction in directionsOfEdge {
            let translate: (Position) -> Position
            switch direction {
            case .up: translate = { $0.below() }
            case .down: translate = { $0.above() }
            case .left: translate = { $0.right() }
            case .right: translate = { $0.left() }
            }
            var curr = position
            translationLoop: while true {
                curr = translate(curr)
                switch game.boardState[curr] {
                case .empty: continue directionLoop
                case .square(myColor), .deadBody: continue translationLoop
                default: return true
                }
            }
        }
        return false
    }

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
    let opponents = game.opponents(to: myColor)
    let finalDiffLives: Int
    //        let finalOpponentLifeLoss: Int
    if livingPlayers.count == 2 {
        finalDiffLives = me.lives - game.player(opponents[0]).lives
        //            finalOpponentLifeLoss = 0
    } else {
        //            finalOpponentLifeLoss = opponents.map { lifeLosses[$0]! }.reduce(0, +)
        finalDiffLives = 0
    }
    let mySquares = game.boardState.indices(ofColor: myColor)
    let finalSelfSpread = -spread(of: mySquares, pivot: game.spawnpoints[myColor]!)
    let finalOpponentSpread = opponents.map { spread(of: game.boardState.indices(ofColor: $0), pivot: game.spawnpoints[$0]!) }.reduce(0, +) / opponents.count
    let selfInDanger = mySquares.map { isInDanger(position: $0, directionsOfEdge: game.isEdge(position: $0), myColor: myColor) }.filter{ $0 }.count
    if selfInDanger >= me.lives {
        return Int.min
    }
    let finalSelfInDanger = -selfInDanger
    var opponentInDanger = 0
    for opponent in opponents {
        opponentInDanger += game.boardState.indices(ofColor: opponent).map { isInDanger(position: $0, directionsOfEdge: game.isEdge(position: $0), myColor: opponent) }.filter{ $0 }.count
    }
    let finalOpponentInDanger = opponentInDanger
    let ret = finalSelfLives * wSelfLife +
            finalDiffLives * wDiffLives +
            finalSelfSpread * (mySquares.count < wSquareThreshold ? wSelfSpreadBelowThreshold : wSelfSpreadAboveThreshold) +
            finalOpponentSpread * wOpponentSpread +
            finalSelfInDanger * wSelfInDanger +
            finalOpponentInDanger * (mySquares.count < wSquareThreshold ? wOpponentInDangerBelowThreshold : wOpponentInDangerAboveThreshold)
//    print(ret)
    return ret
}

