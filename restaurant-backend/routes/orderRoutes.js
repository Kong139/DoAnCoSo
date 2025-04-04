const express = require("express");
const Order = require("../models/Order");
const authenticateToken = require("../middleware/authMiddleware"); // Import middleware xác thực

const router = express.Router();

// Tạo đơn hàng mới
router.post("/", authenticateToken, async (req, res) => {
  try {
    const { listItem } = req.body;
    const phone = req.user.phone; // Lấy số điện thoại từ thông tin người dùng đã xác thực

    const newOrder = new Order({ phone, listItem });
    await newOrder.save();

    res.status(201).json(newOrder);
  } catch (error) {
    console.error("Lỗi tạo đơn hàng:", error);
    res.status(500).json({ message: "Lỗi server", error: error.message });
  }
});

// Lấy lịch sử đơn hàng của người dùng
router.get("/", authenticateToken, async (req, res) => {
  try {
    const phone = req.user.phone;
    const orders = await Order.find({ phone });
    res.json(orders);
  } catch (error) {
    console.error("Lỗi lấy lịch sử đơn hàng:", error);
    res.status(500).json({ message: "Lỗi server", error: error.message });
  }
});

// Lấy chi tiết đơn hàng theo ID
router.get("/:id", authenticateToken, async (req, res) => {
  try {
    const order = await Order.findById(req.params.id);
    if (!order) {
      return res.status(404).json({ message: "Không tìm thấy đơn hàng" });
    }
    // Kiểm tra xem đơn hàng có thuộc về người dùng hiện tại không (tùy chọn)
    if (order.phone !== req.user.phone) {
      return res.status(403).json({ message: "Không có quyền truy cập" });
    }
    res.json(order);
  } catch (error) {
    console.error("Lỗi lấy chi tiết đơn hàng:", error);
    res.status(500).json({ message: "Lỗi server", error: error.message });
  }
});

module.exports = router;