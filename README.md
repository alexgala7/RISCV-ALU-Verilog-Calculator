# RISC-V Multi-Cycle Processor Design (Verilog)

Αυτό το repository περιέχει την πλήρη σχεδίαση ενός **32-bit RISC-V συμβατού επεξεργαστή** σε Verilog HDL. Το project εξελίσσεται από τη σχεδίαση βασικών δομικών μονάδων (ALU, Register File) στην υλοποίηση ενός multi-cycle datapath και μιας Μηχανής Πεπερασμένων Καταστάσεων (FSM).

## 📊 Επισκόπηση Εργασίας

### Άσκηση 1: Arithmetic Logic Unit (ALU) 32-bit
Σχεδίαση μιας ALU 32-bit με παραμετροποιημένη επιλογή λειτουργιών μέσω του σήματος `alu_op`.
* **Λειτουργίες:** Υποστηρίζονται αριθμητικές πράξεις (ADD, SUB), λογικές (AND, OR, XOR), ολισθήσεις (SLL, SRL, SRA) και συγκρίσεις (SLT).
* **Zero Flag:** Έξοδος 1-bit που υποδεικνύει αν το αποτέλεσμα είναι μηδέν (απαραίτητο για BEQ).
* **Ιδιαιτερότητες:** Υλοποίηση προσημασμένης σύγκρισης και αριθμητικής ολίσθησης με μετατροπή τύπου δεδομένων.

### Άσκηση 2: Ψηφιακή Αριθμομηχανή (Calculator)
Ενσωμάτωση της ALU σε ένα κύκλωμα αριθμομηχανής με συσσωρευτή (accumulator) 16-bit.
* **Accumulator:** 16-bit καταχωρητής με σύγχρονο μηδενισμό (btnu) και ενημέρωση (btnd).
* **Interface:** Σύνδεση εισόδων (switches) και συσσωρευτή στην ALU μέσω επέκτασης προσήμου (sign extension).
* **Control:** Υλοποίηση συνδυαστικής λογικής (structural Verilog) στο `calc_enc.v` για την παραγωγή του `alu_op`.

![Calculator Simulation Waveforms](Simulations/calculator_simulation_waveforms.png)
*Σχήμα: Κυματομορφή προσομοίωσης της αριθμομηχανής που επαληθεύει την ορθή λειτουργία των πράξεων.*

### Άσκηση 3: Register File
Σχεδίαση αρχείου 32 καταχωρητών (32-bit) για τον RISC-V.
* **Θύρες:** Ταυτόχρονη ανάγνωση από δύο θύρες και εγγραφή σε μία.
* **Register x0:** Hardwired τιμή 0, μη επιδεκτική αλλαγής.
* **Προτεραιότητα Εγγραφής:** Μηχανισμός που επιτρέπει την άμεση προώθηση των δεδομένων εγγραφής στις εξόδους ανάγνωσης όταν οι διευθύνσεις ταυτίζονται.

### Άσκηση 4: Datapath Σχεδίαση
Σύνθεση των μονάδων σε μια ενιαία διαδρομή δεδομένων σύμφωνα με την αρχιτεκτονική RISC-V.
* **Program Counter (PC):** Λογική ενημέρωσης PC+4 ή Branch Offset.
* **Immediate Generation:** Υποστήριξη I, S, και B-type εντολών με κατάλληλη επέκταση προσήμου.
* **Memory Interface:** Διασύνδεση με μνήμες δεδομένων και εντολών.

### Άσκηση 5: Multi-cycle Control (FSM)
Υλοποίηση του ελεγκτή 5 σταδίων (Instruction Fetch, Decode, Execute, Memory, Write-Back).
* **Σήματα Ελέγχου:** Παραγωγή των PCSrc, ALUSrc, MemRead, MemWrite, RegWrite και ALUCtrl.
* **Παρατήρηση:** Κατά την τελική προσομοίωση του ελεγκτή στο `top_proc.v`, εντοπίστηκαν ζητήματα στη διασύνδεση του WriteBackData και στην ενεργοποίηση του RegWrite, τα οποία επηρεάζουν την πλήρη ολοκλήρωση των εντολών LW/SW.

[Image of a 5-stage FSM state diagram for a processor]

## 🛠️ Υποστήριξη Εντολών
Ο επεξεργαστής σχεδιάστηκε για να υποστηρίζει:
* **R-Type:** ADD, SUB, AND, OR, XOR, SLT, SLL, SRL, SRA.
* **I-Type:** ADDI, ANDI, ORI, XORI, SLTI, SLLI, SRLI, SRAI, LW.
* **S-Type:** SW.
* **B-Type:** BEQ.

## 📂 Δομή Φακέλων
```text
RISCV-Processor-MultiCycle/
├── RTL/                 # Πηγαίος κώδικας Verilog
│   ├── alu.v
│   ├── calc.v
│   ├── calc_enc.v
│   ├── regfile.v
│   ├── datapath.v
│   └── top_proc.v
├── Memory/              # Μοντέλα μνήμης και δεδομένα
│   ├── DATA_MEMORY.v           (πρώην ram.v)
│   ├── INSTRUCTION_MEMORY.v    (πρώην rom.v)
│   └── rom_bytes.data          (κώδικας μηχανής)
├── Testbenches/         # Αρχεία επαλήθευσης
│   ├── calc_tb.v
│   └── top_proc_tb.v
├── Docs/                # Specs και Αναφορά
│   ├── Assignment_Specifications.pdf
│   └── Digital_Systems_Design_Report.pdf
└── Simulations/         # Screenshots κυματομορφών
    └── calculator_simulation_waveforms.png
