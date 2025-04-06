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

// Lấy thông tin món ăn theo ID
router.get("/:id", async (req, res) => {
  try {
    const itemId = parseInt(req.params.id);
    if (isNaN(itemId)) { // Kiểm tra xem có phải là số hợp lệ không
      return res.status(400).json({ message: "ID món ăn không hợp lệ" });
    }
    const item = await MenuItem.findOne({ id: itemId });
    if (item) {
      res.json(item);
    } else {
      res.status(404).json({ message: "Không tìm thấy món ăn" });
    }
  } catch (error) {
    res.status(500).json({ message: "Lỗi server" });
  }
});

module.exports = router;
