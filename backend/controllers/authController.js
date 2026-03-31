import User from "../models/User.js";
import bcrypt from "bcryptjs";
import generateToken from "../utils/generateToken.js";

export const registerUser = async (req, res) => {
  try {
    console.log("REGISTER API HIT"); // ✅ check request

    const { name, email, password } = req.body;

    if (!name || !email || !password) {
      return res.status(400).json({ message: "All fields required" });
    }

    const userExists = await User.findOne({ email });
    if (userExists) {
      console.log("USER ALREADY EXISTS"); // ✅ debug
      return res.status(400).json({ message: "User already exists" });
    }

    const hashedPassword = await bcrypt.hash(password, 10);

    const user = await User.create({
      name,
      email,
      password: hashedPassword,
    });

    console.log("USER SAVED:", user); // ✅ MOST IMPORTANT

    // 🔥 EXTRA CHECK — fetch all users
    const allUsers = await User.find();
    console.log("ALL USERS:", allUsers);

    res.status(201).json({
      _id: user._id,
      email: user.email,
      token: generateToken(user._id),
    });

  } catch (error) {
    console.log("ERROR:", error); // ✅ show real error
    res.status(500).json({ message: error.message });
  }
};

export const loginUser = async (req, res) => {
  try {
    console.log("LOGIN API HIT"); // ✅ debug

    const { email, password } = req.body;

    const user = await User.findOne({ email });

    if (!user) {
      console.log("USER NOT FOUND");
      return res.status(400).json({ message: "Invalid credentials" });
    }

    const isMatch = await bcrypt.compare(password, user.password);

    if (!isMatch) {
      console.log("PASSWORD WRONG");
      return res.status(400).json({ message: "Invalid credentials" });
    }

    console.log("LOGIN SUCCESS:", user);

    res.json({
      _id: user._id,
      email: user.email,
      token: generateToken(user._id),
    });

  } catch (error) {
    console.log("ERROR:", error);
    res.status(500).json({ message: error.message });
  }
};