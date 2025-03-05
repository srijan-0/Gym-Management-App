// const express = require("express");
// const app = express();
// require("dotenv").config();
// const mongoose = require("mongoose");
// const morgan = require("morgan");
// const cookieParser = require("cookie-parser");
// const cors = require("cors");

// // Import Router
// const authRouter = require("./routes/auth");
// const categoryRouter = require("./routes/categories");
// const noticeRoutes = require("./routes/notices");
// const productRouter = require("./routes/products");
// const brainTreeRouter = require("./routes/braintree");
// const orderRouter = require("./routes/orders");
// const usersRouter = require("./routes/users");
// const customizeRouter = require("./routes/customize");

// // Import Auth middleware for check user login or not~
// const { loginCheck } = require("./middleware/auth");
// const CreateAllFolder = require("./config/uploadFolderCreateScript");

// /* Create All Uploads Folder if not exists | For Uploading Images */
// CreateAllFolder();

// // Database Connection
// mongoose
//   .connect(process.env.DATABASE, {
//     useNewUrlParser: true,
//     useUnifiedTopology: true,
//     useCreateIndex: true,
//   })
//   .then(() =>
//     console.log(
//       "==============Mongodb Database Connected Successfully=============="
//     )
//   )
//   .catch((err) => console.log("Database Not Connected !!!"));

// // Middleware
// app.use(morgan("dev"));
// app.use(cookieParser());
// app.use(cors());
// app.use(express.urlencoded({ extended: false }));
// app.use(express.json());

// // ✅ Fix: Serve static images correctly
// app.use("/uploads", express.static("public/uploads"));

// // ✅ Debugging: Log requests to check if images are being accessed
// app.use((req, res, next) => {
//   console.log(`Request received: ${req.method} ${req.url}`);
//   next();
// });

// // Routes
// app.use("/api", authRouter);
// app.use("/api/user", usersRouter);
// app.use("/api/category", categoryRouter);
// app.use("/api/product", productRouter);
// app.use("/api", brainTreeRouter);
// app.use("/api/order", orderRouter);
// app.use("/api/customize", customizeRouter);
// app.use("/api/notice", noticeRoutes);

// // Run Server
// const PORT = process.env.PORT || 8000;
// app.listen(PORT, () => {
//   console.log("Server is running on ", PORT);
// });





//for real device

const express = require("express");
const app = express();
require("dotenv").config();
const mongoose = require("mongoose");
const morgan = require("morgan");
const cookieParser = require("cookie-parser");
const cors = require("cors");

// Import Router
const authRouter = require("./routes/auth");
const categoryRouter = require("./routes/categories");
const noticeRoutes = require("./routes/notices");
const productRouter = require("./routes/products");
const brainTreeRouter = require("./routes/braintree");
const orderRouter = require("./routes/orders");
const usersRouter = require("./routes/users");
const customizeRouter = require("./routes/customize");

// Import Auth middleware for check user login or not
const { loginCheck } = require("./middleware/auth");
const CreateAllFolder = require("./config/uploadFolderCreateScript");

/* Create All Uploads Folder if not exists | For Uploading Images */
CreateAllFolder();

// ✅ Fix MongoDB Connection & Remove Deprecated Option
mongoose
  .connect(process.env.DATABASE, {
    useNewUrlParser: true,
    useUnifiedTopology: true,
  })
  .then(() => console.log("✅ MongoDB Connected Successfully"))
  .catch((err) => console.log("❌ Database Not Connected:", err));

// ✅ Middleware
app.use(morgan("dev"));
app.use(cookieParser());
app.use(cors());
app.use(express.urlencoded({ extended: true }));
app.use(express.json());

// ✅ Fix: Serve static images correctly
app.use("/uploads", express.static("public/uploads"));

// ✅ Debugging: Log requests to check if images are being accessed
app.use((req, res, next) => {
  console.log(`📢 Request received: ${req.method} ${req.url}`);
  next();
});

// ✅ Default Home Route (Fix 404 on `/`)
app.get("/", (req, res) => {
  res.status(200).json({ message: "🚀 Welcome to the Gym Tracker API!" });
});

// ✅ Routes
app.use("/api", authRouter);
app.use("/api/user", usersRouter);
app.use("/api/category", categoryRouter);
app.use("/api/product", productRouter);
app.use("/api", brainTreeRouter);
app.use("/api/order", orderRouter);
app.use("/api/customize", customizeRouter);
app.use("/api/notice", noticeRoutes);

// ✅ Fix: 404 Handler for Undefined Routes
app.use((req, res) => {
  res.status(404).json({ error: "❌ Route Not Found" });
});

// ✅ Start Server

const PORT = process.env.PORT || 8000;
app.listen(PORT, "0.0.0.0", () => {
  console.log(`🚀 Server is running on http://192.168.101.13:${PORT}`);
});

