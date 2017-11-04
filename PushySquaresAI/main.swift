import Foundation
import RealmSwift

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

func playGame(withAgents agents: [Agent]) {
    let game = Game(map: .standard, playerCount: agents.count + 1)
    //let start = Date()
    var colors: [Color: Agent] = [.color3: agents[0]]
    if agents.count > 1 {
        colors[.color2] = agents[1]
    }
    if agents.count > 2 {
        colors[.color4] = agents[2]
    }
    while game.players.filter({$0.lives > 0}).count >= 2 {
        printGame(game)
        
        if game.currentPlayer.color == .color1 {
            loop: repeat {
                switch readLine()! {
                case "r":
                    game.moveRight()
                    break loop
                case "l":
                    game.moveLeft()
                    break loop
                case "u":
                    game.moveUp()
                    break loop
                case "d":
                    game.moveDown()
                    break loop
                default: continue
                }
            } while true
        } else {
            let ai = GameAI(game: game.createCopy(), myColor: game.currentPlayer.color, agent: colors[game.currentPlayer.color]!)
            game.moveInDirection(ai.getNextMove())
        }
    }
    //let end = Date()
    //print("time used: \(end.timeIntervalSince(start))")
    printGame(game)
}

let agents = [
    [9817,3256,2,6212,3272,4225,6744,2582,5886],
    [9264,2083,3,2111,1915,4922,3956,397,3952],
    [8420,9285,0,181,4669,5890,4306,4200,7995], // strongest
    [9062,3260,0,2634,4669,8793,1705,2725,6083]
    ].map { Agent.fromArray($0) }
//let start = Date()
//let game = AgentGame(agents: agents)
//game.run(doPrint: true)
//let end = Date()
//print(end.timeIntervalSince(start))
//print(game.fitness.values.reduce(0, +))
//runGeneration(previousFitness: 227.24)
//playGame(withAgents: [Agent.fromArray([553,8371,3,5646,3791,8583,6187,680,9157])])

//let game = Game(map: .standard, playerCount: 2)
//let movedUp = game.createCopy()
//movedUp.moveUp()
//let movedDown = game.createCopy()
//movedDown.moveDown()
//let movedLeft = game.createCopy()
//movedLeft.moveLeft()
//let movedRight = game.createCopy()
//movedRight.moveRight()
//var ai = GameAI(game: movedUp, myColor: .color1, agent: .standard)
//print(ai.evaluateHeuristics())
//ai = GameAI(game: movedRight, myColor: .color1, agent: .standard)
//print(ai.evaluateHeuristics())
//ai = GameAI(game: movedLeft, myColor: .color1, agent: .standard)
//print(ai.evaluateHeuristics())
//ai = GameAI(game: movedDown, myColor: .color1, agent: .standard)
//print(ai.evaluateHeuristics())

