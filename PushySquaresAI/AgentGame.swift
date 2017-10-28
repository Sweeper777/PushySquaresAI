import Foundation
class AgentGame: GameDelegate {
    let colors: [Color: Agent]
    var fitness: [Agent: Int]
    let agents: [Agent]
    let game: Game
    func playerDidMakeMove(direction: Direction?, originalPositions: [Position], destroyedSquarePositions: [Position], greyedOutPositions: [Position], newSquareColor: Color?) {
        
    }
    
    func playerDidDie(color: Color) {
    }
}
