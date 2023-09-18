import { ApolloServer } from "@apollo/server";
import { startStandaloneServer } from '@apollo/server/standalone';
import { connect, Types } from 'mongoose';
import Book from '../models/book.js';
const MONGODB = 'mongodb+srv://root:root@cluster0.lvx6woa.mongodb.net/Books?retryWrites=true&w=majority';
const typeDefs = `#graphql
    type Book {
        _id: String
        author: String
        title: String
        year: String
    }

    input BookFilters {
        author: String
        ids: [ID!]
        startDate: String
        endDate: String
    }

    input BookFiltersInput {
        filter: BookFilters
        limit: Int
    }

    input BookInput {
        author: String
        title: String
        year: String
    }

    type Query {
        getBook(ID: ID!): Book
        getBooks(limit: Int): [Book]!
        books(input: BookFiltersInput): [Book]!
    }

    type Mutation {
        createBook(bookInput: BookInput): String!
        updateBook(ID: ID!, bookInput: BookInput): String!
        deleteBook(ID: ID!): String!
    }
`;
const resolvers = {
    Query: {
        async getBook(_, { ID }) {
            return await Book.findById(ID);
        },
        async getBooks(_, { limit }) {
            return await Book.find().limit(limit);
        },
        async books(parent, args, context, info) {
            // Extract the filter value from the args param.
            const { filter } = args.input;
            // Extract the limit value from the args param.
            const { limit } = args;
            //Only apply filters if some are passed into query.
            const shouldApplyFilters = filter != null;
            if (!shouldApplyFilters) {
                return await Book.find().limit(limit);
            }
            //Apply author filter if applicable.
            const shouldApplyAuthorFilter = filter['author'] != null;
            if (shouldApplyAuthorFilter) {
                // Return books that were written by said author.
                return await Book.find({ "author": filter.author });
            }
            //Apply ids filter if applicable.
            const shouldApplyIdsFilter = filter.ids;
            if (shouldApplyIdsFilter) {
                // Extract ids from filter objects.
                let ids = filter.ids;
                // Remove any strings that are not formatted correctly.
                ids = ids.filter(id => Types.ObjectId.isValid(id));
                // Return books that have these ids.
                return await Book.find({ "_id": { "$in": ids } });
            }
            //Apply date filter if applicable.
            const shouldApplyDateFilter = filter.startDate != null && filter.endDate != null;
            if (shouldApplyDateFilter) {
                // Extract dates from filter object.
                let startDate = filter.startDate;
                let endDate = filter.endDate;
                // Return books that are between the start and end date.
                return await Book.find({
                    "year": { "$gte": startDate, "$lte": endDate }
                });
            }
        }
    },
    Mutation: {
        async createBook(_, { bookInput: { author, title, year } }) {
            const res = await new Book({ author, title, year }).save();
            return res._id;
        },
        async updateBook(_, { ID, bookInput: { author, title, year } }) {
            await Book.updateOne({ _id: ID }, { $set: { author, title, year } });
            return ID;
        },
        async deleteBook(_, { ID }) {
            await Book.remove({ _id: ID });
            return ID;
        }
    }
};
await connect(MONGODB);
const server = new ApolloServer({
    typeDefs,
    resolvers,
});
const port = Number.parseInt(process.env.PORT) || 4000;
const { url } = await startStandaloneServer(server, {
    listen: { port: port }
});
console.log(`Server is ready at ${url}`);
// Process for pushing changes to Heroku...
// heroku git:remote -a books-demo-apollo-server
// git add .  
// git commit . -m 'Updated mongodb connection string.'
// git push -f heroku main
