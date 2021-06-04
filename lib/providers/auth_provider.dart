import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:untitled1/models/http_exception.dart';

class AuthProvider with ChangeNotifier {
  String _token;
  String _expiryDate;
  String _userId;

  Future<void> _authenticate(String email, String password,
      String urlSegment) async {
    Uri _url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/$urlSegment?key=AIzaSyAI_pfaaSFhXxitGKogrRNfzr2sWXr56so');
    try{
      final response = await http.post(_url,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true,
          }));
      final responseData = json.decode(response.body);
      if (responseData['error'] != null){ //I do that as firebase is not returning errors like
        print('here');
        throw HttpException(responseData['error']['message']);
      }
    }catch(error){
      print(error);
      throw error;
    }
  }

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, 'accounts:signUp');
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, 'accounts:signInWithPassword');
  }
}
