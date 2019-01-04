import UIKit

class QuestionsViewController: UIViewController {

    @IBOutlet weak var questionTextView: UITextView!

    var count = 0
    var questions: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        questionTextView.textContainerInset = UIEdgeInsets(top: 16, left: 8, bottom: 8, right: 16)
        setRandomQuestionText()
    }

    override func becomeFirstResponder() -> Bool {
        return true
    }

    override func motionEnded(_ motion: UIEvent.EventSubtype,
                     with event: UIEvent?) {
        if motion == .motionShake {
            setRandomQuestionText()
        }
    }
    
    private func setRandomQuestionText() {
        if (count == 0) {
            questionTextView.text = "Shake your phone now to see the first question!"
        } else if (questions.count == 0) {
            questionTextView.text = "We have run out of questions. Buy Sheng-Loong drinks to unlock more questions! ;)"
        } else {
            let randomIndex = Int(arc4random_uniform(UInt32(questions.count)))
            let question = questions.remove(at: randomIndex)
            questionTextView.text = "Q\(count): \(question)"
        }
        count += 1
    }

}
