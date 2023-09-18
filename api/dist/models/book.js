import { Schema, model } from 'mongoose';
const BookSchema = new Schema({
    id: String,
    author: { type: String, required: true },
    title: { type: String, required: true },
    year: { type: Date, required: true }
});
const Book = model('books', BookSchema);
export default Book;
