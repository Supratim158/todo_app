const router = require("express").Router();
const UserController = require("../controler/user.controller");

router.post("/registration", UserController.register);
router.post("/login", UserController.login);

module.exports = router;
