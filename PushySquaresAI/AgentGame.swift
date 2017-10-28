import Foundation
class AgentGame: GameDelegate {
    let colors: [Color: Agent]
    var fitness: [Agent: Int]
    let agents: [Agent]
    let game: Game
    
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
    func playerDidMakeMove(direction: Direction?, originalPositions: [Position], destroyedSquarePositions: [Position], greyedOutPositions: [Position], newSquareColor: Color?) {
        
    }
    
    func playerDidDie(color: Color) {
    }
}
