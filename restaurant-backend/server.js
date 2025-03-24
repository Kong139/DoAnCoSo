require("dotenv").config();
const express = require("express");
const mongoose = require("mongoose");
const cors = require("cors");

const app = express();

// Middleware
app.use(cors());
app.use(express.json());

// Kết nối MongoDB
mongoose.connect(process.env.MONGO_URI, {
  useNewUrlParser: true,
  useUnifiedTopology: true,
})
.then(() => console.log("✅ Connected to MongoDB Atlas"))
.catch(err => {
  console.error("❌ MongoDB connection error:", err);
  process.exit(1);
});

// Import routes
const authRoutes = require("./routes/authRoutes");
const menuRoutes = require("./routes/menuRoutes");

// Sử dụng routes
app.use("/api/auth", authRoutes);
app.use("/api/menu", menuRoutes);

const PORT = process.env.PORT || 8081;
app.listen(PORT, () => console.log(`🚀 Server running on port ${PORT}`));
