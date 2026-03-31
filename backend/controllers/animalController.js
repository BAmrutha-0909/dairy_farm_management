import Animal from "../models/Animal.js";

// CREATE
export const addAnimal = async (req, res) => {
  try {
    const { id, name, purchasePrice, purchaseDate } = req.body;

    if (!id || !name || !purchasePrice || !purchaseDate) {
      return res.status(400).json({ message: "All fields required" });
    }

    const animal = await Animal.create({
      id,
      name,
      purchasePrice,
      purchaseDate: new Date(purchaseDate)
    });

    res.status(201).json(animal);

  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Add failed" });
  }
};

// READ
export const getAnimals = async (req, res) => {
  try {
    const animals = await Animal.find();
    res.json(animals);
  } catch (error) {
    res.status(500).json({ message: "Fetch failed" });
  }
};

// UPDATE
export const updateAnimal = async (req, res) => {
  try {
    const animal = await Animal.findOne({ id: req.params.id });

    if (!animal) {
      return res.status(404).json({ message: "Not found" });
    }

    animal.name = req.body.name || animal.name;
    animal.purchasePrice = req.body.purchasePrice || animal.purchasePrice;

    if (req.body.purchaseDate) {
      animal.purchaseDate = new Date(req.body.purchaseDate);
    }

    const updated = await animal.save();
    res.json(updated);

  } catch (error) {
    res.status(500).json({ message: "Update failed" });
  }
};

// DELETE
export const deleteAnimal = async (req, res) => {
  try {
    const animal = await Animal.findOne({ id: req.params.id });

    if (!animal) {
      return res.status(404).json({ message: "Not found" });
    }

    await animal.deleteOne();
    res.json({ message: "Deleted successfully" });

  } catch (error) {
    res.status(500).json({ message: "Delete failed" });
  }
};