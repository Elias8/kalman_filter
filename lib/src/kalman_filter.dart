import 'package:kalman_filter/kalman_filter.dart';

class KalmanFilter {
  Matrix stateTransition;
  Matrix observationModel;
  Matrix processNoiseCovariance;
  Matrix observationNoiseCovariance;
  Matrix observation;
  Matrix predictedState;
  Matrix predictedEstimateCovariance;
  Matrix innovation;
  Matrix innovationCovariance;
  Matrix inverseInnovationCovariance;
  Matrix optimalGain;
  Matrix stateEstimate;
  Matrix estimateCovariance;
  Matrix verticalScratch;
  Matrix smallSquareScratch;
  Matrix bigSquareScratch;

  KalmanFilter(int stateDimension, int observationDimension)
      : assert(stateDimension != null),
        assert(observationDimension != null) {
    stateTransition = Matrix(stateDimension, stateDimension);
    observationModel = Matrix(observationDimension, stateDimension);
    processNoiseCovariance = Matrix(stateDimension, stateDimension);
    observationNoiseCovariance = Matrix(
      observationDimension,
      observationDimension,
    );
    observation = Matrix(observationDimension, 1);
    predictedState = Matrix(stateDimension, 1);
    predictedEstimateCovariance = Matrix(stateDimension, stateDimension);
    innovation = Matrix(observationDimension, 1);
    innovationCovariance = Matrix(observationDimension, observationDimension);
    inverseInnovationCovariance = Matrix(
      observationDimension,
      observationDimension,
    );
    optimalGain = Matrix(stateDimension, observationDimension);
    stateEstimate = Matrix(stateDimension, 1);
    estimateCovariance = Matrix(stateDimension, stateDimension);
    verticalScratch = Matrix(stateDimension, observationDimension);
    smallSquareScratch = Matrix(observationDimension, observationDimension);
    bigSquareScratch = Matrix(stateDimension, stateDimension);
  }

  void update() {
    _predict();
    _estimate();
  }

  void _estimate() {
    observationModel.multiplyTwo(predictedState, innovation);
    observation.subtractTwo(innovation, innovation);
    predictedEstimateCovariance.multiplyByTranspose(
      observationModel,
      verticalScratch,
    );
    observationModel.multiplyTwo(verticalScratch, innovationCovariance);
    innovationCovariance
      ..addTwo(observationNoiseCovariance, innovationCovariance)
      ..destructiveInvert(inverseInnovationCovariance);
    verticalScratch.multiplyTwo(inverseInnovationCovariance, optimalGain);
    optimalGain.multiplyTwo(innovation, stateEstimate);
    stateEstimate.addTwo(predictedState, stateEstimate);
    optimalGain.multiplyTwo(observationModel, bigSquareScratch);
    bigSquareScratch
      ..subtractFromIdentityMatrix()
      ..multiplyTwo(predictedEstimateCovariance, estimateCovariance);
  }

  void _predict() {
    stateTransition
      ..multiplyTwo(stateEstimate, predictedState)
      ..multiplyTwo(estimateCovariance, bigSquareScratch);
    bigSquareScratch.multiplyByTranspose(
      stateTransition,
      predictedEstimateCovariance,
    );
    predictedEstimateCovariance.addTwo(
      processNoiseCovariance,
      predictedEstimateCovariance,
    );
  }
}
