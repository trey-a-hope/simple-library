import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:simple_library/book_model.dart';
import 'package:simple_library/graphql_config.dart';

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

        List<BookModel> feelings =
            res.map((feeling) => BookModel.fromMap(map: feeling)).toList();

        return feelings;
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
    required int year,
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
              "year": year,
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
    required int year,
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
              "year": year,
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
}
