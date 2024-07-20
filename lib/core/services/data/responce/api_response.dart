enum Status { LOADING, COMPLETED, ERROR }

class ApiResponse<T> {
  Status? status;
  T? data;
  String? response;

  ApiResponse(this.status, this.data, this.response);

  ApiResponse.loading() : status = Status.LOADING;
  ApiResponse.completed() : status = Status.COMPLETED;
  ApiResponse.error() : status = Status.ERROR;

  @override
  String toString() {
    return "Status : $status \n Response : $response \n Data : $data \n";
  }
}
