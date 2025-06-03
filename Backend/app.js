const express = require("express");
const body_parser = require("body-parser");
const userRouter = require("./routes/user.routes");
const ToDoRouter = require("./routes/todo.routes");

const app = express();

app.use(body_parser.json());

app.use("/", userRouter);
app.use("/", ToDoRouter);

module.exports = app;
