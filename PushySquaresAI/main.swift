import Foundation
import RealmSwift
import GameplayKit

func printGame(_ game: Game) {
    let colorToCharatcer = [Color.red: "🚹", .blue: "🚺", .green: "🚼", .yellow: "❇️"]
    print("--------------")
    print("New Square In: \(game.currentPlayer.turnsUntilNewSquare)")
    print("Current Turn: \(colorToCharatcer[game.currentPlayer.color]!)")
    print("Lives: ", separator: "", terminator: "")
    for player in game.players {
        print("\(colorToCharatcer[player.color]!)\(player.lives) ", separator: "", terminator: "")
    }
    print()
    print("--------------")
    printBoard(game.map, state: game.boardState)
}

func playGame(withAgents agents: [Agent]) {
    let game = Game(map: Map(name: "standard")!, playerCount: agents.count + 1)
    //let start = Date()
    var colors: [Color: Agent] = [.green: agents[0]]
    if agents.count > 1 {
        colors[.blue] = agents[1]
    }
    if agents.count > 2 {
        colors[.yellow] = agents[2]
    }
    while game.players.filter({$0.lives > 0}).count >= 2 {
        printGame(game)
        
        if game.currentPlayer.color == .red {
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
            print("Average Pruned:", Double(ai.nodesPruned.reduce(0, +)) / Double(ai.nodesPruned.count))
        }
    }
    //let end = Date()
    //print("time used: \(end.timeIntervalSince(start))")
    printGame(game)
}

let agents = [
    [9264,2083,3,2111,1915,4922,3956,397,3952],
    [8420,9285,0,181,4669,5890,4306,4200,7995],
    [9062,3260,0,2634,4669,8793,1705,2725,6083]
    ].map { Agent.fromArray($0) }
//let start = Date()
//let game = AgentGame(agents: agents, map: Map(file: "grey2"))
//game.run(print: true)
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

//var prevFitness: Double? = nil
//for i in 1...3 {
//    print("--------------")
//    print("Starting Generation \(i)")
//    print("-------------")
//    prevFitness = runGeneration(previousFitness: prevFitness, mentors: agents)
//    print("--------------")
//    print("Generation \(i) Ended")
//    print("-------------")
//}

//let realm = try! Realm()
//try! realm.write {
//    for _ in 0..<50 {
//        let agent = Agent.randomAgent()
//        realm.add(agent)
//    }
//}

playGame(withAgents: agents)

//while game.players.filter({$0.lives > 0}).count >= 2 {
//    printGame(game)
//
//    if game.currentPlayer.color == .red {
//        loop: repeat {
//            switch readLine()! {
//            case "r":
//                game.moveRight()
//                break loop
//            case "l":
//                game.moveLeft()
//                break loop
//            case "u":
//                game.moveUp()
//                break loop
//            case "d":
//                game.moveDown()
//                break loop
//            default: continue
//            }
//        } while true
//    } else {
//        let minimaxStrategist = GKMinmaxStrategist()
//        minimaxStrategist.gameModel = GameModel(game: game)
////        minimaxStrategist.explorationParameter = 1
//        minimaxStrategist.randomSource = GKARC4RandomSource()
//        let move = minimaxStrategist.bestMoveForActivePlayer()
//        print(move)
//        game.moveInDirection((move as! MoveModel).move)
//    }
//}
////let end = Date()
////print("time used: \(end.timeIntervalSince(start))")
//printGame(game)