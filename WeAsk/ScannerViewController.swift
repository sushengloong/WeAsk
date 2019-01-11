import UIKit
import WeScan
import SwiftyTesseract

protocol ScannerDelegate {
    func addQuestion(_ question: String)
}

class ScannerViewController: UIViewController {
    
    @IBOutlet weak var questionsTableView: UITableView!
    let saveFileName = "cards"
    var saveFilePath: String?
    var questions: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        saveFilePath = filePath(key: saveFileName)
        loadCards()
    }

    @IBAction func onAddButtonTapped(_ sender: UIButton) {
        let scannerVC = ImageScannerController()
        scannerVC.imageScannerDelegate = self
        present(scannerVC, animated: true)
    }

    @IBAction func onStartButtonTapped(_ sender: UIBarButtonItem) {
        let questionsVC = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "QuestionsVC") as! QuestionsViewController
        questionsVC.questions = questions
        self.present(questionsVC, animated: true)
    }
    
    func saveCards() {
        let cards = questions.map { (question) -> Card in
            Card(question: question)
        }
        do {
            let data = try PropertyListEncoder().encode(cards)
            NSKeyedArchiver.archiveRootObject(data, toFile: saveFilePath!)
        } catch {
            print("Save: failed!")
        }
    }
    
    func loadCards() {
        guard let data = NSKeyedUnarchiver.unarchiveObject(withFile: saveFilePath!) as? Data else {
            print("Failed to load \(saveFilePath!)!")
            return
        }
        do {
            let cards = try PropertyListDecoder().decode([Card].self, from: data)
            questions.removeAll()
            questions = cards.map { $0.question }
        } catch {
            print("Load: failed!")
        }
    }
    
    func filePath(key:String) -> String {
        let manager = FileManager.default
        let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first
        return (url!.appendingPathComponent(key).path)
    }

}

extension ScannerViewController: ScannerDelegate {
    func addQuestion(_ question: String) {
        questions.append(question)
        saveCards()
        questionsTableView.reloadData()
    }
}

extension ScannerViewController: UITableViewDataSource, UITableViewDelegate, QuestionCellDeleteButtonDelegate {
    func deleteTapped(at index: IndexPath) {
        questions.remove(at: index.row)
        saveCards()
        questionsTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionCell", for: indexPath) as! QuestionTableViewCell
        cell.delegate = self
        cell.indexPath = indexPath
        cell.questionTextView.text = questions[indexPath.row]
        return cell
    }
}

extension ScannerViewController: ImageScannerControllerDelegate {

    func imageScannerController(_ scanner: ImageScannerController, didFinishScanningWithResults results: ImageScannerResults) {
        let swiftyTesseract = SwiftyTesseract(language: .english)
        swiftyTesseract.performOCR(on: results.scannedImage) { recognizedString in
            guard let recognizedString = recognizedString else { return }
            let question = recognizedString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                .replacingOccurrences(of: "\n", with: " ")
            scanner.dismiss(animated: true, completion: {
                let editQuestionVC = UIStoryboard(name: "Main", bundle: nil)
                    .instantiateViewController(withIdentifier: "EditQuestionVC") as! EditQuestionViewController
                editQuestionVC.question = question
                editQuestionVC.scannerDelegate = self
                self.present(editQuestionVC, animated: true)
            })
        }
    }
    
    func imageScannerControllerDidCancel(_ scanner: ImageScannerController) {
        scanner.dismiss(animated: true)
    }
    
    func imageScannerController(_ scanner: ImageScannerController, didFailWithError error: Error) {
        print(error)
    }

}
