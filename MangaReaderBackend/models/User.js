const mongoose = require('mongoose');
const bcrypt = require('bcryptjs');
const crypto = require('crypto');

const userSchema = new mongoose.Schema({
  authProvider: {
    type: String,
    required: [true, 'Auth provider is required.'],
    enum: ['google', 'email'],
    default: 'email'
  },
  googleId: {
    type: String,
    unique: true,
    sparse: true
  },
  email: {
    type: String,
    required: [true, 'Vui lòng cung cấp email của bạn'],
    unique: true,
    lowercase: true,
  },
  password: {
    type: String,
    select: false
  },
  displayName: {
    type: String,
    required: [true, 'Vui lòng cung cấp tên hiển thị']
  },
  photoURL: {
    type: String
  },
  isVerified: {
    type: Boolean,
    default: false,
  },
  verificationToken: String,
  verificationTokenExpires: Date,
  passwordResetToken: String,
  passwordResetTokenExpires: Date,
  followingManga: [{
    type: String
  }],
  readingManga: [{
    mangaId: {
      type: String,
      required: true
    },
    lastChapter: {
      type: String,
      required: true
    },
    lastReadAt: {
      type: Date,
      default: Date.now
    }
  }],
  tokens: [{
    token: {
      type: String,
      required: true
    },
    createdAt: {
      type: Date,
      default: Date.now,
      expires: '30d'
    }
  }],
  createdAt: {
    type: Date,
    default: Date.now
  }
});

userSchema.pre('save', async function(next) {
  if (!this.isModified('password')) return next();
  this.password = await bcrypt.hash(this.password, 12);
  next();
});

userSchema.methods.comparePassword = async function(candidatePassword) {
  if (!this.password) return false;
  return await bcrypt.compare(candidatePassword, this.password);
};

userSchema.methods.generateVerificationToken = function() {
  const token = crypto.randomBytes(32).toString('hex');
  this.verificationToken = crypto
    .createHash('sha256')
    .update(token)
    .digest('hex');
  this.verificationTokenExpires = Date.now() + 24 * 60 * 60 * 1000;
  return token;
};

userSchema.methods.generatePasswordResetToken = function() {
  const resetToken = Math.floor(100000 + Math.random() * 900000).toString();
  this.passwordResetToken = crypto
    .createHash('sha256')
    .update(resetToken)
    .digest('hex');
  this.passwordResetTokenExpires = Date.now() + 60 * 60 * 1000;
  return resetToken;
};

userSchema.methods.addToken = async function(token) {
  this.tokens = this.tokens || [];
  this.tokens.push({ token });
  await this.save({ validateBeforeSave: false });
  return token;
};

userSchema.methods.removeToken = async function(token) {
  this.tokens = this.tokens.filter(t => t.token !== token);
  await this.save({ validateBeforeSave: false });
};

module.exports = mongoose.model('User', userSchema);