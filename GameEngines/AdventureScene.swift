import SpriteKit

final class AdventureScene: SKScene {
    var onTargetCollected: (() -> Void)?
    private var target: SKShapeNode!

    override func didMove(to view: SKView) {
        backgroundColor = .clear
        removeAllChildren()
        for _ in 0..<45 {
            let star = SKShapeNode(circleOfRadius: CGFloat.random(in: 1...3))
            star.fillColor = .white.withAlphaComponent(CGFloat.random(in: 0.35...0.9))
            star.strokeColor = .clear
            star.position = CGPoint(x: CGFloat.random(in: 0...size.width), y: CGFloat.random(in: 0...size.height))
            addChild(star)
        }
        target = SKShapeNode(circleOfRadius: min(size.width, size.height) * 0.07)
        target.fillColor = .yellow
        target.strokeColor = .white
        target.lineWidth = 5
        target.position = CGPoint(x: size.width * 0.5, y: size.height * 0.52)
        addChild(target)

        let pulse = SKAction.sequence([.scale(to: 1.16, duration: 0.55), .scale(to: 0.92, duration: 0.55)])
        target.run(.repeatForever(pulse))
    }

    func collectTarget() {
        guard target.parent != nil else { return }
        let burst = SKAction.sequence([.scale(to: 1.8, duration: 0.12), .fadeOut(withDuration: 0.15), .removeFromParent()])
        target.run(burst) { [weak self] in
            self?.onTargetCollected?()
            self?.spawnNextTarget()
        }
    }

    private func spawnNextTarget() {
        let node = SKShapeNode(circleOfRadius: min(size.width, size.height) * 0.065)
        node.fillColor = .yellow
        node.strokeColor = .white
        node.lineWidth = 5
        node.position = CGPoint(x: CGFloat.random(in: size.width * 0.2...size.width * 0.8), y: CGFloat.random(in: size.height * 0.25...size.height * 0.75))
        addChild(node)
        target = node
        node.run(.repeatForever(.sequence([.scale(to: 1.14, duration: 0.5), .scale(to: 0.92, duration: 0.5)])))
    }
}
