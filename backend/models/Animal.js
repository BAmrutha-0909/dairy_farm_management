import mongoose from "mongoose";

const animalSchema = mongoose.Schema(
  {
    id: {
      type: String,
      required: true,
      unique: true
    },
    name: {
      type: String,
      required: true
    },
    purchasePrice: {
      type: Number,
      required: true
    },
    purchaseDate: {
      type: Date,
      required: true
    }
  },
  {
    timestamps: true
  }
);

export default mongoose.model("Animal", animalSchema);