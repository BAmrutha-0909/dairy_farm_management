import express from "express";
import { addSale, getSales, deleteSale } from "../controllers/salesController.js";

const router = express.Router();

router.route("/")
  .post(addSale)
  .get(getSales);

router.route("/:id")
  .delete(deleteSale);

export default router;