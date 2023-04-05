class BaseResponse<T> {
  final T? data;
  final String message;
  final bool success;

  BaseResponse({
    this.data,
    required this.message,
    required this.success,
  });

  factory BaseResponse.fromJson(Map<String, dynamic> json) {
    return BaseResponse(
      data: json['data'],
      message: json['message'],
      success: json['success'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data,
      'message': message,
      'success': success,
    };
  }
}
