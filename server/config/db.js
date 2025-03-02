const mongoose = require("mongoose");
try {
  mongoose.connect("mongodb://localhost:27017/ecommerce", {
    useNewUrlParser: true,
    useUnifiedTopology: true,
    useCreateIndex: true,
  });
  console.log("Database Connected Successfully");
} catch (err) {
  console.log("Database Not Connected");
}







//for real device

// const mongoose = require("mongoose");

// const connectDB = async () => {
//   try {
//     await mongoose.connect("mongodb://127.0.0.1:27017/ecommerce", {
//       useNewUrlParser: true,
//       useUnifiedTopology: true,
//     });
//     console.log("✅ MongoDB Connected Successfully!");
//   } catch (err) {
//     console.error("❌ MongoDB Connection Failed:", err);
//     process.exit(1); // Exit process with failure
//   }
// };

// module.exports = connectDB;
