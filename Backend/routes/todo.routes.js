const router = require("express").Router();
const TodoController = require('../controler/todo.controller');

router.post('/storeTodo', TodoController.createTodo);

router.post('/getUserTodoList', TodoController.getUserTodo);

router.post('/deleteTodo', TodoController.deleteTodo);

module.exports = router;