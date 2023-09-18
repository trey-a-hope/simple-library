import { Schema, model } from 'mongoose';

interface IBook {
    id?: String,
    author: String,
    title: String,
    year: Date,
}

const BookSchema = new Schema<IBook>({
    id: String,
    author: { type: String, required: true },
    title: { type: String, required: true },
    year: { type: Date, required: true }
});

const Book = model<IBook>('books', BookSchema);

export default Book;