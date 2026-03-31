import Sales from "../models/Sales.js";

export const addSale = async (req, res) => {
  const { customerName, quantity, pricePerLiter } = req.body;

  if (!customerName || !quantity || !pricePerLiter) {
    return res.status(400).json({ message: "All fields required" });
  }

  const totalAmount = quantity * pricePerLiter;

  const sale = await Sales.create({
    customerName,
    quantity,
    pricePerLiter,
    totalAmount
  });

  res.status(201).json(sale);
};

export const getSales = async (req, res) => {
  const sales = await Sales.find().sort({ date: -1 });
  res.json(sales);
};

export const deleteSale = async (req, res) => {
  const sale = await Sales.findById(req.params.id);

  if (!sale) {
    return res.status(404).json({ message: "Sale not found" });
  }

  await sale.deleteOne();
  res.json({ message: "Sale deleted successfully" });
};