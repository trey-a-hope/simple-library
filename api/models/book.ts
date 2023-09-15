import { Schema, model } from 'mongoose';

interface IBook {
    id?: String,
    author: String,
    title: String,
    year: Number,
}

const BookSchema = new Schema<IBook>({
    id: String,
    author: { type: String, required: true },
    title: { type: String, required: true },
    year: { type: Number, required: true }
});

const Book = model<IBook>('books', BookSchema);

export default Book;