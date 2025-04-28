const express = require('express');
const mongoose = require('mongoose');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');

const app = express();
const port = 3000;

app.use(express.json());

// Connect to MongoDB
mongoose.connect('mongodb://mongo-db:27017/focusease', {
  useNewUrlParser: true,
  useUnifiedTopology: true,
});

// User Schema
const userSchema = new mongoose.Schema({
  username: { type: String, unique: true },
  password: String,
  email: String,
  fullName: String
});

const User = mongoose.model('User', userSchema);

// Generate Token
function generateToken(user) {
  return jwt.sign({ id: user._id, username: user.username }, 'SECRET', { expiresIn: '7d' });
}

// Middleware to protect routes
function authMiddleware(req, res, next) {
  const authHeader = req.headers.authorization;
  if (!authHeader) return res.status(401).send('No token provided');

  const token = authHeader.split(' ')[1];
  jwt.verify(token, 'SECRET', (err, decoded) => {
    if (err) return res.status(403).send('Failed to authenticate token');
    req.userId = decoded.id;
    next();
  });
}

// Routes

// Register new user
app.post('/register', async (req, res) => {
  try {
    const { username, password, email, fullName } = req.body;
    const hashed = await bcrypt.hash(password, 10);
    const user = new User({ username, password: hashed, email, fullName });
    await user.save();
    res.status(201).send('User registered!');
  } catch (error) {
    console.error(error);
    res.status(400).send('Error registering user. Username might already exist.');
  }
});

// Login user
app.post('/login', async (req, res) => {
  try {
    const { username, password } = req.body;
    const user = await User.findOne({ username });
    if (!user) return res.status(400).send('User not found');

    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) return res.status(400).send('Invalid credentials');

    const token = generateToken(user);
    res.send({ token });
  } catch (error) {
    console.error(error);
    res.status(500).send('Login error');
  }
});

// Get profile
app.get('/profile', authMiddleware, async (req, res) => {
  try {
    const user = await User.findById(req.userId).select('-password');
    res.send(user);
  } catch (error) {
    console.error(error);
    res.status(500).send('Error fetching profile');
  }
});

// Update profile
app.put('/profile', authMiddleware, async (req, res) => {
  try {
    const { email, fullName } = req.body;
    const user = await User.findByIdAndUpdate(req.userId, { email, fullName }, { new: true }).select('-password');
    res.send(user);
  } catch (error) {
    console.error(error);
    res.status(500).send('Error updating profile');
  }
});

// Test route
app.get('/', (req, res) => res.send('User Service with Profile Management is running!'));

app.listen(port, () => console.log(`User Service running on port ${port}`));
