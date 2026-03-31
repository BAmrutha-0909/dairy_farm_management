import express from "express";
import dotenv from "dotenv";
import cors from "cors";
import connectDB from "./config/db.js";
import salesRoutes from "./routes/salesRoutes.js";
import authRoutes from "./routes/authRoutes.js";
import animalRoutes from "./routes/animalRoutes.js";
import milkRoutes from "./routes/milkRoutes.js";
import expenseRoutes from "./routes/expenseRoutes.js";
import errorHandler from "./middleware/errorMiddleware.js";
import mongoose from "mongoose";
dotenv.config();
connectDB();

const app = express();

app.use(cors());
app.use(express.json());
mongoose.connect(process.env.MONGO_URI)
  .then(() => console.log("MongoDB Connected"))
  .catch(err => console.log(err));
app.get("/", (req, res) => {
  res.send("Dairy Farm Backend Running");
});

app.use("/api/auth", authRoutes);
app.use("/api/animals", animalRoutes);
app.use("/api/milk", milkRoutes);
app.use("/api/expenses", expenseRoutes);
app.use("/api/sales", salesRoutes);

app.use(errorHandler);   // ✅ MUST BE LAST

const PORT = process.env.PORT || 5000;

app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});