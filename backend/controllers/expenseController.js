import Expense from "../models/Expense.js";

export const addExpense = async (req, res) => {
  const expense = await Expense.create(req.body);
  res.status(201).json(expense);
};

export const getExpenses = async (req, res) => {
  const expenses = await Expense.find();
  res.json(expenses);
};