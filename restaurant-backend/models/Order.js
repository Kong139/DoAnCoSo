const mongoose = require("mongoose");
const moment = require("moment-timezone");

const OrderSchema = new mongoose.Schema({
  phone: { type: String, required: true },
  listItem: [
    {
      itemId: { type: Number, required: true },
      quantity: { type: Number, required: true, default: 1 },
      notes: { type: String },
    },
  ],
  orderDate: {
    type: Date,
    default: () => moment().tz("Asia/Ho_Chi_Minh").toDate(),
  },
  paymentDate: { type: Date },
});

module.exports = mongoose.model("Order", OrderSchema);