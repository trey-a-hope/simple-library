import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:simple_library/domain/models/book_model.dart';
import 'package:simple_library/util/config/graphql_config.dart';

class GraphQLService {
  static GraphQLConfig graphQLConfig = GraphQLConfig();
  GraphQLClient client = graphQLConfig.clientToQuery();

  Future<List<BookModel>> getBooks({
    required int limit,
  }) async {
    try {
      QueryResult result = await client.query(
        QueryOptions(
          fetchPolicy: FetchPolicy.noCache,
          document: gql("""
           query Query(\$limit: Int) {
              getBooks(limit: \$limit) {
                _id
                author
                title
                year
              }
            }
            """),
          variables: {
            'limit': limit,
          },
        ),
      );

      if (result.hasException) {
        throw Exception(result.exception);
      } else {
        List? res = result.data?['getBooks'];

        if (res == null || res.isEmpty) {
          return [];
        }

        List<BookModel> books =
            res.map((book) => BookModel.fromMap(map: book)).toList();

        return books;
      }
    } catch (error) {
      return [];
    }
  }

  Future<bool> deleteBook({required String id}) async {
    try {
      QueryResult result = await client.mutate(
        MutationOptions(
          fetchPolicy: FetchPolicy.noCache,
          document: gql("""
            mutation Mutation(\$id: ID!) {
              deleteBook(ID: \$id)
            }
          """),
          variables: {
            "id": id,
          },
        ),
      );
      if (result.hasException) {
        throw Exception(result.exception);
      } else {
        return true;
      }
    } catch (error) {
      return false;
    }
  }

  Future<bool> createBook({
    required String title,
    required String author,
    required DateTime year,
  }) async {
    try {
      QueryResult result = await client.mutate(
        MutationOptions(
          fetchPolicy: FetchPolicy.noCache,
          document: gql("""
              mutation Mutation(\$bookInput: BookInput) {
                createBook(bookInput: \$bookInput)
              }
            """),
          variables: {
            "bookInput": {
              "title": title,
              "author": author,
              "year": year.toIso8601String(),
            }
          },
        ),
      );

      if (result.hasException) {
        throw Exception(result.exception);
      } else {
        return true;
      }
    } catch (error) {
      return false;
    }
  }

  Future updateBook({
    required String id,
    required String title,
    required String author,
    required DateTime year,
  }) async {
    try {
      QueryResult result = await client.mutate(
        MutationOptions(
          fetchPolicy: FetchPolicy.noCache,
          document: gql(
            """
              mutation Mutation(\$id: ID!, \$bookInput: BookInput) {
                updateBook(ID: \$id, bookInput: \$bookInput)
              }
            """,
          ),
          variables: {
            "id": id,
            "bookInput": {
              "title": title,
              "author": author,
              "year": year.toIso8601String(),
            }
          },
        ),
      );

      if (result.hasException) {
        throw Exception(result.exception);
      }
    } catch (error) {
      throw Exception(error);
    }
  }

  Future<List<BookModel>> books({
    int? limit,
    DateTime? startDate,
    DateTime? endDate,
    String? author,
    List<String> ids = const [],
  }) async {
    var input = {};
    var filter = {};

    bool shouldAddLimit = limit != null;

    bool shouldAddFilter = !(startDate == null &&
        endDate == null &&
        author == null &&
        ids.isEmpty);

    if (shouldAddLimit) {
      // Add limit to the input map.
      input.addAll({'limit': limit});
    }

    if (shouldAddFilter) {
      // If filtering on start and end date...
      if (startDate != null && endDate != null) {
        filter.addAll({
          "endDate": endDate.toIso8601String(),
          "startDate": startDate.toIso8601String(),
        });
      }

      // If filtering on author.
      if (author != null) {
        filter.addAll({
          "author": author,
        });
      }

      // If filtering on ids.
      if (ids.isNotEmpty) {
        filter.addAll({
          "ids": ids,
        });
      }

      // Add filters to the input map.
      input.addAll({'filter': filter});
    }

    try {
      QueryResult result = await client.query(
        QueryOptions(
          fetchPolicy: FetchPolicy.noCache,
          document: gql("""
            query Query(\$input: BookFiltersInput) {
              books(input: \$input) {
                _id
                author
                title
                year
              }
            }
            """),
          variables: {
            'input': input,
          },
        ),
      );

      if (result.hasException) {
        throw Exception(result.exception);
      } else {
        List? res = result.data?['books'];

        if (res == null || res.isEmpty) {
          return [];
        }

        List<BookModel> books =
            res.map((book) => BookModel.fromMap(map: book)).toList();

        return books;
      }
    } catch (error) {
      return [];
    }
  }
}
