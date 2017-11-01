import Foundation

extension Agent {
    static func breed(agent1: Agent, agent2: Agent) -> Agent {
        let a1 = agent1.toArray()
        let a2 = agent2.toArray()
        var newArray = Array(repeating: 0, count: a2.count)
        var indices = Array(a1.indices)
        let indicesFrom1 = [
            randomFromArrayAndRemove(&indices),
            randomFromArrayAndRemove(&indices),
            randomFromArrayAndRemove(&indices)
        ]
        let indicesFrom2 = [
            randomFromArrayAndRemove(&indices),
            randomFromArrayAndRemove(&indices),
            randomFromArrayAndRemove(&indices)
        ]
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
