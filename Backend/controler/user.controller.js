const UserService = require("../services/user.services");

exports.register = async (req, res, next) => {
    try {
        const { email, password } = req.body;

        // Validate input
        if (!email || !password) {
            throw new Error("Email and password are required");
        }

        const successRes = await UserService.registerUser(email, password);

        res.json({ status: true, success: "User registered successfully" });
    } catch (error) {
        // Pass error to Express error handler
        next(error);
    }
};

exports.login = async (req, res, next) => {
    try {
        const { email, password } = req.body;

        // Validate input
        if (!email || !password) {
            throw new Error("Email and password are required");
        }

        const user = await UserService.checkUser(email);
        if (!user) {
            throw new Error("User doesn't exist");
        }

        const isMatch = await user.comparePassword(password);
        if (!isMatch) {
            throw new Error("Invalid password");
        }

        // Ensure token data uses correct field names
        let tokenData = { id: user._id, email: user.email };

        // Generate token with a proper secret and expiration
        const token = await UserService.generateToken(tokenData, "secretKey", "1h");

        res.status(200).json({ status: true, token: token });
    } catch (error) {
        // Pass error to Express error handler
        next(error);
    }
};