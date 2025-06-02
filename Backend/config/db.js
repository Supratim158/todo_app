const mongoose = require('mongoose');


const connection = mongoose.createConnection('mongodb://localhost:27017/newToDo').on('open',()=>{
    console.log("MongoDb Connected");
}).on('error',()=>{
    console.log("MongoDb error ");
});


module.exports = connection;