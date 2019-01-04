import UIKit

class EditQuestionViewController: UIViewController {
    
    @IBOutlet weak var questionTextView: UITextView!
    var scannerDelegate: ScannerDelegate?
    var question:String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        questionTextView.textContainerInset = UIEdgeInsets(top: 16, left: 8, bottom: 8, right: 16)
        questionTextView?.text = question
    }
    
    @IBAction func onSaveButtonTapped(_ sender: UIBarButtonItem) {
        scannerDelegate?.addQuestion(questionTextView.text!)
        self.dismiss(animated: true)
    }

    @IBAction func onCancelButtonTapped(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
