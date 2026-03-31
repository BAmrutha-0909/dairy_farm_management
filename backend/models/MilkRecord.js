import mongoose from "mongoose";

const milkSchema = mongoose.Schema(
  {
    animal: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Animal",
      required: true
    },
    quantity: { type: Number, required: true },
    date: { type: Date, default: Date.now }
  },
  { timestamps: true }
);

export default mongoose.model("MilkRecord", milkSchema);