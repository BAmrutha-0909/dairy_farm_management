import mongoose from "mongoose";

const salesSchema = mongoose.Schema(
  {
    customerName: { type: String, required: true },
    quantity: { type: Number, required: true }, // liters
    pricePerLiter: { type: Number, required: true },
    totalAmount: { type: Number, required: true },
    date: { type: Date, default: Date.now }
  },
  { timestamps: true }
);

export default mongoose.model("Sales", salesSchema);