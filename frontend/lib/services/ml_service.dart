class MLService {
  // Dummy Model: profit prediction = sale_amount * coeff - expense * exp_coeff
  static double predictProfit(double saleAmount, double totalExpense) {
    double saleCoeff = 0.85;
    double expenseCoeff = 1.05;
    return (saleAmount * saleCoeff) - (totalExpense * expenseCoeff);
  }
}
