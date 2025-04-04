const mongoose = require("mongoose");

const OrderSchema = new mongoose.Schema({
  phone: { type: String, required: true }, // Số điện thoại người dùng
  listItem: [
    {
      itemId: { type: Number, required: true }, // ID món ăn
      quantity: { type: Number, required: true, default: 1 }, // Số lượng
    },
  ],
  orderDate: { type: Date, default: Date.now }, // Ngày tạo đơn hàng
  paymentDate: { type: Date }, // Ngày thanh toán (nếu có)
});

module.exports = mongoose.model("Order", OrderSchema);