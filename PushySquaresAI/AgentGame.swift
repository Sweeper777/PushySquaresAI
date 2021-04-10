import Foundation
class AgentGame {
    let colors: [Color: Agent]
    var fitness: [Agent: Int] = [:]
    var fitnessIfLose: [Agent: Int] = [:]
    var fitnessIfWin: [Agent: Int] = [:]
    let agents: [Agent]
    let game: Game
    
    init(agents: [Agent], map: Map) {
        game = Game(map: map, playerCount: agents.count)
        var tempColors: [Color: Agent] = [.red: agents[0], .green: agents[1]]
        if agents.count > 2 {
            tempColors[.blue] = agents[2]
        }
        if agents.count > 3 {
            tempColors[.yellow] = agents[3]
        }
        self.colors = tempColors
        self.agents = agents
    }
    
    func run(print: Bool = false) {
        let startDate = Date()
        while game.players.filter({ $0.lives > 0}).count >= 2 {
            let ai = GameAI(game: game.createCopy(), myColor: game.currentPlayer.color, agent: colors[game.currentPlayer.color]!)
            let player = game.currentPlayer
            game.moveInDirection(ai.getNextMove())
            if print {
                printGame(game)
            }
            if Date().timeIntervalSince(startDate) > 180 && !print {
                Swift.print("Timed out!")
                fitness = [:]
                return
            }
            fitnessIfLose[colors[player.color]!] =
                    (fitnessIfLose[colors[player.color]!] ?? 0) + player.lives
            fitnessIfWin[colors[player.color]!] =
                    (fitnessIfWin[colors[player.color]!] ?? 1000) - 3
        }

        let remainingPlayers = game.players.filter({ $0.lives > 0})
        fitness = fitnessIfLose
        if let winningPlayer = remainingPlayers.first {
            fitness[colors[winningPlayer.color]!] = fitnessIfWin[colors[winningPlayer.color]!] ?? 1000
        }
    }
    
    func playerDidDie(color: Color) {
//        let remainingPlayerCount = game.players.filter({$0.lives > 0}).count
//        if remainingPlayerCount > 1 {
//           fitness[colors[color]!] = 3 - remainingPlayerCount
//        }
    }
}
