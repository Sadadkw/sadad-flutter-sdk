
abstract class SadadService {
  Future<dynamic> generateRefreshToken({required final String clientKey, required final String clientSecret});
  Future<dynamic> generateAccessToken({required final String refreshToken});
  Future<dynamic> createInvoice({required final invoices, required final token});
  Future<dynamic> getInvoice({required String invoiceId, required final token});
}
