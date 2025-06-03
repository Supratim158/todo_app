const UserModel = require('../model/user.model');
const jwt = require('jsonwebtoken');

class UserService{
    static async registerUser(email,password){
        try {
            const createUser = new UserModel({email,password});
            return await createUser.save();
        } catch (error) {
            throw error;
        }
    }
    static async checkUser(email){
        try {
            return await UserModel.findOne({email});
        } catch (error) {
            throw error;
        }
    }

    static async generateToken(tokenData,secretKey,jwt_expire){
        return jwt.sign(tokenData,secretKey,{expiresIn:jwt_expire});
    }
}

module.exports = UserService;