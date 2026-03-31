import mongoose from "mongoose";

const expenseSchema = mongoose.Schema(
  {
    title: { type: String, required: true },
    amount: { type: Number, required: true },
    date: { type: Date, default: Date.now }
  },
  { timestamps: true }
);

export default mongoose.model("Expense", expenseSchema);