const express = require("express");
const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");
const User = require("../models/User");

const router = express.Router();

// Đăng ký
router.post("/register", async (req, res) => {
  try {
    const { name, phone, password } = req.body;

    // Kiểm tra số điện thoại đã tồn tại chưa
    const userExists = await User.findOne({ phone });
    if (userExists) return res.status(400).json({ message: "Số điện thoại đã tồn tại!" });

    // Mã hóa mật khẩu
    const hashedPassword = await bcrypt.hash(password, 10);

    // Tạo user mới
    const newUser = new User({ name, phone, password: hashedPassword });
    await newUser.save();

    res.status(201).json({ message: "Đăng ký thành công!" });
  } catch (error) {
    res.status(500).json({ message: "Lỗi server" });
  }
});

// Đăng nhập
router.post("/login", async (req, res) => {
  try {
    const { phone, password } = req.body;

    // Kiểm tra user có tồn tại không
    const user = await User.findOne({ phone });
    if (!user) return res.status(400).json({ message: "Tài khoản không tồn tại!" });

    // Kiểm tra mật khẩu
    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) return res.status(400).json({ message: "Sai mật khẩu!" });

    // Tạo JWT token
    const token = jwt.sign(
      { id: user._id, name: user.name, phone: user.phone },
      process.env.JWT_SECRET || "default_secret",  // Tránh lỗi nếu env bị thiếu
      { expiresIn: "1h" }
    );

    console.log("Đăng nhập thành công:", { token, name: user.name, phone: user.phone });  // Log ra terminal

    return res.json({ message: "Đăng nhập thành công!", token, name: user.name, phone: user.phone });
  } catch (error) {
    console.error("Lỗi đăng nhập:", error);  // In lỗi server nếu có
    return res.status(500).json({ message: "Lỗi server" });
  }
});

module.exports = router;
