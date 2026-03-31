import express from "express";
import protect from "../middleware/authMiddleware.js";

import {
  addAnimal,
  getAnimals,
  deleteAnimal,
  updateAnimal
} from "../controllers/animalController.js";

const router = express.Router();

router.route("/")
  .post(protect, addAnimal)
  .get(protect, getAnimals);

router.route("/:id")
  .delete(protect, deleteAnimal)
  .put(protect, updateAnimal);

export default router;