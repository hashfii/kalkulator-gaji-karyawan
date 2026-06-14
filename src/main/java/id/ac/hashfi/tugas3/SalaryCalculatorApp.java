package id.ac.hashfi.tugas3;

import javafx.application.Application;
import javafx.geometry.Insets;
import javafx.geometry.Pos;
import javafx.scene.Scene;
import javafx.scene.control.Button;
import javafx.scene.control.ComboBox;
import javafx.scene.control.Label;
import javafx.scene.control.Separator;
import javafx.scene.control.Spinner;
import javafx.scene.layout.BorderPane;
import javafx.scene.layout.GridPane;
import javafx.scene.layout.HBox;
import javafx.scene.layout.Priority;
import javafx.scene.layout.Region;
import javafx.scene.layout.VBox;
import javafx.stage.Stage;

import java.text.NumberFormat;
import java.util.Locale;

public class SalaryCalculatorApp extends Application {
    private final NumberFormat rupiahFormat = NumberFormat.getCurrencyInstance(Locale.forLanguageTag("id-ID"));

    private ComboBox<String> gradeComboBox;
    private Spinner<Integer> overtimeSpinner;
    private Label basicSalaryValue;
    private Label overtimeRateValue;
    private Label overtimePayValue;
    private Label totalPayValue;
    private Label formulaValue;

    @Override
    public void start(Stage stage) {
        BorderPane root = new BorderPane();
        root.getStyleClass().add("app-shell");

        HBox header = buildHeader();
        HBox workspace = new HBox(24);
        workspace.setAlignment(Pos.TOP_CENTER);
        workspace.getChildren().addAll(buildInputPanel(), buildResultPanel());

        BorderPane.setMargin(header, new Insets(0, 0, 22, 0));
        root.setTop(header);
        root.setCenter(workspace);

        Scene scene = new Scene(root, 1040, 900);
        scene.getStylesheets().add(getClass().getResource("/styles.css").toExternalForm());

        stage.setTitle("Tugas 3 - Kalkulator Gaji Karyawan");
        stage.setMinWidth(920);
        stage.setMinHeight(920);
        stage.setScene(scene);
        stage.show();

        updateCalculation();
    }

    private HBox buildHeader() {
        Label eyebrow = new Label("TUGAS 3 ALGORITMA DAN PEMROGRAMAN");
        eyebrow.getStyleClass().add("eyebrow");

        Label title = new Label("Kalkulator Gaji Karyawan");
        title.getStyleClass().add("title");

        VBox titleBlock = new VBox(7, eyebrow, title);
        titleBlock.setAlignment(Pos.CENTER_LEFT);

        Region spacer = new Region();
        HBox.setHgrow(spacer, Priority.ALWAYS);

        HBox header = new HBox(24, titleBlock, spacer, buildStudentCard());
        header.setAlignment(Pos.CENTER_LEFT);
        return header;
    }

    private VBox buildStudentCard() {
        Label cardTitle = new Label("DATA MAHASISWA");
        cardTitle.getStyleClass().add("student-card-title");

        GridPane studentGrid = new GridPane();
        studentGrid.setHgap(10);
        studentGrid.setVgap(4);
        addStudentRow(studentGrid, 0, "Nama", "HASHFI IHKAMUDDIN");
        addStudentRow(studentGrid, 1, "NIM", "052861984");
        addStudentRow(studentGrid, 2, "Program Studi", "Sistem Informasi");
        addStudentRow(studentGrid, 3, "UPBJJ", "Kota Bogor");

        VBox card = new VBox(7, cardTitle, studentGrid);
        card.getStyleClass().add("student-card");
        card.setMinWidth(290);
        card.setMaxWidth(320);
        return card;
    }

    private void addStudentRow(GridPane grid, int row, String labelText, String valueText) {
        Label label = new Label(labelText);
        label.getStyleClass().add("student-label");
        label.setMinWidth(92);

        Label value = new Label(valueText);
        value.getStyleClass().add("student-value");

        grid.add(label, 0, row);
        grid.add(value, 1, row);
    }

    private VBox buildInputPanel() {
        Label panelTitle = new Label("Input Data");
        panelTitle.getStyleClass().add("panel-title");

        Label panelSubtitle = new Label("Pilih golongan dan jumlah jam lembur.");
        panelSubtitle.getStyleClass().add("panel-subtitle");

        gradeComboBox = new ComboBox<>();
        gradeComboBox.getItems().addAll("A", "B", "C");
        gradeComboBox.setValue("A");
        gradeComboBox.setMaxWidth(Double.MAX_VALUE);
        gradeComboBox.getStyleClass().add("input-control");

        overtimeSpinner = new Spinner<>(0, 99, 1);
        overtimeSpinner.setEditable(false);
        overtimeSpinner.setMaxWidth(Double.MAX_VALUE);
        overtimeSpinner.getStyleClass().add("input-control");

        Button calculateButton = new Button("Hitung Gaji");
        calculateButton.getStyleClass().add("primary-button");
        calculateButton.setMaxWidth(Double.MAX_VALUE);
        calculateButton.setOnAction(event -> updateCalculation());

        GridPane formGrid = new GridPane();
        formGrid.setHgap(16);
        formGrid.setVgap(10);
        formGrid.add(buildFieldLabel("Golongan"), 0, 0);
        formGrid.add(gradeComboBox, 0, 1);
        formGrid.add(buildFieldLabel("Jam Lembur"), 0, 2);
        formGrid.add(overtimeSpinner, 0, 3);
        formGrid.add(calculateButton, 0, 4);

        Label ruleTitle = new Label("Aturan Perhitungan");
        ruleTitle.getStyleClass().add("section-label");

        VBox rules = new VBox(10,
                buildRuleGroup("Gaji Pokok", """
                        A = Rp5.000.000
                        B = Rp6.500.000
                        C = Rp9.500.000"""),
                buildRuleGroup("Persentase Lembur", """
                        1 jam = 30%     2 jam = 32%
                        3 jam = 34%     4 jam = 36%
                        >= 5 jam = 38%"""),
                buildRuleGroup("Rumus", "Total gaji = gaji pokok + upah lembur")
        );
        rules.getStyleClass().add("rules-block");

        VBox panel = new VBox(18, panelTitle, panelSubtitle, formGrid, new Separator(), ruleTitle, rules);
        panel.getStyleClass().add("surface-panel");
        panel.setPrefWidth(390);
        HBox.setHgrow(panel, Priority.NEVER);
        return panel;
    }

    private VBox buildResultPanel() {
        Label panelTitle = new Label("Rincian Gaji");
        panelTitle.getStyleClass().add("panel-title");

        Label panelSubtitle = new Label("Breakdown hasil sesuai input terakhir.");
        panelSubtitle.getStyleClass().add("panel-subtitle");

        basicSalaryValue = createValueLabel();
        overtimeRateValue = createValueLabel();
        overtimePayValue = createValueLabel();
        totalPayValue = createValueLabel();
        totalPayValue.getStyleClass().add("total-value");
        formulaValue = new Label("-");
        formulaValue.getStyleClass().add("formula-text");
        formulaValue.setWrapText(true);

        VBox resultGrid = new VBox(12,
                buildResultRow("Gaji Pokok", basicSalaryValue),
                buildResultRow("Persentase Lembur", overtimeRateValue),
                buildResultRow("Upah Lembur", overtimePayValue),
                buildResultRow("Total Gaji", totalPayValue)
        );

        Label formulaTitle = new Label("Formula");
        formulaTitle.getStyleClass().add("section-label");

        VBox panel = new VBox(18, panelTitle, panelSubtitle, resultGrid, new Separator(), formulaTitle, formulaValue);
        panel.getStyleClass().add("surface-panel");
        panel.setPrefWidth(470);
        HBox.setHgrow(panel, Priority.ALWAYS);
        return panel;
    }

    private Label buildFieldLabel(String text) {
        Label label = new Label(text);
        label.getStyleClass().add("field-label");
        return label;
    }

    private VBox buildRuleGroup(String titleText, String detailText) {
        Label title = new Label(titleText);
        title.getStyleClass().add("rule-title");

        Label detail = new Label(detailText);
        detail.getStyleClass().add("rule-detail");
        detail.setWrapText(true);
        detail.setMinHeight(Region.USE_PREF_SIZE);

        VBox group = new VBox(5, title, detail);
        group.getStyleClass().add("rule-group");
        return group;
    }

    private Label createValueLabel() {
        Label label = new Label("-");
        label.getStyleClass().add("result-value");
        return label;
    }

    private HBox buildResultRow(String labelText, Label valueLabel) {
        Label label = new Label(labelText);
        label.getStyleClass().add("result-label");

        Region spacer = new Region();
        HBox.setHgrow(spacer, Priority.ALWAYS);

        HBox row = new HBox(16, label, spacer, valueLabel);
        row.setAlignment(Pos.CENTER_LEFT);
        row.getStyleClass().add("result-row");
        return row;
    }

    private void updateCalculation() {
        PayrollResult result = calculatePayroll(gradeComboBox.getValue(), overtimeSpinner.getValue());

        basicSalaryValue.setText(formatRupiah(result.basicSalary));
        overtimeRateValue.setText(result.overtimePercentage + "%");
        overtimePayValue.setText(formatRupiah(result.overtimePay));
        totalPayValue.setText(formatRupiah(result.totalPay));
        formulaValue.setText(formatRupiah(result.basicSalary) + " + (" + result.overtimePercentage
                + "% x " + formatRupiah(result.basicSalary) + ") = " + formatRupiah(result.totalPay));
    }

    private PayrollResult calculatePayroll(String employeeClass, int overtimeHours) {
        // Array gaji sesuai soal: index 0=A, index 1=B, index 2=C.
        double[] basicSalaryArray = {5000000, 6500000, 9500000};

        // Array persentase lembur sesuai soal: index 0=30%, 1=32%, 2=34%, 3=36%, 4=38%.
        int[] overtimePercentageArray = {30, 32, 34, 36, 38};

        int salaryIndex;
        if (employeeClass.equals("A")) {
            salaryIndex = 0;
        } else if (employeeClass.equals("B")) {
            salaryIndex = 1;
        } else if (employeeClass.equals("C")) {
            salaryIndex = 2;
        } else {
            salaryIndex = 0;
        }

        int overtimePercentage;
        if (overtimeHours <= 0) {
            overtimePercentage = 0;
        } else {
            int overtimeIndex;
            if (overtimeHours == 1) {
                overtimeIndex = 0;
            } else if (overtimeHours == 2) {
                overtimeIndex = 1;
            } else if (overtimeHours == 3) {
                overtimeIndex = 2;
            } else if (overtimeHours == 4) {
                overtimeIndex = 3;
            } else {
                overtimeIndex = 4;
            }
            overtimePercentage = overtimePercentageArray[overtimeIndex];
        }

        double basicSalary = basicSalaryArray[salaryIndex];
        double overtimePay = (overtimePercentage / 100.0) * basicSalary;
        double totalPay = basicSalary + overtimePay;

        return new PayrollResult(basicSalary, overtimePercentage, overtimePay, totalPay);
    }

    private String formatRupiah(double amount) {
        return rupiahFormat.format(amount).replace(",00", "");
    }

    public static void main(String[] args) {
        launch(args);
    }

    private static class PayrollResult {
        private final double basicSalary;
        private final int overtimePercentage;
        private final double overtimePay;
        private final double totalPay;

        private PayrollResult(double basicSalary, int overtimePercentage, double overtimePay, double totalPay) {
            this.basicSalary = basicSalary;
            this.overtimePercentage = overtimePercentage;
            this.overtimePay = overtimePay;
            this.totalPay = totalPay;
        }
    }
}
