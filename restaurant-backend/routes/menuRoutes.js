const express = require("express");
const MenuItem = require("../models/MenuItem");

const router = express.Router();

// Thêm món ăn
router.post("/", async (req, res) => {
  try {
    const { id, name, image, price, category } = req.body;

    // Kiểm tra id đã tồn tại chưa
    const itemExists = await MenuItem.findOne({ id });
    if (itemExists) return res.status(400).json({ message: "ID món ăn đã tồn tại!" });

    const newItem = new MenuItem({ id, name, image, price, category });
    await newItem.save();
    res.status(201).json(newItem);
  } catch (error) {
    res.status(500).json({ message: "Lỗi server" });
  }
});

// Lấy danh sách món ăn
router.get("/", async (req, res) => {
  try {
    const items = await MenuItem.find();
    res.json(items);
  } catch (error) {
    res.status(500).json({ message: "Lỗi server" });
  }
});

// Xóa món ăn
router.delete("/:id", async (req, res) => {
  try {
    await MenuItem.findOneAndDelete({ id: req.params.id });
    res.json({ message: "Xóa món ăn thành công!" });
  } catch (error) {
      console.error("🔥 Lỗi API /api/menu:", error);
      res.status(500).json({ message: "Lỗi server", error: error.message });
  }
});

module.exports = router;
