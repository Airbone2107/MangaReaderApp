import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:manga_reader_app/data/models/user_model.dart';
import 'package:manga_reader_app/data/services/user_api_service.dart';
import 'package:manga_reader_app/data/storage/secure_storage_service.dart';
import 'package:mockito/mockito.dart';

import '../../mocks.mocks.dart';

void main() {
  // Bắt buộc phải có dòng này ở đầu để khởi tạo binding cho các test
  // sử dụng platform channels như flutter_secure_storage
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockClient mockHttpClient;
  late UserApiService userApiService;
  late MockGoogleSignInAccount mockGoogleSignInAccount;
  late MockGoogleSignInAuthentication mockGoogleSignInAuthentication;

  // Giả lập giá trị cho secure storage
  final Map<String, String> mockStorage = <String, String>{};

  // Mock platform channel cho flutter_secure_storage
  // SỬA LỖI: Cập nhật đúng tên channel từ log lỗi
  const MethodChannel('plugins.it_nomads.com/flutter_secure_storage')
      .setMockMethodCallHandler((MethodCall methodCall) async {
    switch (methodCall.method) {
      case 'write':
        mockStorage[methodCall.arguments['key'] as String] =
        methodCall.arguments['value'] as String;
        return null;
      case 'read':
        return mockStorage[methodCall.arguments['key'] as String];
      case 'delete':
        mockStorage.remove(methodCall.arguments['key'] as String);
        return null;
      case 'deleteAll':
        mockStorage.clear();
        return null;
      default:
        return null;
    }
  });

  setUp(() {
    mockHttpClient = MockClient();
    userApiService = UserApiService(client: mockHttpClient);
    mockGoogleSignInAccount = MockGoogleSignInAccount();
    mockGoogleSignInAuthentication = MockGoogleSignInAuthentication();
    mockStorage.clear(); // Xóa storage trước mỗi test
  });

  group('UserApiService', () {
    const String dummyToken = 'dummy_auth_token';
    const String dummyGoogleIdToken = 'dummy_google_id_token';

    group('signInWithGoogle', () {
      setUp(() {
        when(mockGoogleSignInAccount.authentication)
            .thenAnswer((_) async => mockGoogleSignInAuthentication);
      });

      test('thành công và lưu token khi API trả về 200', () async {
        // Arrange
        when(mockGoogleSignInAuthentication.idToken)
            .thenReturn(dummyGoogleIdToken);
        when(
          mockHttpClient.post(
            any,
            headers: anyNamed('headers'),
            body: anyNamed('body'),
          ),
        ).thenAnswer(
              (_) async => http.Response(jsonEncode({'token': dummyToken}), 200),
        );

        // Act
        await userApiService.signInWithGoogle(mockGoogleSignInAccount);

        // Assert
        final String? savedToken = await SecureStorageService.getToken();
        expect(savedToken, dummyToken);
      });

      test('ném ra Exception nếu google idToken là null', () async {
        // Arrange
        when(mockGoogleSignInAuthentication.idToken).thenReturn(null);

        // Act & Assert
        expect(
              () => userApiService.signInWithGoogle(mockGoogleSignInAccount),
          throwsA(
            isA<Exception>().having(
                  (e) => e.toString(),
              'message',
              contains('Không lấy được idToken từ Google'),
            ),
          ),
        );
      });

      test('ném ra HttpException nếu API trả về lỗi khác 200', () async {
        // Arrange
        when(mockGoogleSignInAuthentication.idToken)
            .thenReturn(dummyGoogleIdToken);
        when(
          mockHttpClient.post(
            any,
            headers: anyNamed('headers'),
            body: anyNamed('body'),
          ),
        ).thenAnswer((_) async => http.Response('Unauthorized', 401));

        // Act & Assert
        // Sửa lại: Ném ra HttpException chứ không phải Exception chung chung
        expect(
              () => userApiService.signInWithGoogle(mockGoogleSignInAccount),
          throwsA(
            isA<HttpException>().having(
                  (e) => e.message,
              'message',
              contains('Đăng nhập thất bại: 401'),
            ),
          ),
        );
      });
    });

    group('getUserData', () {
      final userJson = {
        "_id": "id",
        "googleId": "googleId",
        "email": "email",
        "displayName": "displayName",
        "followingManga": <String>[],
        "readingManga": <dynamic>[],
        "createdAt": DateTime.now().toIso8601String()
      };

      test('trả về User khi gọi API thành công', () async {
        // Arrange
        await SecureStorageService.saveToken(dummyToken);
        when(mockHttpClient.get(any, headers: anyNamed('headers')))
            .thenAnswer((_) async => http.Response(jsonEncode(userJson), 200));

        // Act
        final User result = await userApiService.getUserData();

        // Assert
        expect(result, isA<User>());
        expect(result.email, 'email');
      });

      test('ném ra HttpException với mã lỗi 403', () async {
        // Arrange
        await SecureStorageService.saveToken(dummyToken);
        when(mockHttpClient.get(any, headers: anyNamed('headers')))
            .thenAnswer((_) async => http.Response('Forbidden', 403));

        // Act & Assert
        expect(
          userApiService.getUserData(),
          throwsA(
            predicate((e) => e is HttpException && e.message == '403'),
          ),
        );
      });

      test('ném ra HttpException nếu không tìm thấy token', () async {
        // Act & Assert
        expect(
          userApiService.getUserData(),
          throwsA(
            predicate(
                  (e) => e is HttpException && e.message == 'Không tìm thấy token',
            ),
          ),
        );
      });
    });

    group('addToFollowing', () {
      test('thành công nếu API trả về 200', () async {
        await SecureStorageService.saveToken(dummyToken);
        when(mockHttpClient.post(
          any,
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        )).thenAnswer((_) async => http.Response('{}', 200));

        // Act: Không có lỗi nào được ném ra là thành công
        await userApiService.addToFollowing('manga-id');

        // Assert:
        verify(mockHttpClient.post(
          any,
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        )).called(1);
      });

      test('ném ra HttpException nếu API trả về lỗi khác 200', () async {
        await SecureStorageService.saveToken(dummyToken);
        when(mockHttpClient.post(
          any,
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        )).thenAnswer(
              (_) async => http.Response('{"message": "Error"}', 400),
        );

        expect(
          userApiService.addToFollowing('manga-id'),
          throwsA(isA<HttpException>()),
        );
      });
    });
  });
}