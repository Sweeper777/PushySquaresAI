
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
    
}
