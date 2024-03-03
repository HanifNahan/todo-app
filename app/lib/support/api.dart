/*
 * File: api.dart
 * Description: This file contains the API class, which provides methods for making HTTP requests.
 */

import 'dart:convert'; // Importing the dart:convert library for JSON encoding and decoding.
import 'package:http/http.dart'
    as http; // Importing the http library for making HTTP requests.

/*
 * Class: API
 * Description: This class provides methods for making HTTP requests to an API.
 */
class API {
  static String apiUrl = 'http://127.0.0.1:8000/'; // Base URL of the API.

  /*
   * Function: get
   * Description: Performs a GET request to the specified path.
   * Parameters:
   *   - path: The endpoint path to make the request to.
   * Returns: A dynamic object containing the response data and status.
   */
  dynamic get(String path) async {
    final url = apiUrl + path; // Constructing the complete URL.
    final response = await http.get(Uri.parse(url)); // Making the GET request.
    bool isSuccess =
        response.statusCode == 200; // Checking if the request was successful.
    return {
      "status": isSuccess,
      "data": json.decode(response.body)
    }; // Returning response data.
  }

  /*
   * Function: post
   * Description: Performs a POST request to the specified path with the given data.
   * Parameters:
   *   - path: The endpoint path to make the request to.
   *   - data: The data to be sent in the request body.
   * Returns: A dynamic object containing the response data and status.
   */
  dynamic post(String path, Map<String, dynamic> data) async {
    final url = apiUrl + path; // Constructing the complete URL.
    final headers = {
      'Content-Type':
          'application/json', // Setting the content type of the request.
    };
    final response = await http.post(Uri.parse(url), // Making the POST request.
        body: jsonEncode(data), // Encoding the data to JSON format.
        headers: headers); // Passing the headers.
    bool isSuccess =
        response.statusCode == 201; // Checking if the request was successful.
    return {
      "status": isSuccess,
      "data": json.decode(response.body)
    }; // Returning response data.
  }

  /*
   * Function: put
   * Description: Performs a PUT request to the specified path with the given data.
   * Parameters:
   *   - path: The endpoint path to make the request to.
   *   - data: The data to be sent in the request body.
   * Returns: A dynamic object containing the response data and status.
   */
  dynamic put(String path, Map<String, dynamic> data) async {
    final url = apiUrl + path; // Constructing the complete URL.
    final headers = {
      'Content-Type':
          'application/json', // Setting the content type of the request.
    };
    final response = await http.put(Uri.parse(url), // Making the PUT request.
        body: jsonEncode(data), // Encoding the data to JSON format.
        headers: headers); // Passing the headers.
    bool isSuccess =
        response.statusCode == 200; // Checking if the request was successful.
    return {
      "status": isSuccess,
      "data": json.decode(response.body)
    }; // Returning response data.
  }

  /*
   * Function: delete
   * Description: Performs a DELETE request to the specified path.
   * Parameters:
   *   - path: The endpoint path to make the request to.
   * Returns: A dynamic object containing the response status.
   */
  dynamic delete(String path) async {
    final url = apiUrl + path; // Constructing the complete URL.
    final response =
        await http.delete(Uri.parse(url)); // Making the DELETE request.
    bool isSuccess =
        response.statusCode == 204; // Checking if the request was successful.
    return {"status": isSuccess}; // Returning response status.
  }
}
