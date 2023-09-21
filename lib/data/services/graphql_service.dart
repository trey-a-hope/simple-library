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
    List<String>? ids,
    String? author,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      var input = {};
      var filter = {};

      bool shouldApplyLimit = limit != null;
      if (shouldApplyLimit) {
        input.addAll({"limit": limit});
      }

      bool shouldApplyFilter = !(ids == null &&
          author == null &&
          startDate == null &&
          endDate == null);
      if (shouldApplyFilter) {
        bool shouldApplyIDsFilter = ids != null;
        if (shouldApplyIDsFilter) {
          filter.addAll({"ids": ids});
        }

        bool shouldApplyAuthorFilter = author != null;
        if (shouldApplyAuthorFilter) {
          filter.addAll({"author": author});
        }

        bool shouldApplyDateRangeFilter = startDate != null && endDate != null;
        if (shouldApplyDateRangeFilter) {
          filter.addAll({
            "startDate": startDate.toIso8601String(),
            "endDate": endDate.toIso8601String()
          });
        }

        input.addAll({"filter": filter});
      }

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
