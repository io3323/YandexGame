
import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var gameFieldView: UIView!
    @IBOutlet weak var stepper:UIStepper!
    @IBOutlet weak var actionbutton:UIButton!
    @IBOutlet weak var shapeX: NSLayoutConstraint!
    @IBOutlet weak var shapeY: NSLayoutConstraint!
    @IBOutlet weak var gameObject: UIImageView!
    @IBOutlet weak var scoreLabel: UILabel!
    private var gameTimeLeft: TimeInterval = 0
    private var gameTimer:Timer?
    private var timer:Timer?
    private let displayDuration: TimeInterval = 2
    private var score = 0
    
    @IBAction func actionButtonTap(_ sender:UIButton){
        if isGameActive{
            stopGame()
        }else{
            startGame()
        }
    }
    private var isGameActive = false
    @IBAction func stepperChanged(_ sender: UIStepper) {
        updateUI()
    }
    @IBAction func objectTapped(_ sender: UITapGestureRecognizer) {
        guard isGameActive else {return}
        repositionImageWidthTimer()
        score += 1
    }
    
    private func startGame(){
        score = 0
        repositionImageWidthTimer()
        gameTimer?.invalidate()
        gameTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(gameTimerTick), userInfo: nil, repeats: true)
        gameTimeLeft = stepper.value
        isGameActive  = true
        updateUI()
        
    }
    private func stopGame(){
        isGameActive = false
        updateUI()
        gameTimer?.invalidate()
        timer?.invalidate()
        scoreLabel.text = "Последний счет: \(score)"
    }
    private func repositionImageWidthTimer(){
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: displayDuration, target: self, selector: #selector(moveImage), userInfo: nil, repeats: true)
        timer?.fire()
    }
    private func updateUI(){
        gameObject.isHidden = !isGameActive
        if isGameActive{
            stepper.isEnabled = false
            timeLabel.text = "Осталось \(Int(gameTimeLeft)) сек"
            actionbutton.setTitle("Остановить", for: .normal)
        }else{
            stepper.isEnabled = true
            timeLabel.text = "Время: \(Int(stepper.value)) сек"
            actionbutton.setTitle("Начать", for: .normal)
        }
    }
    
    @objc private func gameTimerTick(){
        gameTimeLeft -= 1
        if gameTimeLeft <= 0{
            stopGame()
        }else{
            updateUI()
        }
        
    }
    @objc private func moveImage(){
        let maxX = gameFieldView.bounds.maxX - gameObject.frame.width
        let maxY = gameFieldView.bounds.maxY - gameObject.frame.height
        shapeX.constant = CGFloat(arc4random_uniform(UInt32(maxX)))
        shapeY.constant = CGFloat(arc4random_uniform(UInt32(maxY)))
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        gameFieldView.layer.borderColor = UIColor.gray.cgColor
        gameFieldView.layer.borderWidth = 1
        gameFieldView.layer.cornerRadius  = 5
        updateUI()
    }


}

