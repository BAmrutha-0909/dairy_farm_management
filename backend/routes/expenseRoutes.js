import express from "express";
import { addExpense, getExpenses } from "../controllers/expenseController.js";

const router = express.Router();

router.route("/")
  .post(addExpense)
  .get(getExpenses);

export default router;