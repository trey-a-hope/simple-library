# Simple Library

A small full-stack demo of Flutter talking to GraphQL: a Flutter app for managing a list of books (title, author, year) backed by an Apollo Server + MongoDB API that lives in the same repo under `api/`.

## Features

- **Book list** loaded with a GraphQL query; tap to select a book, delete it, or edit it.
- **Add** tab: create a book from title, author and year.
- **Edit** tab: update the selected book.
- **Filter** tab: filter by author, by a start/end year range, or by a set of IDs (entered as chips with `flutter_chip_tags`).

## How it works

```
lib/                          Flutter client
├── main.dart
├── presentation/screens/home_screen.dart   # list + Add / Edit / Filter tabs
├── data/services/graphql_service.dart      # getBooks, books(filter), createBook, updateBook, deleteBook
├── domain/models/book_model.dart
└── util/config/graphql_config.dart         # HttpLink to the API
api/                          Apollo Server (TypeScript)
├── src/index.ts              # schema, resolvers, MongoDB connection
└── models/book.ts            # Mongoose Book model
```

The API exposes:

- Queries: `getBook(ID)`, `getBooks(limit)`, `books(input: { filter: { ids, author, startDate, endDate }, limit })`
- Mutations: `createBook(bookInput)`, `updateBook(ID, bookInput)`, `deleteBook(ID)`

## Tech stack

- Flutter with Dart `>=2.17.6 <3.0.0` (pre-Dart 3), `graphql_flutter`, `flutter_chip_tags`, `intl`
- Node.js, TypeScript, `@apollo/server` 4, `graphql`, `mongoose` / MongoDB

## Getting started

### API

```sh
cd api
npm install
npm run build      # tsc
npm start          # node ./dist/src/index.js
```

The MongoDB connection string is set in `api/src/index.ts`; point it at your own cluster (ideally via an environment variable) before running.

### App

The client's endpoint is set in `lib/util/config/graphql_config.dart` (currently a Heroku URL that may no longer be live). Change it to your API's URL, then:

```sh
flutter pub get
flutter run
```

## Status

A 2023 learning project; not actively maintained.
