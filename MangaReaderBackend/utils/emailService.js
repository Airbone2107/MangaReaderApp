const nodemailer = require('nodemailer');

const sendEmail = async (options) => {
  const transporter = nodemailer.createTransport({
    host: process.env.EMAIL_HOST,
    port: process.env.EMAIL_PORT,
    secure: false,
    auth: {
      user: process.env.EMAIL_USER,
      pass: process.env.EMAIL_PASS,
    },
  });

  const resolvedFrom = (process.env.EMAIL_FROM && process.env.EMAIL_FROM.trim() !== '')
    ? process.env.EMAIL_FROM
    : (process.env.EMAIL_USER ? `Manga Reader App <${process.env.EMAIL_USER}>` : undefined);

  const mailOptions = {
    from: resolvedFrom,
    to: options.email,
    subject: options.subject,
    text: options.message,
  };

  await transporter.sendMail(mailOptions);
};

module.exports = sendEmail;


