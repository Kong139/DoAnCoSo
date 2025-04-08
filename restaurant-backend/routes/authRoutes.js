const express = require("express");
const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");
const User = require("../models/User");
const authenticateToken = require("../middleware/authMiddleware");

const router = express.Router();

// Đăng ký
router.post("/register", async (req, res) => {
  try {
    const { name, phone, password } = req.body;
    if (!name) return res.status(400).json({ message: "Tên người dùng không được để trống!" });
    if (!phone) return res.status(400).json({ message: "Số điện thoại không được để trống!" });
    if (!password) return res.status(400).json({ message: "Mật khẩu không được để trống!" });

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
    console.error("Lỗi đăng ký:", error); // Thêm log lỗi chi tiết
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

// Route kiểm tra token có hợp lệ không
router.get("/validate", authenticateToken, (req, res) => {
  res.json({ message: "Token hợp lệ!", user: req.user });
});

// Route /me để lấy thông tin người dùng từ token
router.get("/me", authenticateToken, (req, res) => {
  res.json({
    name: req.user.name,
    phone: req.user.phone,
  });
});

// Đổi mật khẩu
router.post("/change-password", authenticateToken, async (req, res) => {
  try {
    const { oldPassword, newPassword } = req.body;

    if (!oldPassword || !newPassword) {
      return res.status(400).json({ message: "Vui lòng nhập đầy đủ mật khẩu cũ và mới!" });
    }

    // Tìm người dùng từ ID có trong token
    const user = await User.findById(req.user.id);
    if (!user) return res.status(404).json({ message: "Người dùng không tồn tại!" });

    // So sánh mật khẩu cũ
    const isMatch = await bcrypt.compare(oldPassword, user.password);
    if (!isMatch) return res.status(400).json({ message: "Mật khẩu cũ không đúng!" });

    // Mã hóa và cập nhật mật khẩu mới
    const hashedNewPassword = await bcrypt.hash(newPassword, 10);
    user.password = hashedNewPassword;
    await user.save();

    res.json({ message: "Đổi mật khẩu thành công!" });
  } catch (error) {
    console.error("Lỗi đổi mật khẩu:", error);
    res.status(500).json({ message: "Lỗi server" });
  }
});

module.exports = router;
