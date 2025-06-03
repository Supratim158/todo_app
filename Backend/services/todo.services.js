const ToDoModel = require('../model/todo.model');

class ToDoServices {
    static async createTodo(userId, title, desc) {
        try {
            const createTodo = new ToDoModel({ userId, title, desc });
            return await createTodo.save();
        } catch (error) {
            throw new Error('Failed to create todo: ' + error.message);
        }
    }

    static async getTodoData(userId) {
        try {
            const todoData = await ToDoModel.find({ userId });
            return todoData;
        } catch (error) {
            throw new Error('Failed to fetch todo: ' + error.message);
        }
    }

    static async deleteTodo(id) {
        try {
            const deleted = await ToDoModel.findOneAndDelete({_id: id});
            return deleted;
        } catch (error) {
            throw new Error('Failed to fetch todo: ' + error.message);
        }
    }
}

module.exports = ToDoServices;