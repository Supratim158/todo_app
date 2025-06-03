const mongoose = require('mongoose');
const db = require('../config/db');
const UserModel = require('../model/user.model');

const { Schema } = mongoose;

const todoSchema = new Schema({
    userId: {
        type: Schema.Types.ObjectId,
        ref: UserModel.modelName,
        required: true
    },
    title: {
        type: String,
        required: true
    },
    desc: {
        type: String,
        required: true
    }
});

const ToDoModel = db.model('todo', todoSchema);

module.exports = ToDoModel;