class Matrix {
  final int rows;
  final int cols;
  final List<List<double>> data;

  Matrix(this.rows, this.cols) : data = _init(rows, cols);

  void addTwo(Matrix a, Matrix b) {
    assert(rows == a.rows && rows == b.rows);
    assert(cols == a.cols && cols == b.cols);
    for (int i = 0; i < a.rows; ++i) {
      for (int j = 0; j < a.cols; ++j) {
        data[i][j] = a.data[i][j] + b.data[i][j];
      }
    }
  }

  void copy(Matrix other) {
    assert(rows == other.rows && cols == other.cols);
    for (int i = 0; i < other.rows; ++i) {
      for (int j = 0; j < other.cols; ++j) {
        data[i][j] = other.data[i][j];
      }
    }
  }

  bool destructiveInvert(Matrix output) {
    output.setIdentity();
    for (int i = 0; i < rows; ++i) {
      if (data[i][i] == 0.0) {
        int r;
        for (r = i + 1; r < rows; ++r) {
          if (data[r][i] != 0.0) break;
        }
        if (r == rows) return false;
        swapRows(i, r);
        output.swapRows(i, r);
      }

      final scalar = 1.0 / data[i][i];
      scaleRow(i, scalar);
      output.scaleRow(i, scalar);

      for (int j = 0; j < rows; ++j) {
        if (i == j) continue;
        final shear = -data[j][i];
        shearRow(j, i, shear);
        output.shearRow(j, i, shear);
      }
    }
    return true;
  }

  bool equals(Matrix other) {
    if (rows == other.rows && cols == other.cols) {
      for (int i = 0; i < rows; i++) {
        for (int j = 0; j < cols; j++) {
          if (data[i][j] != other.data[i][j]) {
            return false;
          }
        }
      }
      return true;
    }
    return false;
  }

  void multiplyByTranspose(Matrix a, Matrix b) {
    assert(rows == a.rows && rows == b.rows);
    assert(cols == a.cols && cols == b.cols);
    for (int i = 0; i < rows; ++i) {
      for (int j = 0; j < cols; ++j) {
        data[i][j] = 0.0;
        for (int k = 0; k < a.cols; ++k) {
          data[i][j] += a.data[i][k] * b.data[j][k];
        }
      }
    }
  }

  void multiplyTwo(Matrix a, Matrix b) {
    assert(rows == a.rows && rows == b.rows);
    assert(cols == a.cols && cols == b.cols);
    for (int i = 0; i < rows; ++i) {
      for (int j = 0; j < cols; ++j) {
        data[i][j] = 0.0;
        for (int k = 0; k < a.cols; ++k) {
          data[i][j] += a.data[i][k] * b.data[k][j];
        }
      }
    }
  }

  void scale(double scalar) {
    assert(scalar != 0.0);
    for (int i = 0; i < rows; ++i) {
      for (int j = 0; j < cols; ++j) {
        data[i][j] *= scalar;
      }
    }
  }

  void scaleRow(int r, double scalar) {
    assert(scalar != 0.0);
    for (int i = 0; i < cols; ++i) {
      data[r][i] *= scalar;
    }
  }

  void setIdentity() {
    assert(rows == cols);
    for (int i = 0; i < rows; ++i) {
      for (int j = 0; j < cols; ++j) {
        data[i][j] = i == j ? 1.0 : 0.0;
      }
    }
  }

  void setValue(List<double> values) {
    assert(values.length >= rows);
    for (int i = 0; i < rows; ++i) {
      for (int j = 0; j < cols; ++j) {
        final index = i * cols + j;
        if (index == values.length) break;
        data[i][j] = values[index];
      }
    }
  }

  void shearRow(int r1, int r2, double scalar) {
    assert(r1 != r2);
    for (int i = 0; i < cols; ++i) {
      data[r1][i] += scalar * data[r2][i];
    }
  }

  void subtractFromIdentityMatrix() {
    assert(rows == cols);
    for (int i = 0; i < rows; ++i) {
      for (int j = 0; j < cols; ++j) {
        data[i][j] = i == j ? 1.0 - data[i][j] : 0.0 - data[i][j];
      }
    }
  }

  void subtractTwo(Matrix a, Matrix b) {
    assert(rows == a.rows && rows == b.rows);
    assert(cols == a.cols && cols == b.cols);
    for (int i = 0; i < a.rows; ++i) {
      for (int j = 0; j < a.cols; ++j) {
        data[i][j] = a.data[i][j] - b.data[i][j];
      }
    }
  }

  void swapRows(int r1, int r2) {
    assert(r1 != r2);
    final tmp = data[r1];
    data[r1] = data[r2];
    data[r2] = tmp;
  }

  static List<List<double>> _init(int rows, int columns) =>
      List.generate(rows, (x) => List.generate(columns, (y) => 0.0));
}
