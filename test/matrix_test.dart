import 'package:kalman_filter/kalman_filter.dart';
import 'package:test/test.dart';

void main() {
  group('Matrix', () {
    test('should initialize with correct rows and columns', () {
      final matrix = Matrix(2, 3);

      expect(matrix.data.length, 2);
      expect(matrix.data[0].length, 3);
      expect(matrix.data[1].length, 3);
    });

    group('addTwo', () {
      test('should add given matrices to the current one', () {
        final matrix1 = Matrix(2, 2)..setValue([2, 3, 2, 2]);
        final matrix2 = Matrix(2, 2)..setValue([3, 1, 1, 3]);
        final matrix = Matrix(2, 2)
          ..setValue([1, 2, 3, 1])
          ..addTwo(matrix1, matrix2);

        expect(matrix.data[0][0], 5);
        expect(matrix.data[0][1], 4);
        expect(matrix.data[1][0], 3);
        expect(matrix.data[1][1], 5);
      });
    });

    group('copy', () {
      test('should copy values from the given matrix to the current matrix',
          () {
        final matrix1 = Matrix(2, 2)..setValue([2, 3, 2, 2]);
        final matrix = Matrix(2, 2)..copy(matrix1);

        expect(matrix.data[0][0], 2);
        expect(matrix.data[0][1], 3);
        expect(matrix.data[1][0], 2);
        expect(matrix.data[1][1], 2);
      });
    });

    group('destructiveInvert', () {
      test('should return true', () {
        final matrix = Matrix(4, 4)
          ..setValue([
            //
            1.0, 2.0, 3.0, 4.0,
            4.0, 1.0, 7.0, 9.0,
            0.0, 0.0, -4.0, -4.0,
            2.3, 3.4, 3.1, 0.0
          ]);
        final matrix1 = Matrix(4, 4);

        expect(matrix.destructiveInvert(matrix1), isTrue);
      });
    });

    group('equals', () {
      test('should return true when two matrices are equal', () {
        final matrix = Matrix(2, 2)..setValue([2, 3, 2, 2]);
        final matrix1 = Matrix(2, 2)..setValue([2, 3, 2, 2]);

        expect(matrix.equals(matrix1), isTrue);
      });

      test('should return false when the matrices row is not equal', () {
        final matrix = Matrix(3, 0)..setValue([3, 2, 2]);
        final matrix1 = Matrix(4, 0)..setValue([2, 3, 2, 2]);

        expect(matrix.equals(matrix1), isFalse);
      });

      test('should return false when the matrices column is not equal', () {
        final matrix = Matrix(0, 3)..setValue([3, 2, 2]);
        final matrix1 = Matrix(0, 4)..setValue([2, 3, 2, 2]);

        expect(matrix.equals(matrix1), isFalse);
      });

      test('should return false when the matrices value is not equal', () {
        final matrix = Matrix(1, 4)..setValue([3, 2, 2, 2]);
        final matrix1 = Matrix(1, 4)..setValue([2, 3, 2, 2]);

        expect(matrix.equals(matrix1), isFalse);
      });
    });

    group('multiplyTwo', () {
      test('should multiply given matrices and set to the current one', () {
        final matrix1 = Matrix(2, 2)..setValue([2, 3, 2, 2]);
        final matrix2 = Matrix(2, 2)..setValue([3, 1, 1, 3]);
        final matrix = Matrix(2, 2)
          ..setValue([1, 2, 3, 1])
          ..multiplyTwo(matrix1, matrix2);

        expect(matrix.data[0][0], 9);
        expect(matrix.data[0][1], 11);
        expect(matrix.data[1][0], 8);
        expect(matrix.data[1][1], 8);
      });
    });

    group('multiplyByTranspose', () {
      test(
          'should multiply and transpose a given matrices and set to the '
          'current one', () {
        final matrix1 = Matrix(2, 2)..setValue([2, 3, 2, 2]);
        final matrix2 = Matrix(2, 2)..setValue([3, 1, 1, 3]);
        final matrix = Matrix(2, 2)
          ..setValue([1, 2, 3, 1])
          ..multiplyByTranspose(matrix1, matrix2);

        expect(matrix.data[0][0], 9);
        expect(matrix.data[0][1], 11);
        expect(matrix.data[1][0], 8);
        expect(matrix.data[1][1], 8);
      });
    });

    group('scale', () {
      test('should scale a matrix with a given scalar', () {
        final matrix = Matrix(2, 2)
          ..setValue([3, 4, 1, 0])
          ..scale(2);

        expect(matrix.data[0][0], 6);
        expect(matrix.data[0][1], 8);
        expect(matrix.data[1][0], 2);
        expect(matrix.data[1][1], 0);
      });
    });

    group('scaleRow', () {
      test('should scale a row in matrix with a given scalar', () {
        final matrix = Matrix(2, 2)
          ..setValue([3, 4, 2.5, 4])
          ..scaleRow(1, 3);

        expect(matrix.data[0][0], 3);
        expect(matrix.data[0][1], 4);
        expect(matrix.data[1][0], 7.5);
        expect(matrix.data[1][1], 12);
      });
    });

    group('setIdentity', () {
      test('should change the matrix to identity matrix', () {
        final matrix = Matrix(3, 3)
          ..setValue([1, 2, 3, 4, 5, 6, 7, 8, 9])
          ..setIdentity();

        expect(matrix.data[0][0], 1);
        expect(matrix.data[1][1], 1);
        expect(matrix.data[2][2], 1);
      });
    });

    group('setValue', () {
      test('should set value at the correct row and column', () {
        final matrix = Matrix(2, 2)..setValue([1, 2, 3, 4]);

        expect(matrix.data[0][0], 1);
        expect(matrix.data[0][1], 2);
        expect(matrix.data[1][0], 3);
        expect(matrix.data[1][1], 4);
      });

      test('should set only the first row of the matrix', () {
        final matrix = Matrix(2, 2)..setValue([1, 2]);

        expect(matrix.data[0][0], 1);
        expect(matrix.data[0][1], 2);
        expect(matrix.data[1][0], 0);
        expect(matrix.data[1][1], 0);
      });
    });

    group('shearRow', () {
      test('should shear a matrix', () {
        final matrix = Matrix(3, 3)
          ..setValue([1.5, 2, 8, 4, 5, 1, 5, 9, 8])
          ..shearRow(1, 2, 2.5);

        expect(matrix.data[0][0], 1.5);
        expect(matrix.data[0][1], 2);
        expect(matrix.data[0][2], 8);
        expect(matrix.data[1][0], 16.5);
        expect(matrix.data[1][1], 27.5);
        expect(matrix.data[1][2], 21);
        expect(matrix.data[2][0], 5);
        expect(matrix.data[2][1], 9);
        expect(matrix.data[2][2], 8);
      });
    });

    group('subtractTwo', () {
      test(
          'should subtract given matrices and set result to the current matrix',
          () {
        final matrix1 = Matrix(2, 2)..setValue([2, 3, 2, 2]);
        final matrix2 = Matrix(2, 2)..setValue([3, 1, 1, 3]);
        final matrix = Matrix(2, 2)
          ..setValue([1, 2, 3, 1])
          ..subtractTwo(matrix1, matrix2);

        expect(matrix.data[0][0], -1);
        expect(matrix.data[0][1], 2);
        expect(matrix.data[1][0], 1);
        expect(matrix.data[1][1], -1);
      });
    });

    group('subtractFromIdentityMatrix', () {
      test('should subtract form identity matrix', () {
        final matrix = Matrix(3, 3)
          ..setValue([1, 2, 3, 4, 5, 6, 7, 8, 9])
          ..subtractFromIdentityMatrix();

        expect(matrix.data[0][0], 0);
        expect(matrix.data[0][1], -2);
        expect(matrix.data[0][2], -3);
        expect(matrix.data[1][0], -4);
        expect(matrix.data[1][1], -4);
        expect(matrix.data[1][2], -6);
        expect(matrix.data[2][0], -7);
        expect(matrix.data[2][1], -8);
        expect(matrix.data[2][2], -8);
      });
    });

    group('swapRows', () {
      test('should swap rows', () {
        final matrix = Matrix(2, 2)
          ..setValue([1, 2, 3, 4])
          ..swapRows(0, 1);

        expect(matrix.data[0][0], 3);
        expect(matrix.data[0][1], 4);
        expect(matrix.data[1][0], 1);
        expect(matrix.data[1][1], 2);
      });
    });
  });
}
