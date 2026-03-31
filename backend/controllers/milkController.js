import MilkRecord from "../models/MilkRecord.js";
// ✅ GET ALL RECORDS
export const getMilkRecords = async (req, res) => {
  try {
    const records = await MilkRecord.find();

    res.json(records);

  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// ✅ ADD RECORD
export const addMilkRecord = async (req, res) => {
  try {
    const { name, quantity } = req.body;

    if (!name || !quantity) {
      return res.status(400).json({ message: "All fields required" });
    }

    const record = await MilkRecord.create({
      name,
      quantity,
    });

    res.status(201).json(record);

  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};