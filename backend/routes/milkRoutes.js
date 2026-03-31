import express from "express";
import { getMilkRecords, addMilkRecord } from "../controllers/milkController.js";

const router = express.Router();

router.get("/", getMilkRecords);
router.post("/", addMilkRecord);

export default router;