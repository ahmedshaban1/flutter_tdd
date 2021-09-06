import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tddcourse/core/network/network_info.dart';

class MockDataConnectionChecker extends Mock implements DataConnectionChecker {}

void main() {
  MockDataConnectionChecker mockDataConnectionChecker;
  NetworkInfoImpl networkInfoImpl;
  setUp(() {
    mockDataConnectionChecker = MockDataConnectionChecker();
    networkInfoImpl =
        NetworkInfoImpl(dataConnectionChecker: mockDataConnectionChecker);
  });

  group("isConnected", () {
    test("should froward to call data connection checker.hasconnection",
        () async {
      //arr
      when(mockDataConnectionChecker.hasConnection)
          .thenAnswer((_) async => true);
      //act
      final results = await networkInfoImpl.isConnected;
      //assert
      verify(mockDataConnectionChecker.hasConnection);
      expect(results, true);
    });
  });
}
