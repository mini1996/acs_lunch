class ResponseProvider {
  getResponse(
      {success = false, data, message = "No message present"}) {
    Map responseModified = {
      "success": success,
      "message": message,
      "data": data,
    };
    // print("modified response is $responseModified");
    return responseModified;
  }
}
