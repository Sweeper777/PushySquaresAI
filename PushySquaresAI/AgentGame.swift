import Foundation
import RealmSwift

class AgentGame: GameDelegate {
    let colors: [Color: Agent]
    var fitness: [Agent: Int]
    let agents: [Agent]
    let game: Game
    let id: Int
    var realm: Realm?
    static var nextID = 1
    
    init(agents: [Agent]) {
        game = Game(map: .standard, playerCount: agents.count)
        var tempColors: [Color: Agent] = [.color1: agents[0], .color3: agents[1]]
        if agents.count > 2 {
            tempColors[.color2] = agents[2]
        }
        if agents.count > 3 {
            tempColors[.color4] = agents[3]
        }
        self.colors = tempColors
        self.agents = agents
        self.fitness = [:]
        game.delegate = self
    }
    
    func run(print: Bool = false) {
        // For two players only!
        let startDate = Date()
        while game.players.filter({ $0.lives > 0}).count >= 2 {
            let ai = GameAI(game: game.createCopy(), myColor: game.currentPlayer.color, agent: colors[game.currentPlayer.color]!)
            game.moveInDirection(ai.getNextMove())
            if print {
                printGame(game)
            }
            if Date().timeIntervalSince(startDate) > 180 && !print {
                fitness = [:]
                return
            }
            fitness[colors[game.currentPlayer.color]!] = (fitness[colors[game.currentPlayer.color]!] ?? 0) + 1
        }
//        let remainingPlayers = game.players.filter({ $0.lives > 0})
//        if remainingPlayers.count == 1 {
//            fitness[colors[remainingPlayers.first!.color]!] = 3 * remainingPlayers.first!.lives
//        }
    }
    
    func playerDidMakeMove(direction: Direction?, originalPositions: [Position], destroyedSquarePositions: [Position], greyedOutPositions: [Position], newSquareColor: Color?) {
        
    }
    
    func playerDidDie(color: Color) {
//        let remainingPlayerCount = game.players.filter({$0.lives > 0}).count
//        if remainingPlayerCount > 1 {
//           fitness[colors[color]!] = 3 - remainingPlayerCount
//        }
    }
}
