import Foundation

extension Agent {
    static func breed(agent1: Agent, agent2: Agent) -> Agent {
        let a1 = agent1.toArray()
        let a2 = agent2.toArray()
        var newArray = Array(repeating: 0, count: a2.count)
        var indices = Array(a1.indices)
        
        let fitness1 = UInt32((Double(agent1.fitness) / Double(10 - agent1.life)) * 1000)
        let fitness2 = UInt32((Double(agent2.fitness) / Double(10 - agent2.life)) * 1000)
        var indicesFrom1 = [Int]()
        var indicesFrom2 = [Int]()
        while indices.count > 3 {
            if arc4random_uniform(fitness1 + fitness2) < fitness1 {
                indicesFrom1.append(randomFromArrayAndRemove(&indices))
            } else {
                indicesFrom2.append(randomFromArrayAndRemove(&indices))
            }
        }
        
        for index in indicesFrom1 {
            newArray[index] = a1[index]
        }
        for index in indicesFrom2 {
            newArray[index] = a2[index]
        }
        for index in indices {
            newArray[index] = (a1[index] + a2[index]) / 2
        }
        return Agent.fromArray(newArray)
    }
}

func randomFromArrayAndRemove<T>(_ a: inout [T]) -> T {
    let randomNumber = Int(arc4random_uniform(UInt32(a.count)))
    let item = a[randomNumber]
    a.remove(at: randomNumber)
    return item
}
